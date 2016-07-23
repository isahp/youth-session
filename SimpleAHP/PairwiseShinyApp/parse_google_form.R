#' The code to parse a dataframe that is the output from a google form
#' that has been setup "correctly".
#' 

#' We assume the format of the data frame is
#' colnames = useful names
#' colnames of form A versus B have pairwise information on A versus B.
#' rownames, if they exist are the username
#' any colname not of the form A versus B is assumed to be demographic data
#' of the voter.
#' 

source("basics.R")
#'If a vote string matches the given name, we get that value
Text_To_Value_Map = c("much better"=Much_Better_Value, 
                      "better"=Better_Value, 
                      "equal" = 1, "same" = 1)
Text_To_Sym_Value_Map = c("much better"=Symbolic_Much_Better_Value,
                          "better"=Symbolic_Better_Value,
                          "equal" = Symbolic_Equals_Value, 
                          "same" = Symbolic_Equals_Value)

glset_googleform_df <- function(g_df) {
  g_df = googleform_handle_diff_formats(g_df)
  glset_pairwise_googleform_df(g_df)
  glset_vote_priorities(lapply(Vote_Pairwises, FUN=function(x) eigen_largest(x)))
  glset_voters(names(Vote_Priorities))
  glset_voter_demographics(get_demographic_table_googleform(g_df))
  glset_voter_group_participants(get_group_participants(Voter_Demographics))
  glset_group_pairwises(lapply(Voter_Group_Participants, FUN = function(x) Vote_Pairwises[x]))
  glset_group_priorities(lapply(Group_Pairwises, FUN = function(x) eigen_largest(x)))
  glset_overall_priorities(eigen_largest(Vote_Pairwises))
}

get_demographic_table_googleform <- function(g_df) {
  dc = get_google_demographic_cols(g_df)
  ignore_cols = c("Timestamp", "Name", "name", "Names", "names")
  demo_cols = setdiff(dc, ignore_cols)
  rval = g_df[demo_cols]
  for(col in colnames(rval))
    rval[[col]]=as.factor(rval[[col]])
  rownames(rval) <- get_usernames_googleform(g_df)
  return(rval)
}

glset_pairwise_googleform_df <- function(g_df) {
  pw_cols = get_google_pairwise_cols(g_df)
  demo_cols = get_google_demographic_cols(g_df)
  alt_names = get_altnames_from_cols(pw_cols)
  nalts = length(alt_names)
  #First get the pairwise matrices
  print("before loop")
  #I need usernames, either it exists in the dataframe
  users = get_usernames_googleform(g_df)
  #Make sure the usernames are unique
  users=make.unique(users)
  nusers = length(users)
  list_of_pws = list()
  list_of_sym_pws = list()
  for(row in 1:nusers) {
    rval = get_pairwise_from_google_row(g_df[row,], alt_names, pw_cols)
    list_of_pws[[users[[row]]]]=rval
    list_of_sym_pws[[users[[row]]]]=
      get_pairwise_from_google_row(g_df[row,], alt_names, pw_cols, use_symbolic = TRUE)
  }
  glset_all_alts(alt_names)
  glset_vote_pairwises(list_of_pws)
  glset_vote_sym_pairwises(list_of_sym_pws)
  #print(pw_cols)
  #print(alt_names)
  #print(list_of_sym_pws)
  return(rval)
}

get_usernames_googleform <- function(g_df) {
  df_username_col = get_google_user_name_col(g_df)
  users = c()
  nusers = nrow(g_df)
  if (is.na(df_username_col)) {
    #No user name column, create a default set of user names
    users = lapply(1:nusers, FUN=function(x) "User")
  } else {
    users = g_df[[df_username_col]]
  }
  users = make.unique(users)
  return(users)
}
get_google_user_name_col <- function(g_df) {
  cnames = colnames(g_df)
  if ("Names" %in% cnames) {
    return("Names")
  } else if ("Name" %in% cnames) {
    return("Name")
  } else {
    return(NA)
  }
}
get_pairwise_from_google_row <- function(g_row, alt_names, pw_cols, use_symbolic = FALSE) {
  nalts = length(alt_names)
  rval = diag(nalts)
  dimnames(rval) <- list(alt_names, alt_names)
  for(pw_col in pw_cols) {
    alts = get_pairwise_cols_from_google_col(pw_col)
    string_vote = g_row[pw_col]
    num_vote = get_google_vote_val(string_vote, alts[[1]], alts[[2]], use_symbolic)
    #print(paste("working on col ", pw_col, " vote = ",string_vote, " num_vote = ", num_vote, "use_symbolic=", use_symbolic))
    if (!is.na(num_vote)) {
      rval[alts[1], alts[2]] = num_vote
      if (!use_symbolic)
        rval[alts[2], alts[1]] = 1/num_vote
      else
        rval[alts[2], alts[1]] = opposite_sym_vote(num_vote)
    }
  }
  #print(paste("use_symbolic=", use_symbolic, " Return matrix follows:"))
  #print(rval)
  return(rval)
}
get_pairwise_cols_from_google_col <- function(col_name) {
  info = strsplit(col_name, " [Vv][Ee][Rr][Ss][Uu][Ss] ")[[1]]
  info = lapply(info, FUN=function(x) trimws(x))
  info = as.character(info)
  return(info)
}

is_google_pairwise_col <- function(x) {
  return(grepl(" versus ", x, ignore.case = TRUE))
}

get_google_pairwise_cols <- function(g_df) {
  cols = colnames(g_df)
  rval = lapply(cols, FUN=is_google_pairwise_col)
  return(as.character(cols[as.logical(rval)]))
}

get_google_demographic_cols <- function(g_df) {
  cols = colnames(g_df)
  rval = lapply(cols, FUN=is_google_pairwise_col)
  return(cols[!as.logical(rval)])
}

vote_text_to_value <- function(text, use_symbolic = FALSE) {
  for(pattern in names(Text_To_Value_Map)) {
    if (grepl(pattern, text, ignore.case = TRUE)) {
      if (!use_symbolic)
        return(Text_To_Value_Map[[pattern]])
      else
        return(Text_To_Sym_Value_Map[[pattern]])
    }
  }
  #Okay not a >>, >, <<, <, E type vote, try pure numerical
  numVote = string_fraction_to_val(text)
  if (!is.na(numVote)) {
    #Okay, it was numeric, let's return it
    return(numVote)
  }
  #Could not do this one, just give up
  return(NA)
}

get_altnames_from_cols <- function(the_colnames) {
  rval = vector(mode="character")
  for(a_col in the_colnames)
    rval = union(rval, get_pairwise_cols_from_google_col(a_col))
  as.character(rval)
}

get_google_vote_val <- function(g_vote, dom_alt, rec_alt, use_symbolic = FALSE) {
  if (!use_symbolic) {
    if (grepl(dom_alt, g_vote, fixed = TRUE)) {
      return(vote_text_to_value(g_vote))
    } else if (grepl(rec_alt, g_vote, fixed = TRUE)) {
      return(1/vote_text_to_value(g_vote))
    } else {
      return(vote_text_to_value(g_vote))
    }
  } else {
    if (grepl(dom_alt, g_vote, fixed = TRUE)) {
      return(vote_text_to_value(g_vote, use_symbolic = TRUE))
    } else if (grepl(rec_alt, g_vote, fixed = TRUE)) {
      return(opposite_sym_vote(vote_text_to_value(g_vote, use_symbolic = TRUE)))
    } else {
      return(vote_text_to_value(g_vote, use_symbolic = TRUE))
    }
  }
}

googleform_handle_diff_formats <- function(g_df) {
  thecolNames = colnames(g_df)
  if (anyDuplicated(thecolNames) <= 0) {
    #No duplicated columns, so this is standard format
    return(g_df)
  } else {
    #We have some A versus B questions with two parts, which is better, and by how much
    #For each of these, we have to coalesce them into a single column.
    #So I'm going to loop over columns, see if that particular column is duplicated
    #And if so, coalesce it into a new column
    deduped = g_df
    handledCols = list()
    for(colname in colnames(g_df)) {
      colNameAt = which(thecolNames == colname)
      if (!(colname %in% handledCols) &&
        (length(colNameAt) > 1) && (grepl("versus", colname, ignore.case = TRUE))) {
        #This column name occurs more than once.  Now we need to figure out which
        #column is the "A is better" column and which is the "A is better by 6" column
        
        #We only consider the first and second column
        firstCol = colNameAt[1]
        secondCol = colNameAt[2]
        coalescedCol = googleform_dominance_plus_vote_to_vote(g_df, colname, firstCol, secondCol)
        #Okay remove these dupes
        deduped[,colname] = NULL
        #Add in the coalesced
        deduped[,colname] = coalescedCol
        #Don't forget to note we have taken care of this column.
        handledCols[length(handledCols)+1] = colname
      }
      
    }
  }
  deduped
}


googleform_dominance_plus_vote_to_vote <- function(g_df, colname, firstColIndex, secondColIndex) {
  alts = strsplit(colname, "versus", fixed=TRUE)[[1]]
  altA = trimws(alts[1])
  altB = trimws(alts[2])
  firstCol = g_df[,firstColIndex]
  secondCol = g_df[,secondColIndex]
  #Which column is the dominance one?  It should have the words altA, altB, or "equals" in it
  if (is_dominance_col(firstCol, altA, altB)) {
    domCol = firstCol
    numberCol = secondCol
  } else if (is_dominance_col(secondCol, altA, altB)) {
    domCol = secondCol
    numberCol = firstCol
  } else {
    stop("Could not find dominance column")
  }
#   print("First Column:")
#   print(firstCol)
#   print("Second Column:")
#   print(secondCol)
#   print("The col name:")
#   print(colname)
#   print("AltA:")
#   print(altA)
#   print("AltB:")
#   print(altB)
  rval = numberCol
  for(i in 1:length(rval)) {
    if (grepl(altB, domCol[[i]])) {
      #Inverted vote, i.e. altB was better.
      rval[i] = 1.0 / string_fraction_to_val(rval[i])
    } else if (grepl(altA, domCol[[i]])) {
      # Regular vote
      rval[i] = string_fraction_to_val(rval[i])
    } else {
      #Neither alternative name was in this string, assume they meant equals
      rval[i] = 1.0
    }
  }
  #print("Vote Column:")
  #print(rval)
  return(rval)
}

is_dominance_col <- function(col, altA, altB) {
  any(grepl(altA, col, fixed = TRUE)) ||
    any(grepl(altB, col, fixed = TRUE))||
    any(grepl("equal", col, fixed = TRUE))
}
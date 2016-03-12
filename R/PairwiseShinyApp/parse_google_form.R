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

source('set-globals.R')
#'If a vote string matches the given name, we get that value
Text_To_Value_Map = c("much better"=Much_Better_Value, 
                      "better"=Better_Value, 
                      "equal" = 1, "same" = 1)

glset_googleform_df <- function(g_df) {
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
  for(row in 1:nusers) {
    rval = get_pairwise_from_google_row(g_df[row,], alt_names, pw_cols)
    list_of_pws[[users[[row]]]]=rval
  }
  glset_all_alts(alt_names)
  glset_vote_pairwises(list_of_pws)
  print(pw_cols)
  print(alt_names)
  print(list_of_pws)
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
get_pairwise_from_google_row <- function(g_row, alt_names, pw_cols) {
  nalts = length(alt_names)
  rval = diag(nalts)
  dimnames(rval) <- list(alt_names, alt_names)
  for(pw_col in pw_cols) {
    alts = get_pairwise_cols_from_google_col(pw_col)
    string_vote = g_row[pw_col]
    num_vote = get_google_vote_val(string_vote, alts[[1]], alts[[2]])
    print(paste("working on col ", pw_col, " vote = ",string_vote, " num_vote = ", num_vote))
    if (!is.na(num_vote)) {
      rval[alts[1], alts[2]] = num_vote
      rval[alts[2], alts[1]] = 1/num_vote
    }
  }
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

vote_text_to_value <- function(text) {
  for(pattern in names(Text_To_Value_Map)) {
    if (grepl(pattern, text, ignore.case = TRUE)) {
      return(Text_To_Value_Map[[pattern]])
    }
  }
  return(NA)
}

get_altnames_from_cols <- function(the_colnames) {
  rval = vector(mode="character")
  for(a_col in the_colnames)
    rval = union(rval, get_pairwise_cols_from_google_col(a_col))
  as.character(rval)
}

get_google_vote_val <- function(g_vote, dom_alt, rec_alt) {
  if (grepl(dom_alt, g_vote, fixed = TRUE)) {
    return(vote_text_to_value(g_vote))
  } else if (grepl(rec_alt, g_vote, fixed = TRUE)) {
    return(1/vote_text_to_value(g_vote))
  } else {
    return(vote_text_to_value(g_vote))
  }
}
library(openxlsx)
library(googlesheets)
source("common-fxs.R")
source("set-globals.R")
#Voter spreadsheets will be created initially
Vote_Dataframes = list()
All_Alts = list()
Vote_Pairwises = list()
Vote_Priorities = list()
Voter_Demographics = list()
Voter_Group_Participants = list()
Group_Pairwises = list()
Overall_Priorities = list()
ERROR_MSGS_PARSE = list()
#The Voting Table
Voting_Symbolic_String_Values = c(">>" = Symbolic_Much_Better_Value_Opposite, 
                         ">"= Symbolic_Better_Value_Opposite, 
                         "E"=Symbolic_Equals_Value, 
                         "e"=Symbolic_Equals_Value, 
                         "<"=Symbolic_Better_Value, 
                         "<<"=Symbolic_Much_Better_Value)
Voting_String_Values = c(">>" = Much_Better_Value, 
                                  ">"= Better_Value,
                                  "E"=1, "e"=1,
                                  "<"=1./Better_Value,
                                  "<<"=1./Much_Better_Value)
################################################
####Start defining some useful functions.    ###
################################################

get_voter_spreadsheets <- function(xlsxFile = Input_Votes_File) {
  sheetNames = getSheetNames(xlsxFile)
  rval = list()
  for(sheetName in sheetNames) {
    if (tolower(trimws(sheetName)) != "info")
      rval[[sheetName]] = read.xlsx(xlsxFile, sheet = sheetName, colNames = FALSE)
  }
  return(rval)
}

get_voter_spreadsheets_gs <- function(g_url) {
  ginfo = gs_url(g_url)
  sheetNames = gs_ws_ls(ginfo)
  rval = list()
  wsNumb = 1
  for(sheetName in sheetNames) {
    if (tolower(trimws(sheetName)) != "info")
      rval[[sheetName]] = gs_read(ginfo, ws = wsNumb, col_names = FALSE)
    wsNumb = wsNumb + 1
  }
  return(rval)
}

get_demographic_table <- function(xlsxFile = Input_Votes_File) {
  sheetNames = getSheetNames(xlsxFile)
  print("Getting demo")
  if ("info" %in% sheetNames) {
    a_df = read.xlsx(xlsxFile, sheet="info", rowNames = TRUE, colNames = TRUE)
    for(col in 1:ncol(a_df)) {
      if ("character" %in% class(a_df[[col]])) {
        a_df[[col]] = as.factor(a_df[[col]])
      } else if ("integer" %in% class(a_df[[col]])) {
        a_df[[col]] = as.factor(a_df[[col]])
      } else if (all(a_df[[col]] == as.integer(a_df[[col]]))) {
        a_df[[col]] = as.factor(a_df[[col]])
      }
    }
    return(a_df)
  } else {
    return(list())
  }
}

get_demographic_table_gs <- function(url) {
  ginfo = gs_url(url)
  sheetNames = gs_ws_ls(ginfo)
  if ("info" %in% sheetNames) {
    infoIndex = match("info", sheetNames)
    a_df = gs_read(ginfo, ws = infoIndex, col_names = TRUE)
    rownames(a_df) <- a_df[[1]]
    a_df[[1]]<-NULL
    for(col in 1:ncol(a_df)) {
      if ("character" %in% class(a_df[[col]])) {
        a_df[[col]] = as.factor(a_df[[col]])
      } else if ("integer" %in% class(a_df[[col]])) {
        a_df[[col]] = as.factor(a_df[[col]])
      } else if (all(a_df[[col]] == as.integer(a_df[[col]]))) {
        a_df[[col]] = as.factor(a_df[[col]])
      }
    }
    return(a_df)
  } else {
    return(list())
  }
}

get_allnames_from_dataframes <- function(list_of_df) {
  rval = vector(mode="character")
  for(a_df in list_of_df) {
    next_list = get_names_from_dataframe(a_df)
    rval = union(rval, next_list)
  }
  return(rval)
}

get_pairwise_from_sym <- function(sym) {
  listOfNames <- dimnames(sym)[[1]]
  size <- length(listOfNames)
  rval <- matrix(nrow=size, ncol=size, dimnames = list(listOfNames, listOfNames))
  #Init to zero
  rval[] = 0
  #Init diagonal to 1
  for(i in 1:size)
    rval[i,i]=1.0
  for(row in 1:(size-1)) {
    for(col in (row+1):size) {
      rval[row,col]=get_vote_from_sym(sym[row,col])
      rval[col,row]=get_vote_from_sym(sym[col,row])
    }
  }
  rval
}

get_vote_from_sym <- function(val) {
  if (val == Symbolic_Equals_Value) {
    return(1)
  } else if (val == Symbolic_Better_Value) {
    return(Better_Value)
  } else if (val == Symbolic_Much_Better_Value) {
    return(Much_Better_Value)
  } else if (val == Symbolic_Better_Value_Opposite) {
    return(1./Better_Value)
  } else if (val == Symbolic_Much_Better_Value_Opposite) {
    return(1./Much_Better_Value)
  } else if (val >= 0) {
    #This is just a pure numeric vote, return it
    return(val)
  } else {
    print(paste0("I hate this shiiiiiiii ", val))
    stop(paste("Unknown symbolic vote ", str(val)))
  }
}
get_pairwise_from_votes <- function(a_df, listOfNames, use_symbolic_vote = FALSE, sheet_name = "Unknown") {
  size <- length(listOfNames)
  rval <- matrix(nrow=size, ncol=size, dimnames = list(listOfNames, listOfNames))
  #Init to zero
  rval[] = 0
  #Init diagonal to 1
  for(i in 1:size)
    rval[i,i]=1.0
  #Iterate over rows of the data frame
  for(entry in 1:nrow(a_df)) {
    rowName = a_df[entry, 1]
    colName = a_df[entry, 3]
    val = a_df[[entry, 2]]
    #print(paste0("Val=", val, " class=", class(val)))
    rowIndex = match(rowName, listOfNames)
    colIndex = match(colName, listOfNames)
    if (!is.na(colName)) {
      if (is.na(rowIndex))
        stop(paste("Row ", rowName, "does not exist"))
      if (is.na(colIndex))
        stop(paste("Col ", colName, "does not exist"))
      rval[rowIndex, colIndex] = string_vote_value(val, use_symbolic_vote, rowName, colName, sheet_name)
      if (use_symbolic_vote)
        rval[colIndex, rowIndex] = opposite_sym_vote(string_vote_value(val, use_symbolic_vote, rowName, colName, sheet_name))
      else
        rval[colIndex, rowIndex] = 1/string_vote_value(val, use_symbolic_vote, rowName, colName, sheet_name)
    }
  }
  return(rval)
}

get_allpairwise_from_votes <- function(list_of_dfs, list_of_names, use_symbolic = FALSE) {
  rval = list()
  for(df_name in names(list_of_dfs)) {
    a_df = list_of_dfs[[df_name]]
    rval[[df_name]] = get_pairwise_from_votes(a_df, list_of_names, use_symbolic, df_name)
  }
  return(rval)
}

get_allpairwise_from_sym <- function(list_syms) {
  rval = list()
  for(sym_name in names(list_syms)) {
    sym = list_syms[[sym_name]]
    #print("Working on symbolic matrix")
    #print(sym_name)
    #print(sym)
    rval[[sym_name]] = get_pairwise_from_sym(sym)
  }
  #print(rval)
  return(rval)
}

string_vote_value <- function(sVote, use_symbolic_value = FALSE
                              , rowName, colName, sheet_name) {
  theNames = names(Voting_String_Values)
  if (sVote %in% theNames) {
    #A symbolic vote
    rval = Voting_String_Values[[sVote]]
    if (use_symbolic_value) {
      rval = Voting_Symbolic_String_Values[[sVote]]
    }
    return(rval)
  } else if (is.numeric(sVote)) {
    #Pure numeric vote, no interprettation needed, just return it
    return(sVote)
  } else if (!is.na(suppressWarnings(as.numeric(sVote)))) {
    #Pure numerical vote, but as a string, convert to a numeric type
    return(as.numeric(sVote))
  } else if (is.character(sVote)) {
    #We have a stringy vote that is not a pure #, it might be a fraction, ie. 2/3
    print(paste0("Have stringy vote=",sVote))
    rval = string_fraction_to_val(sVote)
    if (!is.na(rval)) {
      return(rval)
    }
  }
  #If we make it here, couldn't parse
  printVote = sVote
  if (is.na(printVote))
    printVote = ""
  msg = paste0("In ", sheet_name, " vote='", printVote, "' on ",rowName, 
               ", ", colName)
  if (!(msg %in% ERROR_MSGS_PARSE)) {
    newMsgs = append(ERROR_MSGS_PARSE, msg)
    assign("ERROR_MSGS_PARSE", newMsgs, envir = .GlobalEnv)
  }
  print(msg)
  if (use_symbolic_value) {
    return(Symbolic_Equals_Value)
  } else {
    return(Voting_String_Values[["E"]])
  }
}

string_fraction_to_val <- function(sVal) {
  rval = suppressWarnings(as.numeric(sVal))
  if (!is.na(rval)) {
    #Had a numeric value, no fraction, just return that
    return(rval)
  }
  if (grepl("/", sVal, fixed = TRUE)) {
    #Had fraction sign, split and get num/denom and try to parse
    #First remove any quotes
    sVal = gsub('"', '', sVal)
    sVal = gsub("'", '', sVal)
    vals = strsplit(sVal, "/")[[1]]
    num = vals[[1]]
    denom = vals[[2]]
    numVal = suppressWarnings(as.numeric(num))
    denomVal = suppressWarnings(as.numeric(denom))
    if (is.na(numVal) || is.na(denomVal)) {
      return(NA)
    } else {
      return(numVal / denomVal)
    }
  } else {
    #Not a fraction
    return(NA)
  }
}
get_names_from_dataframe <- function(the_df) {
  #First we need to get the index names
  #The are stored in the first and 3rd columns
  indexNames = vector(mode="character")
  for(row in 1:nrow(the_df)) {
    name1 = the_df[[row, 1]]
    name2 = the_df[[row, 3]]
    if ((is.na(name1) || is.na(name2))) {
      #not a valid row
    } else {
      if (!(name1 %in% indexNames))
        indexNames[[length(indexNames)+1]] = name1
      if (!(name2 %in% indexNames))
        indexNames[[length(indexNames)+1]] = name2
    }
  }
  return(indexNames)
} 

get_group_participants <- function(voter_demo_df) {
  rval = list()
  for(colName in colnames(voter_demo_df)) {
    theCol = voter_demo_df[[colName]]
    if ("factor" %in% class(theCol)) {
      #We have a factor demographic, use it
      #print(levels(theCol))
      for(alevel in levels(theCol)) {
        label = paste(colName, alevel, sep = " : ")
        indices = which(voter_demo_df[colName] == alevel)
        voters = Voters[indices]
        rval[[label]] = voters
      }
    }
  }
  return(rval)
}


#Initialize some useful variables
update_globals <- function(xlsxFile, type = "xlsx") {
  if (type == "xlsx") {
    assign("Vote_Dataframes", get_voter_spreadsheets(xlsxFile), envir = .GlobalEnv)
    glset_voter_demographics(get_demographic_table(xlsxFile = xlsxFile))
  } else if (type == "gsheet") {
    assign("Vote_Dataframes", get_voter_spreadsheets_gs(xlsxFile), envir = .GlobalEnv)
    glset_voter_demographics(get_demographic_table_gs(xlsxFile))
  }
  glset_all_alts(get_allnames_from_dataframes(Vote_Dataframes))
  glset_vote_pairwises(get_allpairwise_from_votes(Vote_Dataframes, All_Alts))
  glset_vote_sym_pairwises(get_allpairwise_from_votes(Vote_Dataframes, All_Alts, use_symbolic = TRUE))
  glset_vote_priorities(lapply(Vote_Pairwises, FUN=function(x) eigen_largest(x)))
  glset_voters(names(Vote_Priorities))
  glset_voter_group_participants(get_group_participants(Voter_Demographics))
  glset_group_pairwises(lapply(Voter_Group_Participants, FUN = function(x) Vote_Pairwises[x]))
  glset_group_priorities(lapply(Group_Pairwises, FUN = function(x) eigen_largest(x)))
  glset_overall_priorities(eigen_largest(Vote_Pairwises))
  #print(Group_Priorities)
  #print(Vote_Sym_Pairwises)
  #print(Voter_Group_Participants)
}

update_better_vote_change <- function() {
  #print(Vote_Sym_Pairwises)
  glset_vote_pairwises(get_allpairwise_from_sym(Vote_Sym_Pairwises))
  #print(Vote_Pairwises)
  glset_vote_priorities(lapply(Vote_Pairwises, FUN=function(x) eigen_largest(x)))
  glset_group_pairwises(lapply(Voter_Group_Participants, FUN = function(x) Vote_Pairwises[x]))
  glset_group_priorities(lapply(Group_Pairwises, FUN = function(x) eigen_largest(x)))
  glset_overall_priorities(eigen_largest(Vote_Pairwises))
  #print(Group_Priorities)
  #print(Vote_Sym_Pairwises)
  #print(Voter_Group_Participants)
}


getParsingErrors <- function(maxNumbErrs = 6, doClear = TRUE) {
  errs = ERROR_MSGS_PARSE
  if (length(errs) == 0) {
    #No Errors
    return(NA)
  } else {
    if (length(errs) > maxNumbErrs) {
      errs = head(errs, n = maxNumbErrs)
      errs = append(errs, "...")
    }
    title = "Problems with file, assuming equal votes there:"
    fullList = append(errs, title, after = 0)
    fullList = append(fullList, list(sep="\n"))
    msg = do.call(paste, fullList)
    if (doClear)
      assign("ERROR_MSGS_PARSE", list(), envir = .GlobalEnv)
    return(msg)
  }
}

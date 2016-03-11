library(openxlsx)
source("common-fxs.R")
# Initial Inputs
Input_Votes_File = "votes.xlsx"
#Voter spreadsheets will be created initially
Vote_Dataframes = list()
All_Alts = list()
Vote_Pairwises = list()
Vote_Priorities = list()
Voter_Demographics = list()
Voter_Group_Participants = list()
Group_Pairwises = list()
Overall_Priorities = list()
#The Voting Table
Voting_String_Values = c(">>" = 9, ">"=3, "E"=1, "e"=1, "<"=1./3, "<<"=9)
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

get_demographic_table <- function(xlsxFile = Input_Votes_File) {
  sheetNames = getSheetNames(xlsxFile)
  if ("info" %in% sheetNames) {
    a_df = read.xlsx(xlsxFile, sheet="info", rowNames = TRUE, colNames = TRUE)
    for(col in 1:ncol(a_df)) {
      if ("character" %in% class(a_df[[col]])) {
        a_df[[col]] = as.factor(a_df[[col]])
      }
    }
    return(a_df)
  } else {
    return(NA)
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

get_pairwise_from_votes <- function(a_df, listOfNames) {
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
    rowIndex = match(rowName, listOfNames)
    colIndex = match(colName, listOfNames)
    if (!is.na(colName)) {
      if (is.na(rowIndex))
        stop(paste("Row ", rowName, "does not exist"))
      if (is.na(colIndex))
        stop(paste("Col ", colName, "does not exist"))
      rval[rowIndex, colIndex] = string_vote_value(a_df[entry, 2])
      rval[colIndex, rowIndex] = 1/string_vote_value(a_df[entry, 2])
    }
  }
  return(rval)
}

get_allpairwise_from_votes <- function(list_of_dfs, list_of_names) {
  rval = list()
  for(df_name in names(list_of_dfs)) {
    a_df = list_of_dfs[[df_name]]
    rval[[df_name]] = get_pairwise_from_votes(a_df, list_of_names)
  }
  return(rval)
}
string_vote_value <- function(sVote) {
  rval = Voting_String_Values[[sVote]]
  if (is.na(rval))
    stop(paste("Unknown vote ", sVote))
  return(rval)
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
update_globals <- function() {
  assign("Vote_Dataframes", get_voter_spreadsheets(), envir = .GlobalEnv)
  assign("All_Alts", get_allnames_from_dataframes(Vote_Dataframes), envir = .GlobalEnv)
  assign("Vote_Pairwises", get_allpairwise_from_votes(Vote_Dataframes, All_Alts), envir = .GlobalEnv)
  assign("Vote_Priorities", lapply(Vote_Pairwises, FUN=function(x) eigen_largest(x)), envir = .GlobalEnv)
  assign("Voters", names(Vote_Priorities), envir = .GlobalEnv)
  assign("Voter_Demographics", get_demographic_table(), envir = .GlobalEnv)
  assign("Voter_Group_Participants", get_group_participants(voter_demo_df = Voter_Demographics), envir = .GlobalEnv)
  assign("Group_Pairwises", lapply(Voter_Group_Participants, FUN = function(x) Vote_Pairwises[x]), envir = .GlobalEnv)
  assign("Group_Priorities", lapply(Group_Pairwises, FUN = function(x) eigen_largest(x)), envir = .GlobalEnv)
  assign("Overall_Priorities", eigen_largest(Vote_Pairwises), envir = .GlobalEnv)
  print(Group_Priorities)
  #print(Voter_Group_Participants)
}
update_globals()
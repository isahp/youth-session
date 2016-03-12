Better_Value = 3.0
Much_Better_Value = 9.0

glset_better_value <- function(newVal) {
  assign("Better_Value", newVal, envir = .GlobalEnv)  
}

glset_much_better_value <- function(newVal) {
  assign("Much_Better_Value", newVal, envir = .GlobalEnv)  
}

glset_all_alts <- function(newVal) {
  assign("All_Alts", newVal, envir = .GlobalEnv)
}

glset_vote_pairwises <- function(newVal) {
  assign("Vote_Pairwises", newVal, envir = .GlobalEnv)
}

glset_vote_priorities <- function(newVal) {
  assign("Vote_Priorities", newVal, envir = .GlobalEnv)
}

glset_voters <- function(newVal) {
  assign("Voters", newVal, envir = .GlobalEnv)
}

glset_voter_demographics <- function(newVal) {
  assign("Voter_Demographics", newVal, envir = .GlobalEnv)
}

glset_voter_group_participants <- function(newVal) {
  assign("Voter_Group_Participants", newVal, envir = .GlobalEnv)
}

glset_group_pairwises <- function(newVal) {
  assign("Group_Pairwises", newVal, envir = .GlobalEnv)
}

glset_group_priorities <- function(newVal) {
  assign("Group_Priorities", newVal, envir = .GlobalEnv)
}

glset_overall_priorities <- function(newVal) {
  assign("Overall_Priorities", newVal, envir = .GlobalEnv)
}

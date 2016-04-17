Better_Value = 3.0
Much_Better_Value = 9.0
Symbolic_Equals_Value = -1
Symbolic_Better_Value = -2
Symbolic_Much_Better_Value = -3
Symbolic_Better_Value_Opposite = -4
Symbolic_Much_Better_Value_Opposite = -5
opposite_sym_vote <- function(vote) {
  if (vote == Symbolic_Much_Better_Value_Opposite) {
    return(Symbolic_Much_Better_Value)
  } else if (vote == Symbolic_Better_Value_Opposite) {
    return(Symbolic_Better_Value)
  } else if (vote == Symbolic_Much_Better_Value) {
    return(Symbolic_Much_Better_Value_Opposite)
  } else if (vote == Symbolic_Better_Value) {
    return(Symbolic_Better_Value_Opposite) 
  } else if (vote == Symbolic_Equals_Value) {
    return(Symbolic_Equals_Value)
  } else if (vote >= 0) {
    #This is a pure numerical vote, return the oppositie
    if (vote == 0) {
      return(0)
    } else {
      return(1.0/vote)
    }
  } else {
    stop(paste0("Unknown sym vote to do the opposite of ", str(vote)))
  }
}
Input_Votes_File = "votes.xlsx"


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

glset_vote_sym_pairwises <- function(newVal) {
  assign("Vote_Sym_Pairwises", newVal, envir = .GlobalEnv)
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

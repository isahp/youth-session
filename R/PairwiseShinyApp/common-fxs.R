#What is happening
will.input.convert <- function(vote) {
  if (length(vote)==1) {
    switch(vote,
           ">" = BETTER_VAL,
           ">>" = MUCH_BETTER_VAL,
           "<" = 1.0/BETTER_VAL,
           "<<" = 1.0/MUCH_BETTER_VAL,
           "e" = 1,
           "E" = 1)
  } else {
    return(sapply(vote, FUN = will.input.convert))
  }
}

as.upper.matrix <- function(listOfVals) {
  k <- length(listOfVals)
  n <- (1+sqrt(1+8*k))/2
  rval <- matrix(nrow = n, ncol = n)
  #Setup the diagonal first
  for(i in 1:n) rval[i,i]=1.0
  #Now set the values
  r <- 1
  c <- 2
  currentCol <- 2
  for(val in listOfVals) {
    rval[r,c] = val
    rval[c,r] = 1/val
    r <- r+1
    c <- c+1
    if (c > n) {
      currentCol <- currentCol+1
      r <- 1
      c <- currentCol
    }
  }
  return(rval)
}

pairwise_group_average <- function(listOfMatrices) {
  if (is.null(listOfMatrices))
    return(NULL)
  else if (all(is.na(listOfMatrices)==TRUE)) {
    print("Is it really na?")    
    return(NA)
  }
  else if ("matrix" %in% class(listOfMatrices))
    return(listOfMatrices)
  else if (length(listOfMatrices) == 0)
    return(list())
  #Okay we have a list with at least one element
  size = nrow(listOfMatrices[[1]])
  #Allocate return value
  rval = matrix(nrow=size, ncol=size, dimnames = dimnames(listOfMatrices[[1]]))
  rval[] = 0
  for(i in 1:size)
    rval[i,i]=1.0
  #Loop over every position in upper right
  for(row in 1:(size-1)) {
    for(col in (row+1):size) {
      vals = lapply(listOfMatrices, FUN = function(x) x[row,col])
      val = geometric_avg(vals)
      rval[row,col] = val
      if (val == 0)
        rval[col,row] = 0
      else
        rval[col,row] = 1/val
    }
  }
  rval
}

geometric_avg <- function(avec) {
  bvec = avec[which(avec != 0)]
  if (length(bvec) == 0)
    return(0)
  rval = 1
  for(val in bvec)
    rval = rval*abs(val)
  rval = rval ^ (1/length(bvec))
  return(rval)
}
eigen_largest <- function(matrixOrList, maxCount = NA, maxError = 1e-7, return.eigenvalue = FALSE, idealize = TRUE) {
  #If we have a group, take group average first
  if ("list" %in% class(matrixOrList)) {
    matrix = pairwise_group_average(matrixOrList)
  } else {
    matrix = matrixOrList
  }
  stopifnot("matrix" %in% class(matrix), nrow(matrix) == ncol(matrix))
  size = nrow(matrix)
  curVec <- vector(mode = "numeric", length = size)
  curVec[] = 1.0/size
  if (is.na(maxCount)) {
    maxCount = size^4
  }
  count=1
  error=size
  eigenValue = size
  nextVec = curVec
  while((count <= maxCount) && (error > maxError)) {
    nextVec = matrix %*% curVec
    eigenValue = sum(nextVec)
    nextVec = nextVec / eigenValue
    error = sum(abs(nextVec - curVec))
    count=count+1
    curVec = nextVec
  }
  if (idealize)
    nextVec = nextVec/max(nextVec)
  nextVec = nextVec[,1]
  if (return.eigenvalue) {
    return(append(nextVec, eigenValue))
  } else {
    return(nextVec)
  }
}

gs_studentPriorities <- function(gs_data, theRange, rownames) {
  rval <- data.frame(row.names = rownames)
  wsNames <- gs_ws_ls(gs_data)
  for(ws in 1:length(wsNames)) {
    wsName <- wsNames[ws]
    votes <- gs_read(gs_data, range = theRange, ws=ws, col_names=FALSE)$X2
    voteMatrix <- as.upper.matrix(will.input.convert(votes))
    priorities <- eigen_largest(voteMatrix)
    rval[,wsName] <- priorities
  }
  return(rval)
}

studentPrioritiesTable <- function(studentPriorities) {
  #Each column is a student, the rows are the alternatives.
  #We want to turn this into a table of the form
  #row, col, score, rank
  #So we need a matrix with 4 columsn and (nrows x ncols) of the
  #student priorities matrix
  rval <- matrix(nrow = nrow(studentPriorities)*ncol(studentPriorities),
                 ncol = 4)
  rval <- as.data.frame(rval)
  colnames(rval) <- c("Student", "Alt", "Score", "Rank")
  studentNames <- colnames(studentPriorities)
  altNames <- rownames(studentPriorities)
  count <- 1
  for(student in 1:length(studentNames)) {
    scores <- studentPriorities[,student]
    studentName <- studentNames[student]
    ranks <- rank(1-scores, ties.method = "min")
    for(alt in 1:length(altNames)) {
      rval[count,1] = studentName
      rval[count,2] = altNames[alt]
      rval[count,3] = scores[alt]
      rval[count,4] = ranks[alt]
      count = count + 1
    }
  }
  rval$Student = factor(rval$Student, levels = studentNames)
  rval$Alt = factor(rval$Alt, levels = altNames)
  return(rval)
}
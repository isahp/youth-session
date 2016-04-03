
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
library(gsheet)
library(googlesheets)
source("basics.R")
source('parse_google_form.R')
# Initial Inputs
list_to_string <- function(obj, listname) {
  if (is.null(names(obj))) {
    paste(listname, "[[", seq_along(obj), "]] = ", obj,
          sep = "", collapse = "\n")
  } else {
    paste(listname, "$", names(obj), " = ", obj,
          sep = "", collapse = "\n")
  }
}

Query_Form_URL = ""
shinyServer(function(input, output, cD, session) {
  update_globals(Input_Votes_File)
  observe({
    init_if_needed(input, session, clientData)
  })
  output$oneUserPlot = renderPlotly({
    update_better_vals(input)
    p <- plot_ly(
       x = All_Alts,
       y = Vote_Priorities[[input$oneUser]],
       type = input$ChartType
     )
     p
  })
  
  #The per user table
  output$oneUserTable = renderDataTable({
    #Get the user table
    update_better_vals(input)
    nUsers = length(Vote_Priorities)
    nAlts = length(All_Alts)
    mat <- matrix(nrow = nUsers, ncol = (nAlts+1))
    for(row in 1:nUsers) {
      mat[row, 1] = Voters[[row]]
      for(col in 1:nAlts) {
        mat[row, col+1] = Vote_Priorities[[row]][[col]]
      }
    }
    rval=data.frame(mat)
    colnames(rval)<-append(All_Alts, "Voter", 0)
    return(rval)        
  })
  
  #The groups table
  output$groupsTable = renderDataTable({
    #Get the user table
    update_better_vals(input)
    groupNames = names(Group_Priorities)
    nGroups = length(groupNames)
    nAlts = length(All_Alts)
    mat <- matrix(nrow = nGroups, ncol = (nAlts+1))
    for(row in 1:nGroups) {
      mat[row,1] = groupNames[[row]]
      for(col in 1:nAlts) {
        mat[row, col+1] = Group_Priorities[[row]][[col]]
      }
    }
    rval=data.frame(mat)
    colnames(rval)<-append(All_Alts, "Voters", 0)
    return(rval)        
  })
  
  #The overall table
  output$overallTable = renderTable({
    #Get the user table
    update_better_vals(input)
    nAlts = length(All_Alts)
    mat <- matrix(nrow = 1, ncol = (nAlts))
    for(col in 1:nAlts) {
      mat[1, col] = Overall_Priorities[[col]]
    }
    rval=data.frame(mat)
    colnames(rval)<-All_Alts
    print(rval)
    return(rval)        
  })
  output$overallPlot = renderPlotly({
    update_better_vals(input)
    #These aren't used, but allow us to react to things changing on file IO
    a = input$oneUser
    b = input$headToHeadUsers
    c = input$groups
    p <- plot_ly(
                 x = All_Alts,
                 y = Overall_Priorities,
                 type = input$ChartType
                 )    
    p
  })
  output$groupsPlot = renderPlotly({
    update_better_vals(input)
    groups = input$groups
    if (length(groups) == 0) {
      return()
    }
    p <- plot_ly(
      type = input$ChartType
    )
    print('Trying to update users plot')
    print(groups)
    for(user in groups) {
      values = Group_Priorities[[user]]
      print(paste("Working on user ", user))
      p <- add_trace(p,
                     x = All_Alts,
                     y = values,
                     name = user,
                     type = input$ChartType,
                     evaluate = TRUE
      )
    }
    if (length(groups) > 0)
      p
    else
      "No groups"
  })
  output$headToHeadPlot = renderPlotly({
    update_better_vals(input)
    headToHeads = input$headToHeadUsers
    if (length(headToHeads) == 0) {
      return()
    }
    p <- plot_ly(
      type = input$ChartType
    )
    for(user in headToHeads) {
      values = Vote_Priorities[[user]]
      #print(paste("Working on user ", user))
      p <- add_trace(p,
        x = All_Alts,
        y = values,
        name = user,
        type = input$ChartType,
        evaluate = TRUE
      )
    }
    p
  })
  observe({
    info = input$theFile
    if (is.null(info))
      return(NULL)
    uploadedFile = info$datapath
    update_globals(uploadedFile)
    file.remove(uploadedFile)
    update_uis(input, session)
    session$sendCustomMessage(type = "resetFileInputHandler", "theFile")
    parseErrs = getParsingErrors()
    if (!is.na(parseErrs))
      sendAlert(input = input, session = session, msg = parseErrs)
    #return(TRUE)    
  })
  gformUrlFx = eventReactive(input$gformUrlGo, {
    url = input$gformUrl
    if (is.null(url) || url == "" )
      return(TRUE)
    print("In gFormURLFX?")
    google_df = read.csv(text=gsheet::gsheet2text(url),check.names = FALSE, 
                         strip.white = FALSE, stringsAsFactors = FALSE)
    glset_googleform_df(google_df)
    update_uis(input, session)
    #return(TRUE)
  })
  observe({
    gformUrlFx()
  })
  
  gsheetUrlFx = eventReactive(input$gsheetUrlGo, {
    url = input$gsheetUrl
    if (is.null(url) || url == "" )
      return(TRUE)
    print("In gSheetURLFX?")
    update_globals(url, type = "gsheet")
    update_uis(input, session)
    session$sendCustomMessage(type = "resetFileInputHandler", "theFile")
    parseErrs = getParsingErrors()
    if (!is.na(parseErrs))
      sendAlert(input = input, session = session, msg = parseErrs)
    #return(TRUE)
  })
  observe({
    gsheetUrlFx()
  })
})

update_uis <- function(input, session) {
  updateSelectInput(session = session,
                    inputId = "oneUser",
                    choices = Voters)
  updateSelectInput(session = session,
                    inputId = "headToHeadUsers",
                    choices = Voters)
  updateSelectInput(session = session,
                    inputId = "groups",
                    choices = names(Voter_Group_Participants))
  #print(names(Voter_Group_Participants))
}

init_if_needed <- function(input, session, clientData) {
  query <- parseQueryString(session$clientData$url_search)
  
  # Return a string with key-value pairs
  print(paste(names(query), query, sep = "=", collapse=", "))
  print(query)
  print(class(query))
  if (is.null(query[["gformurl"]])) {
    print("No gformurl")
  } else {
    url = query[["gformurl"]]
     google_df = read.csv(text=gsheet::gsheet2text(url),check.names = FALSE, 
                          strip.white = FALSE, stringsAsFactors = FALSE)
     glset_googleform_df(google_df)
     update_uis(input, session)
    print(paste("gformurl was ", query["gformurl"]))
  }
  if (!is.null(query[["gsheetUrl"]])) {
    url = query[["gsheetUrl"]]
    update_globals(url, type = "gsheet")
    update_uis(input, session)
    session$sendCustomMessage(type = "resetFileInputHandler", "theFile")
    parseErrs = getParsingErrors()
    if (!is.na(parseErrs))
      sendAlert(input = input, session = session, msg = parseErrs)
  }
}

update_better_vals <-function(input) {
  if (!is.numeric(input$better))
    return()
  else if (input$better < 1)
    return()
  else if (!is.numeric(input$muchBetter))
    return()
  else if (input$muchBetter < 1)
    return()
  glset_better_value(input$better)
  glset_much_better_value(input$muchBetter)
  update_better_vote_change()
  print(Better_Value)
  print(Much_Better_Value)
  print(input$muchBetter)
  print("Updating calcs")
}

sendAlert <- function(input, session, msg) {
  session$sendCustomMessage(type = 'testmessage',
                            message = msg)
  
}

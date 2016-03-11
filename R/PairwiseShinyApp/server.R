
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
library(gsheet)
source("basics.R")
source('parse_google_form.R')

shinyServer(function(input, output, clientData, session) {

  output$oneUserPlot = renderPlotly({
     p <- plot_ly(
       x = All_Alts,
       y = Vote_Priorities[[input$oneUser]],
       type = "bar"
     )
     p
  })
  
  output$overallPlot = renderPlotly({
    #These aren't used, but allow us to react to things changing on file IO
    a = input$oneUser
    b = input$headToHeadUsers
    c = input$groups
    p <- plot_ly(type="bar",
                 x = All_Alts,
                 y = Overall_Priorities)    
    p
  })
  output$groupsPlot = renderPlotly({
    groups = input$groups
    if (length(groups) == 0) {
      return()
    }
    p <- plot_ly(type="bar")
    for(user in groups) {
      values = Group_Priorities[[user]]
      #print(paste("Working on user ", user))
      p <- add_trace(p,
                     x = All_Alts,
                     y = values,
                     name = user,
                     evaluate = TRUE
      )
    }
    p
    
  })
  output$headToHeadPlot = renderPlotly({
    headToHeads = input$headToHeadUsers
    if (length(headToHeads) == 0) {
      return()
    }
    p <- plot_ly(type="bar")
    for(user in headToHeads) {
      values = Vote_Priorities[[user]]
      #print(paste("Working on user ", user))
      p <- add_trace(p,
        x = All_Alts,
        y = values,
        name = user,
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
    file.copy(uploadedFile, Input_Votes_File, overwrite = TRUE)
    update_globals()
    update_uis(input, session)
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

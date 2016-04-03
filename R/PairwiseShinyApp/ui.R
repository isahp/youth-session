
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
library(shinyBS)
source("basics.R")

update_globals("votes.xlsx")
get_init_from_list <- function(alist, single = FALSE) {
  init = NULL
  if (single) {
    if (length(alist) == 0)
      return(init)
    else
      return(alist[1])
  }
  if (length(alist) >= 2) {
    init = alist[c(1,2)]
  } else if (length(alist) == 1) {
    init = alist[c(1)]
  }
  return(init)
}
shinyUI(fluidPage(
  #Resetting the file input after file upload
  tags$script('
    Shiny.addCustomMessageHandler("resetFileInputHandler", function(x) {      
              var id = "#" + x + "_progress";
              var fileControl = $("#"+x);
              fileControl.replaceWith( fileControl = fileControl.clone( true ) );
              var idBar = id + " .bar";
              $(id).css("visibility", "hidden");
              $(idBar).css("width", "0%");
              });
  '),
  #Handle alert messages
  singleton(
    tags$head(tags$script(src = "alert-handler.js"))
  ),
  # Application title
  titlePanel("SimpleAHP Web App"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h2("Inputs"),
      radioButtons("ChartType", label="Chart Type:", inline=TRUE,  choices=c("Bar" = "bar", "Line" = "line")),
      tabsetPanel(
        tabPanel("XLSX",
                 fileInput("theFile", label = "Excel xlsx Input File", accept = c('.xlsx'))
        ),
        tabPanel("GSheet",
                 textInput("gsheetUrl", label="URL of gspreadsheet"),
                 actionButton("gsheetUrlGo", label = "Update")
        ),
        tabPanel("Survey",
                 textInput("gformUrl", label="URL of google form spreadsheet"),
                 actionButton("gformUrlGo", label = "Update"))
      ),
      bsCollapsePanel(title="Advanced Options"
                      ,sliderInput("better", "Better's numeric value:", min=1.1, max=9.0, step= 0.1, value = 3.0),
                      sliderInput("muchBetter", "Much better's numeric value:", min=1.1, max=9.0, step=0.1, value = 9.0)
      )
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Overall",
                 plotlyOutput("overallPlot"),
                 bsCollapsePanel(title="Data Table",
                                 tableOutput("overallTable"))
        ),
        tabPanel("Individuals", 
                 selectInput("oneUser", label="Choose voter", choices = Voters), 
                 plotlyOutput("oneUserPlot"),
                 bsCollapsePanel(title="Data Table",
                                 dataTableOutput("oneUserTable"))
                 ),
        tabPanel("Head-to-Head",
                 selectInput("headToHeadUsers", "Select Voters", choices = Voters, multiple = TRUE, selectize = TRUE, selected = get_init_from_list(Voters)),
                 plotlyOutput("headToHeadPlot")),
        tabPanel("Groups", 
                 selectInput("groups", "Select Groups", choices = names(Voter_Group_Participants), multiple = TRUE, selectize = TRUE, selected = get_init_from_list(names(Voter_Group_Participants))),
                 plotlyOutput("groupsPlot"),
                 bsCollapsePanel(title="Data Table",
                                 dataTableOutput("groupsTable"))
                 
                 )
      )
    )
  )
))

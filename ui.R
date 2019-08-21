#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Factor Analysis Dashboard"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput("dataFile", "Choose ma2 File",
                      accept = c(
                          "text/plain",
                          ".ma2")
            ),
            # Horizontal line ----
            tags$hr(),
            
            radioButtons("fa",
                         "Type of Factoral Analysis:",
                         c("Factor Analysis" = "fa",
                           "Principal Components Analysis" = "pc"),
                         selected = "pc"
            ),
            # Horizontal line ----
            tags$hr(),
            
            sliderInput("nfactor",
                        "Number of Factor Componentes:",
                        min = 1,
                        max = 50,
                        value = 2),
            actionButton("LoadButton", "Load")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Raw Data", dataTableOutput("dataframe")),
                tabPanel("KMO Removed", verbatimTextOutput("KMORemovedList")),
                tabPanel("Scree Plot", plotOutput("screePlot")),
                tabPanel("Rotated Factor/Component Table"), tableOutput("rotatedTable"))
            )
        )
    )
)

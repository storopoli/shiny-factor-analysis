#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("helpers.R")

shinyServer(function(input, output, session) {
    # Load the data
    inFile <- reactive({input$dataFile})
    data <- reactive({
        if (is.null(inFile())) return(NULL)
        readr::read_tsv(inFile()$datapath)[,-1]
    })
    output$dataframe <- renderDataTable({
        input$LoadButton
        data <- isolate(data())
    }, options = list(
        pageLength=50, 
        scrollX='400px'), 
    filter = 'top')
    output$rawDataSize <- renderTable({
        input$LoadButton
        dim(data())[1]
    })
    # KMO Removal
    kmo_removed <- reactive({
        input$LoadButton
        data <- isolate(data())
        kmo_optimal_solution(df = data())})
    
    output$KMORemovedList <- renderPrint({
        require(data()) 
        kmo_optimal_solution(df = data())$removed})
    
    # Scree Plot
    output$screePlot <- renderPlot({
        require(kmo_removed()) 
        require(input$fa())
        screePlotAPA(kmo_optimal_solution(df = data())$df, fa = fa())
        })
    
    # Factor/PC Analysis
    #if (input$fa=="fa") {
    #    results <- psych::fa(data_kmo_removed, nfactors = input$nfactor, scores = T, rotate = "varimax")
    #}
    #if (input$fa=="pc") {
    #    results <- psych::principal(data_kmo_removed, nfactors = input$nfactor, scores = T, rotate = "varimax")
    #}
    #output$rotatedTable <- data.frame(
    #    unclass(results$loadings),
    #    row.names = rownames(results$weights),
    #    rownames = T,
    #    digits = 3
    #)
    })

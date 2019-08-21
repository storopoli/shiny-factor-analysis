#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
source("helpers.R")

shinyServer(function(input, output, session) {
    # Load the data
    inFile <- reactive({input$dataFile})
    data <- reactive({
        if (is.null(inFile())) return(NULL)
        data <- read.table(inFile()$datapath, sep = '\t', header = TRUE)
        data$X <- NULL
        return(data)
    })
    output$dataframe <- renderDataTable({
        input$LoadButton
        data()
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
        require(data()) 
        kmo_optimal_solution(df = data())})
    
    output$KMORemovedList <- renderTable({
        require(data()) 
        kmo_optimal_solution(df = data())$removed})
    
    # Scree Plot
    output$screePlot <- renderPlot({
        require(kmo_removed()) 
        require(input$fa)
        screePlotAPA(data = kmo_removed()$df, fa = input$fa)
        })
    
    # Factor/PC Analysis
    results <- reactive({
        require(kmo_removed())
        require(input$fa)
        require(input$nfactor)
        if (input$fa=="pc") {
            return(psych::principal(kmo_removed()$df, nfactors = input$nfactor, scores = T, rotate = "varimax"))}
        if (input$fa=="fa") {
            return(psych::fa(kmo_removed()$df, nfactors = input$nfactor, scores = T, rotate = "varimax"))}
    })
    output$rotatedTable <- renderDataTable({
        if (is.null(inFile())) return(NULL)
        data.frame(unclass(results()$loadings))},
        options = list(
            pageLength=100, 
            scrollX='400px'), 
        filter = 'top')
    })

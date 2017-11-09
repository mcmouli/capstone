## Capstone Project
## Chandramouli

#Shiny app to display the predicting words

source("processngram.R")

library(shiny)

## This is the ShineServer code to call the function wordPredict
shinyServer(function(input, output) {
        output$prediction <- renderPrint({
                result <- wordPredict(input$inputText)
                output$sentence2 <- renderText({message})
                result
                });
        output$sentence1 <- renderText({
                input$inputText});
}
)


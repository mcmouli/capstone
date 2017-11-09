
library(shiny)
library(markdown)

## SHINY UI
shinyUI(
        fluidPage(
                titlePanel( "Capstone Project - Chandramouli M"),
                mainPanel(
                       fluidRow( 
                         column(12, align="center",
                       helpText("Enter your text here"),
                       hr(),
                       textInput("inputText", "please enter you text here",value = ""),
                       hr(),
                       helpText("Once user enters the word / sentence in the input partially", 
                                "can wait for the word prediction on the right hand side panel which shows",
                                "predicted text"),
                       hr() 
                       
                       )
                       ),

                  tabsetPanel(
                         
                       tabPanel(strong("Word Prediction"),
                         verbatimTextOutput("prediction"),
                         strong("what you entered is:::"),
                        
                         strong(code(textOutput('sentence1'))),
                         br(),
                        
                         strong("what is the predicted word from the Ngrams"),
                         strong(code(textOutput('sentence2')))
                      
                      
                       ),
                       
                       tabPanel(strong("The Problem"),
                                includeHTML("ProblemStatement.html")
                                ),
                       
                      tabPanel(strong("How I processed"),
                                includeHTML("dataprocessing.html")
                                
                       )
                     )
                        
                        )
                )
        )



library(shiny)
source("prediction.R", local=TRUE)

init <- TRUE
next_word <- c()

shinyServer(
  function(input,output) {
    currentPhrase <- function(current_phrase = "my grandfather") {
      str(input$predictedWord)
      if (!is.na(input$phrase) && length(input$phrase) > 0) {
          current_phrase <- input$phrase
      }
      init <<- FALSE
      if (length(input$predictedWord) > 0 && input$predictedWord == 1) {
        current_phrase <- paste(current_phrase, next_word)
      }
      
      return(current_phrase)
    }
    
    output$phraseInput <- renderUI({
      input$predictedWord
      
      isolate({
        textInput("phrase", label = h3("Input Phrase"), value=currentPhrase())
      })
    })
    
    output$predictedButton <- renderUI({
      input$predict

      isolate({
         if(length(input$phrase) == 0) return()
         next_word <<- nextWord(input$phrase, input$context)
         actionButton("predictedWord",next_word)
      })
    })
  }
)

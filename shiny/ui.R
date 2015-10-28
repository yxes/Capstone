
shinyUI(fluidPage(
  theme = "bootstrap.css",
  titlePanel("Predictive Text Processing"),

  sidebarLayout(
    mainPanel(
      selectInput("context", label=h3("Context"),
                  choices = list("News" = "news", "Blogs" = "blogs", "Twitter" = "twitter")
      ),
      "It's important to choose the right context for your prediction.  News, Twitter and Blogs each ",
      "have different word usage, parts of speech and even slang that you will want to incorporate.  In an ",
      "automated process, the environment can tell you which type of predictions you should make but ",
      "in our app, we'll let you choose so you can review the differences.",
      br(),
      uiOutput("phraseInput"),
      br(),
      tags$head(tags$style(type="text/css", "#phrase {width: 90%}")),
      actionButton("predict", "Make Prediction"),
      br(),
      br(),
      "Enter your input phrase in the line above.  When you are ready click the 'Make Prediction' button ",
      "to see what we predict the next word would be.",
      br(),
      br()
    ),
    sidebarPanel( h3("Predicted Word"),
                uiOutput("predictedButton"),
                br(),
                "Once the word appears above here, it's built into a button.  When you click it, the word will be added to ",
                "your text and you can attempt another prediction.  In this way you can build out whole lines of predictive ",
                "text."
                  
    )
  )
))

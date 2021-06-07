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
    titlePanel("Swiss Fertility and Socioeconomic Indicators (1888) Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            h3("Slope"),
            textOutput("slopeOut"),
            h3("Intercept"),
            textOutput("intOut"),
            
            checkboxInput("withIntercept", "With Intercept", value = TRUE),
            radioButtons("col", "Kind of Class",
                         c("None" = "none",
                            "Fertility" = "fert",
                           "Catholic" = "catho"))
            
            
            #submitButton("Submit")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                type = "tabs",
                tabPanel("Examination vs Education", br(),
                         
                         plotOutput("plot1", brush = brushOpts(
                             id = "brush1"
                         ))
                         ),
                tabPanel("Histogram Education", br(),
                         sliderInput(inputId = "bins",
                                     label = "Number of bins:",
                                     min = 1,
                                     max = 50,
                                     value = 30),
                         plotOutput("plot_hist")
                         )
            )
        )
    )
))

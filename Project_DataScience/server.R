#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(datasets)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    model <- reactive({
        
        brushed_data <- brushedPoints(swiss, input$brush1, 
                                      xvar = "Education", yvar = "Examination")
        if (nrow(brushed_data) < 2){
            return(NULL)
        }
        if (input$withIntercept){
            lm(Examination~Education, data = brushed_data)
        } else {
            lm(Examination~Education - 1, data = brushed_data)
        }
        
    })
    output$slopeOut <- renderText({
        if (is.null(model())){
            "No model found"
        } else {
            if (input$withIntercept){
                model()[[1]][2]
            } else {
                model()[[1]][1]
            }
        }
    })
    output$intOut <- renderText({
        if(is.null(model())){
            "No model found"
        } else {
            if (input$withIntercept){
                model()[[1]][1]
            } else {
                "No intercept"    
            }
        }
    })
    output$plot1 <- renderPlot({
        g <- ggplot(data = swiss, aes(x = Education, y = Examination)) + geom_point()
        if (input$col == "fert") {
            g <- ggplot(data = swiss, aes(x = Education, y = Examination, color = Fertility)) + geom_point()
            
        } else if (input$col == "catho") {
            g <- ggplot(data = swiss, aes(x = Education, y = Examination, color = Catholic)) + geom_point()
        }
        
        if(!is.null(model())){
            slope_part <- 0
            intercept_part <- 0
            if (!is.null(model())){
                if (input$withIntercept){
                    slope_part<-model()[[1]][2]
                    intercept_part <- model()[[1]][1]      
                } else {
                    slope_part<-model()[[1]][1]
                    intercept_part <- 0
                }
            }
            g <- g + geom_abline(intercept = intercept_part, slope = slope_part, color="red", 
                        linetype="dashed", size=1.5)
        }
        g
    })
    
    output$plot_hist <- renderPlot({
        
        x    <- swiss$Education
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        hist(x, breaks = bins, col = "#75AADB", border = "white",
             xlab = "Waiting time to next eruption (in mins)",
             main = "Histogram of waiting times")
        
    })

})



library(shiny)
data(galton)

shinyServer(
    function(input, output) {
        output$oid1 <- renderPrint({input$id1})
        output$oid2 <- renderPrint({input$id2})
        output$odate <- renderPrint({input$date})
        output$oglucose <- renderPrint({input$glucose})
        output$opred <- renderPrint({diabetesRisk(input$glucose)})
        output$newHist <- renderPlot({
            hist(galton$child, xlab='child height', col='lightblue', main='Histogram')
            mu <- input$mu
            lines(c(mu, mu), c(0,200), col='red', lwd=5)
            mse <- mean((galton$child - mu)^2)
            text(63,150, paste('mu=',mu))
            text(63,140, paste('mse=',round(mse,2)))
        })
    }
    
)

diabetesRisk <- function(glucose) {
    return(glucose/200)
}
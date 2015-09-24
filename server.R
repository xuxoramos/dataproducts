# Libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(rCharts)

server <- function(input, output, session) {
      output$ratingsPlot <- renderChart3({
              np<- rPlot(CriticRating ~ UserRating, color=dynColor(), data=ratingByPlatform(), type='point',
                         tooltip = "#! function(item) {return 'Game: ' + item.GameName + '\\n User rating: ' + item.UserRating + '\\n Critics rating: ' + item.CriticRating} !#")
              np$set(width = 600, height = 600)
              np$guides(y = list(min = 6.5, max = 10, title='Critic Rating'), x = list(min = 4, max = 10, title='User Rating'))
              np$addParams(dom="ratingsPlot")
              np$layer(y = 'fittedByPlat', copy_layer = T, type = 'line',
                       color = dynColor(), data=ratingByPlatform())
              np$set(legendPosition = 'bottom')
              if (input$selectedPlatform == 'All') {
                      np$layer(y = 'fittedAll', copy_layer = T, type = 'line',
                               color = list(const='black'), data=ratingByPlatform(), size = list(const = 3))
              }
              return(np)
      })

#      output$ratingsNvd3Plot <- renderChart2({
#              p<- nPlot(CriticRating ~ UserRating, group=dynColor(), data=ratingByPlatform(), type='scatterChart')
#              p$params$width <- 600
#              p$params$height <- 600
#              p$chart(size = 100)
#              p$chart(showControls = FALSE)
#              p$chart(tooltipContent = "#! function(key, x, y, e) {return e.point.GameName} !#")
#              return(p)
#      })
      
      observe({
              # This will change the value of input$partnerName to searchResult()[,1]
              updateSelectInput(session, "selectedPlatform",
                              choices = platforms)
      })

      observe({
              # This will change the value of input$partnerName to searchResult()[,1]
              updateSelectInput(session, "selectedPlatform4Prediction",
                                choices = platforms)
      })
      
      dynColor <- reactive({
              col <- 'Platform'
              switch(input$selectedPlatform,
                     PS4={col <- list(const='#4A8CBC')},
                     XBoxOne={col <- list(const='#A460A8')},
                     WiiU={col <- list(const='#58B768')},
                     PC={col <- list(const='#E91937')}
                     )
              return(col)
      })
      
      ratingByPlatform <- reactive({
              if (input$selectedPlatform == 'All') {
                      dat <- data.frame(UserRating=ratings$UserRating, CriticRating=ratings$CriticRating)
                      dat$fittedByPlat <- lmRatingsByPlat$fitted.values
                      dat$GameName <- ratings$GameName
                      dat$Platform <- ratings$Platform
                      dat$fittedAll <- lmRatings$fitted.values
                      return(dat)
              }
              else {
                      dat <- ratings %>% filter(Platform == input$selectedPlatform)
                      dat$fittedByPlat <- lm(CriticRating ~ UserRating, dat)$fitted.values
                      return(dat)
              }
      })
      output$selectedPlatform <- renderText(input$selectedPlatform)
      output$prediction <- renderText(predict(lmRatings, newdata = data.frame(CriticRating=input$userRating)))
}


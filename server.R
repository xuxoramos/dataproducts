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
              np$layer(y = '_fitted', copy_layer = T, type = 'line',
                       color = dynColor(), data=ratingByPlatform())
              np$set(legendPosition = 'bottom')
              return(np)
      })

      output$ratingsNvd3Plot <- renderChart2({
              p<- nPlot(CriticRating ~ UserRating, group=dynColor(), data=ratingByPlatform(), type='scatterChart')
              return(p)
      })
      
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
                     PS4={col <- list(const='blue')},
                     XBoxOne={col <- list(const='green')},
                     WiiU={col <- list(const='purple')},
                     PC={col <- list(const='red')}
                     )
              return(col)
      })
      
      ratingByPlatform <- reactive({
              if (input$selectedPlatform == 'All') {
                      dat <- fortify(lm(CriticRating ~ UserRating * Platform, ratings))
                      dat$GameName <- ratings$GameName
                      dat$Platform <- ratings$Platform
                      names(dat) <- gsub('\\.', '_', names(dat))
                      return(dat)
              }
              else {
                      tempRatings <- ratings %>% filter(Platform == input$selectedPlatform)
                      dat <- fortify(lm(CriticRating ~ UserRating, tempRatings))
                      dat$GameName <- tempRatings$GameName
                      dat$Platform <- tempRatings$Platform
                      names(dat) <- gsub('\\.', '_', names(dat))
                      return(dat)
              }
      })
      
      output$selectedPlatform <- renderText(input$selectedPlatform)
}
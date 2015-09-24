# Libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(rCharts)

server <- function(input, output, session) {
        
        pred <- reactive({
                if (input$selectedPlatform == 'All') {
                        selectedModel <- lmRatings
                }
                else {
                        selectedModel <- lmRatingsByPlat
                }
                return(
                        predict(
                                selectedModel,
                                newdata = data.frame(
                                        UserRating = input$userRating,
                                        Platform = input$selectedPlatform
                                )
                        )
                )
        })
        
        observe({
                updateSelectInput(session, "selectedPlatform",
                                  choices = platforms)
        })
        
        dynColor <- reactive({
                col <- 'Platform'
                switch(
                        input$selectedPlatform,
                        PS4 = {
                                col <- list(const = '#4A8CBC')
                        },
                        XBoxOne = {
                                col <- list(const = '#A460A8')
                        },
                        WiiU = {
                                col <- list(const = '#58B768')
                        },
                        PC = {
                                col <- list(const = '#E91937')
                        }
                )
                return(col)
        })
        
        ratingByPlatform <- reactive({
                if (input$selectedPlatform == 'All') {
                        dat <-
                                data.frame(
                                        UserRating = ratings$UserRating, CriticRating = ratings$CriticRating
                                )
                        dat$fittedByPlat <-
                                lmRatingsByPlat$fitted.values
                        dat$GameName <- ratings$GameName
                        dat$Platform <- ratings$Platform
                        dat$fittedAll <- lmRatings$fitted.values
                        return(dat)
                }
                else {
                        dat <- ratings %>% filter(Platform == input$selectedPlatform)
                        dat$fittedByPlat <-
                                lm(CriticRating ~ UserRating, dat)$fitted.values
                        return(dat)
                }
        })
        
        output$ratingsPlot <- renderChart3({
                dat <- ratingByPlatform()
                pred <- data.frame(CriticRating=rep(pred(),nrow(dat)), UserRating=rep(input$userRating, nrow(dat)))
                np <-
                        rPlot(
                                CriticRating ~ UserRating, color = dynColor(), data = dat, type = 'point', opacity=list(const=0.5),
                                tooltip = "#! function(item) {return item.GameName + '\\n User rating: ' + item.UserRating + '\\n Critics rating: ' + item.CriticRating} !#"
                        )
                np$set(width = 600, height = 600)
                np$guides(
                        y = list(
                                min = 6.5, max = 10, title = 'Critic Rating'
                        ), 
                        x = list(
                                min = 4, max = 10, title = 'User Rating'
                        )
                )
                np$addParams(dom = "ratingsPlot")
                np$layer(
                        y = 'fittedByPlat', copy_layer = T, type = 'line',
                        color = dynColor(), data = dat, size = list(const = 2),
                        opacity=list(const=0.5)
                )
                np$set(legendPosition = 'bottom')
                if (input$selectedPlatform == 'All') {
                        np$layer(
                                y = 'fittedAll', copy_layer = T, type = 'line',
                                color = list(const = 'grey'), data = dat, size = list(const = 2),
                                opacity=list(const=0.5)
                        )
                }
                np$layer(y='CriticRating', x='UserRating', data=pred, copy_layer=T, type = 'point', color = list(const = 'black'),size = list(const = 5))
                return(np)
        })
        
        output$selectedPlatform <- renderText(input$selectedPlatform)
        
        output$prediction <-
                renderText(paste('Predicted critic rating: ', round(pred(),2), sep = ''))
}

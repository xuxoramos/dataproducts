# Libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(rCharts)

# Data loading, cleaning and processing
ratingps4 <- read.csv('./metacriticdata-ps4.txt', header = F)
ratingps4 <- ratingps4 %>% mutate(Platform='PS4')

ratingsxbone <- read.csv('./metacriticdata-xbone.txt', header = F)
ratingsxbone <- ratingsxbone %>% mutate(Platform='XBoxOne')

ratingswiiu <- read.csv('./metacriticdata-wiiu.txt', header = F)
ratingswiiu <- ratingswiiu %>% mutate(Platform='WiiU')

ratingspc <- read.csv('./metacriticdata-pc.txt', header = F)
ratingspc <- ratingspc %>% mutate(Platform='PC')

ratings <- rbind(ratingps4,ratingsxbone,ratingswiiu,ratingspc)
setnames(ratings, 'V1', 'CriticRating')
setnames(ratings, 'V2', 'GameName')
setnames(ratings, 'V3', 'UserRating')
ratings <- ratings %>% mutate(CriticRating=round(CriticRating/10,2))
ratings <- ratings %>% filter(UserRating!='tbd')
ratings <- ratings %>% mutate(CriticRating=as.numeric(CriticRating), UserRating=as.numeric(UserRating))
platforms <- c('All',unique(ratings$Platform))

ui <- fluidPage(
    headerPanel('Game Ratings in Metacritic'),
    sidebarPanel(
        h2('Controls'),
        selectInput(inputId='selectedPlatform', label='Choose platform', choices=platforms)
    ),
    mainPanel('Plot shows user ratings vs critic ratings.',
              showOutput('ratingsPlot', lib = 'polycharts'))
)

server <- function(input, output) {
      output$ratingsPlot <- renderChart({
              np<- rPlot(CriticRating ~ UserRating, color='Platform', data=ratingByPlatform(), type='point',
                         tooltip = "#! function(item) {return 'Game: ' + item.GameName + ', User rating: ' + item.UserRating + ', Critics rating: ' + item.CriticRating} !#")
              np$set(width = 600, height = 600)
              np$guides(y = list(min = 6.5, max = 10), x = list(min = 4, max = 10))
              np$addParams(dom="ratingsPlot")
              np$layer(y = '_fitted', copy_layer = T, type = 'line',
                       color = list(const = 'black'))
              return(np)
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
                      dat <- fortify(lm(CriticRating ~ UserRating, ratings))
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
      output$table <- renderPrint(ratingByPlatform())
}

shinyApp(ui=ui, server=server)
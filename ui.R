# Libraries
library(shiny)
library(rCharts)

ui <- fluidPage(
        headerPanel('Game Ratings in Metacritic'),
        sidebarPanel(
                h2('Controls'),
                selectInput(inputId='selectedPlatform', label='Choose platform', choices = c('All'))
        ),
        mainPanel('Plot shows user ratings vs critic ratings.',
                  showOutput('ratingsPlot', lib = 'polycharts'))
)

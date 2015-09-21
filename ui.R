# Libraries
library(shiny)
library(rCharts)

ui <- fluidPage(
        titlePanel('Game Ratings vs User Ratings in Metacritic'),
        sidebarLayout(
                sidebarPanel(
                        helpText("Select the platform for which to display game ratings in the plot. We'll also display a regression line for each platform selected, including one for all platforms."),
                        selectInput(inputId='selectedPlatform', 
                                    label='Choose platform', choices = c('All')),
                        img(src='Metacritic.svg.png', width=100, height=100)
                ),
                mainPanel(
                        showOutput('ratingsPlot', lib = 'polycharts')
                )
        )
)

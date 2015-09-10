library(shiny)
#library(WDI)
library(inegiR)

#childrenWorking <- WDI(indicator = 'SL.TLF.0714.WK.ZS', country = c('MX','BR'), start=2014, end=2014)
#gdpPersonEmployed <- WDI(indicator = 'SL.GDP.PCAP.EM.KD.ZG', country = c('MX','BR'), start=2014, end=2014)
conflictolaboral <- serie_inegi('http://www3.inegi.org.mx/sistemas/api/indicadores/v1//Indicador/1007000012/00/es/false/xml/','c6d1ae55-fba3-ac83-5b32-5c736dc8041d')

userInterface <- fluidPage(
    headerPanel('Savara'),
    sidebarPanel(
        h1('Siviri')
    ),
    mainPanel('Severe')
)

server <- function(input, output) {}

shinyApp(ui=userInterface, server=server)
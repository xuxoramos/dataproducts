library(shiny)
shinyUI(pageWithSidebar(
    headerPanel('Data Science FTW!'),
    sidebarPanel(
        h1('Main Header'),
        h2('Header 2'),
        h3('Sidebar text'),
        h4('Header 4'),
        numericInput('id1', 'Numeric input w/label id1', 0, min = 0, max=10,step=1),
        checkboxGroupInput('id2', 'Checkbox',c('Value 1' = '1', 'Value 2' = '2', 'Value 3' = '3')),
        dateInput('date', 'Fecha Nacimiento'),
        numericInput('glucose', 'Glucose (mg/dl)', 90, min=50, max=200, step=5),
        sliderInput('mu','Guess the mean', value=70,min=62,max=74,step=0.05)
        # submitButton('Submit')
    ),
    mainPanel(
        h3('Main Panel text'),
        code('Code code code'),
        p('Siviri'),
        verbatimTextOutput('oid1'),
        verbatimTextOutput('oid2'),
        verbatimTextOutput('odate'),
        verbatimTextOutput('oglucose'),
        verbatimTextOutput('opred'),
        plotOutput('newHist')
    )
))
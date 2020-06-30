#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(title="Covid-19 Pandemic Worldwide",
    fluidRow(
        column(6, style='padding:20px;', plotlyOutput("distPlot")), 
        column(6, style='padding:20px;', plotlyOutput("barPlot"))
        ),
    fluidRow(
        column(6, h1("Covid-19 Pandemic Worldwide", align = "center"),
               HTML('<center>Source:<a href="https://corona.lmao.ninja/">Novel COVID API</a></center>')), 
        column(6, 
               selectInput("variable", "Please select the information:", c("Cases" = "cases",
                                                         "Today Cases" = "todayCases",
                                                         "Deaths" = "deaths",
                                                         "Today Deaths" = "todayDeaths",
                                                         "Recovered" = "recovered",
                                                         "Today Recovered" = "todayRecovered",
                                                         "Active Cases" = "active",
                                                         "Critical Cases" = "critical",
                                                         "Cases Per One Million" = "casesPerOneMillion",
                                                         "Deaths Per One Million" = "deathsPerOneMillion")))
    )
))

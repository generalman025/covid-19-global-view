#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(jsonlite)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    covid19 <- fromJSON("https://corona.lmao.ninja/v2/countries?sort=country")
    
    title <- c('Cases', 'Today Cases', 'Deaths', 'Today Deaths', 'Recovered', 'Today Recovered', 'Active Cases', 'Critical Cases', 'Cases Per One Million', 'Deaths Per One Million')
    
    output$distPlot <- renderPlotly({
        dist <- switch(input$variable, 
                      'cases' = list(val=covid19$cases, title=title[1]), 
                      'todayCases' = list(val=covid19$todayCases, title=title[2]),
                      'deaths' = list(val=covid19$deaths, title=title[3]),
                      'todayDeaths' = list(val=covid19$todayDeaths, title=title[4]),
                      'recovered' = list(val=covid19$recovered, title=title[5]),
                      'todayRecovered' = list(val=covid19$todayRecovered, title=title[6]),
                      'active' = list(val=covid19$active, title=title[7]),
                      'critical' = list(val=covid19$critical, title=title[8]),
                      'casesPerOneMillion' = list(val=covid19$casesPerOneMillion, title=title[9]),
                      'deathsPerOneMillion' = list(val=covid19$deathsPerOneMillion, title=title[10]))
        
        l <- list(color = toRGB("grey"), width = 0.5)
        fig <- plot_geo(covid19, type='choropleth', 
                       locations=covid19$countryInfo$iso3, 
                       z=dist$val, 
                       text=covid19$country, 
                       marker = list(line = l),
                       colorscale="Blues",
                       reversescale =T)
        
        g <- list(
            showframe = FALSE,
            showcoastlines = FALSE,
            projection = list(type = 'Mercator')
        )
        fig <- fig %>% colorbar(title = dist$title)
        fig <- fig %>% layout(title = 'Global View', geo = g)
        
        distPlot <- fig
    })

    output$barPlot <- renderPlotly({
        bar <- switch(input$variable, 
                      'cases' = covid19[order(covid19$cases, decreasing=T),][1:10, ],
                      'todayCases' = covid19[order(covid19$todayCases, decreasing=T),][1:10, ],
                      'deaths' = covid19[order(covid19$deaths, decreasing=T),][1:10, ],
                      'todayDeaths' = covid19[order(covid19$todayDeaths, decreasing=T),][1:10, ],
                      'recovered' = covid19[order(covid19$recovered, decreasing=T),][1:10, ],
                      'todayRecovered' = covid19[order(covid19$todayRecovered, decreasing=T),][1:10, ],
                      'active' = covid19[order(covid19$active, decreasing=T),][1:10, ],
                      'critical' = covid19[order(covid19$critical, decreasing=T),][1:10, ],
                      'casesPerOneMillion' = covid19[order(covid19$casesPerOneMillion, decreasing=T),][1:10, ],
                      'deathsPerOneMillion' = covid19[order(covid19$deathsPerOneMillion, decreasing=T),][1:10, ])
        
        bar <- switch(input$variable, 
                      'cases' = list(title=title[1], country=bar$country, val=bar$cases),
                      'todayCases' = list(title=title[2], country=bar$country, val=bar$todayCases),
                      'deaths' = list(title=title[3], country=bar$country, val=bar$deaths),
                      'todayDeaths' = list(title=title[4], country=bar$country, val=bar$todayDeaths),
                      'recovered' = list(title=title[5], country=bar$country, val=bar$recovered),
                      'todayRecovered' = list(title=title[6], country=bar$country, val=bar$todayRecovered),
                      'active' = list(title=title[7], country=bar$country, val=bar$active),
                      'critical' = list(title=title[8], country=bar$country, val=bar$critical),
                      'casesPerOneMillion' = list(title=title[9], country=bar$country, val=bar$casesPerOneMillion),
                      'deathsPerOneMillion' = list(title=title[10], country=bar$country, val=bar$deathsPerOneMillion))
        
        bar$country <- factor(bar$country, levels = unique(bar$country)[order(bar$val, decreasing = TRUE)])
        
        fig <- plot_ly(
            x = bar$country,
            y = bar$val,
            type = "bar"
        )
        
        fig <- fig %>% layout(title = bar$title)
        
        barPlot <- fig
    })
})

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
library(dplyr)
library(jsonlite)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    covid19 <- fromJSON("https://corona.lmao.ninja/v2/countries?sort=country")
    
    output$distPlot <- renderPlotly({
        variable <- input$variable
        title <- switch(variable,
                        'cases' = 'Cases',
                        'todayCases' = 'Today Cases',
                        'deaths' = 'Deaths',
                        'todayDeaths' = 'Today Deaths', 
                        'recovered' = 'Recovered', 
                        'todayRecovered' = 'Today Recovered',
                        'active' = 'Active Cases', 
                        'critical' = 'Critical Cases', 
                        'casesPerOneMillion' = 'Cases Per One Million',
                        'deathsPerOneMillion' = 'Deaths Per One Million')
        covid19 <- covid19 %>% mutate(val=get(variable))
        
        l <- list(color = toRGB("grey"), width = 0.5)
        fig <- plot_geo(covid19, type='choropleth', 
                       locations=covid19$countryInfo$iso3, 
                       z=covid19$val, 
                       text=covid19$country, 
                       marker = list(line = l),
                       colorscale="Blues",
                       reversescale =T)
        
        g <- list(
            showframe = FALSE,
            showcoastlines = FALSE,
            projection = list(type = 'Mercator')
        )
        fig <- fig %>% colorbar(title = title)
        fig <- fig %>% layout(title = 'Global View', geo = g)
        
        distPlot <- fig
    })

    output$barPlot <- renderPlotly({
        variable <- input$variable
        title <- switch(variable,
                        'cases' = 'Cases',
                        'todayCases' = 'Today Cases',
                        'deaths' = 'Deaths',
                        'todayDeaths' = 'Today Deaths', 
                        'recovered' = 'Recovered', 
                        'todayRecovered' = 'Today Recovered',
                        'active' = 'Active Cases', 
                        'critical' = 'Critical Cases', 
                        'casesPerOneMillion' = 'Cases Per One Million',
                        'deathsPerOneMillion' = 'Deaths Per One Million')
        covid19 <- covid19 %>% mutate(val=get(variable))
        top10 <- covid19 %>% arrange(desc(val)) %>% top_n(10)
        top10$country <- factor(top10$country, 
                                levels = unique(top10$country)[order(top10$val, decreasing = TRUE)])
        
        fig <- plot_ly(
            x = top10$country,
            y = top10$val,
            type = "bar"
        )
        fig <- fig %>% layout(title = paste('Top 10 Rank :', title))
        
        barPlot <- fig
    })
})

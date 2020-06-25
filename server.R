#### run when the app is changed by user
function(input, output) {
    
    
    output$total_deaths <- renderText({
        sum(state_outbreak$total_deaths)
    })
    
    output$total_cases <- renderText({
        sum(state_outbreak$total_cases)
    })
    
    output$total_recovered <- renderText({
        recovered$total_recovered
    })
    
    output$percent_pop <- renderText({
        round(sum(state_outbreak$total_cases)/sum(state_outbreak$Population)*100, 2)
    })
    
    output$mymap <- renderLeaflet({
        
        granularity <- switch (input$var,
                               "State" = states_sd,
                               "County" = counties_sd)
        
        data_ <- switch(input$var,
                        "State" = states_sd$total_cases,
                        "County" = counties_sd$total_cases)
        
        color <- switch(input$var,
                        "State" = s_pal,
                        "County" = c_pal)
        
        
        leaflet(granularity) %>%  
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            
            addPolygons(weight = 0.5,
                        fillColor = ~color(data_),
                        color = 'white',
                        fillOpacity = 0.75,
                        label = ~paste0("Click to inspect: ", granularity$NAME),
                        labelOptions = labelOptions(style = list(
                            "font-family" = "serif",
                            "font-style" = "bold",
                            "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                            "font-size" = "12px"
                        )),
                        popup = ~paste0(granularity$NAME,":", "<br/>",
                                        "<b>Cases: </b>",granularity$total_cases,"<br/>",
                                        "<b>Deaths: </b>", granularity$total_deaths),
                        highlightOptions = highlightOptions(color = "grey", weight = 2,
                                                            bringToFront = TRUE)
                        
            ) %>%
            
            leaflet::addLegend(title = "Confirmed cases",
                               pal = color,
                               values = data_,
                               position = "bottomright")
        
    })
    
    output$st <- renderPlotly({
        plot_ly(st, x= ~Date, y= ~t_cases) %>%
            filter(Province_State %in% input$states) %>%
            add_lines(color= ~Province_State) %>%
            layout(title = "Total Cases by State",
                   yaxis = list(title = "Total Cases"),
                   hovermode = "x")
        
    })
    output$cnty <- renderPlotly({
        plot_ly(cnty, x= ~Date, y= ~t_cases) %>%
            filter(County_Area %in% input$county) %>%
            add_lines(color= ~County_Area) %>%
            layout(title = "Total Cases by County",
                   yaxis = list(title = "Total Cases"),
                   hovermode = "x")
        
    })
    
    output$mytable <- DT::renderDT(
        county_outbreak_dt,
        filter = "top",
        options = list(pageLength = 10)
    )
    
}
#######


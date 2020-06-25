##### run each time a user visits
##### ui.R

shiny::htmlTemplate(
    # Index Page
    "www/index.html",

   
    # Number of hours
    render_total_cases = textOutput(
        "total_cases",
        inline = TRUE
    ),
    render_total_deaths = textOutput(
        "total_deaths",
        inline = TRUE
    ),
    render_total_recovered = textOutput(
        "total_recovered",
        inline = TRUE
    ),
    render_percent_population = textOutput(
        "percent_pop",
        inline = TRUE
    ),
    
    render_leaflet_map = addSpinner(leafletOutput(outputId = "mymap"), spin = "circle"),
    
    
    render_city_select = selectInput("var",
                                     label = "State/County Granularity",
                                     choices = c("State", "County"),
                                     selected = "State",
                                     width = "200px"),
    
    
    render_plotly_st = plotlyOutput(outputId = "st"),
    
    render_graph_select_st = selectizeInput(inputId = "states",
                                    label = "Select a States",
                                    choices = unique(st$Province_State),
                                    selected = c("California", "New York", "Florida"),
                                    multiple = TRUE),
    
    render_plotly_cnty = plotlyOutput(outputId = "cnty"),
    
    render_DT = DT::dataTableOutput(outputId = "mytable")
    
)

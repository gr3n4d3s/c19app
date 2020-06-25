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

    #     # Leaflet map
    #     leaflet_map = leafletOutput(outputId = "map") %>% 
    #         withSpinner(color="#0dc5c1")
    
#     
#     # Longest Trip
#     longest_trip_time = textOutput(
#         "longest_trip_time_text",
#         inline = T
#     ),
#     
#     # Number of Kms
#     num_distance_text = textOutput(
#         "num_distance",
#         inline = T
#     ),
#     
#     longest_trip_distance = textOutput(
#         "longest_trip_distance_text",
#         inline = T
#     ),
#     
#     # Expensive Trip
#     
#     num_dollars_spent = textOutput(
#         "num_distance",
#         inline = T
#     ),
#     
#     expensive_trip = textOutput(
#         "most_expensive_trip_text",
#         inline = T
#     ),
#     
#     # City Selector
#     city_selector = selectInput(
#         "city", 
#         label = "Select City", 
#         choices = d_clean$city %>% 
#             unique(),
#         selected = "Auckland"
#     ),
#     
#     
#     # Selector for Time
#     time_selector = material_card(
#         title = "",
#         sliderInput(
#             "time", 
#             "Date",
#             min(d_routes$request_time) %>% as.Date(), 
#             max(d_routes$request_time) %>% as.Date(),
#             value = max(d_routes$request_time) %>% as.Date(),
#             step = 30,
#             animate = animationOptions(
#                 playButton = HTML("<img src='images/icons/play-button.png' height='20' width='20'>"), 
#                 pauseButton = HTML("<img src='images/icons/pause-button.png' height='20' width='20'>")
#             )
#         )
#     ),
#     
#     # Leaflet map
#     leaflet_map = leafletOutput(outputId = "map") %>% 
#         withSpinner(color="#0dc5c1")





# navbarPage(theme = shinytheme("yeti"), title = "Covid 19 Explorer",
#                   
#                   tabPanel("Interactive Map", 
#                            
#                            
#                                
#                              
#                                
#                                addSpinner(leafletOutput("mymap"), spin = "circle"),
#                                
#                                absolutePanel(top = 10, left = 50, titlePanel("Covid19 US Map")),
#                                
#                                absolutePanel(top = 15, right = 10,
#                                              selectInput("var",
#                                                          label = "State/County Granularity",
#                                                          choices = c("State", "County"),
#                                                          selected = "State",
#                                                          width = "200px"),
#                                )
#                                
#                   ),
#                   
#                   tabPanel("Comparison Chart View",
#                            fluidRow(
#                                
#                                column( width = 6, style ="padding:10px;",
#                                        selectizeInput(
#                                            inputId = "states",
#                                            label = "Select a States",
#                                            choices = unique(st$Province_State),
#                                            selected = c("California", "New York"),
#                                            multiple = TRUE
#                                        ),
#                                ),
#                                column( width = 6, style ="padding:10px;",
#                                        selectizeInput(
#                                            inputId = "county",
#                                            label = "Select a Counties",
#                                            choices = unique(cnty$County_Area),
#                                            selected = c("Sacramento", "Albany"),
#                                            multiple = TRUE
#                                        )
#                                )
#                            ),
#                            
#                            fluidRow(
#                                plotlyOutput(outputId = "st")
#                            ),
#                            
#                            hr(),
#                            
#                            fluidRow(
#                                plotlyOutput(outputId = "cnty")
#                                
#                            )
#                   ),
#                   
#                   tabPanel("Data Examiner",
#                            fluidRow(
#                                hr(),
#                                column( width = 12, style = "padding: 10px;",
#                                        DT::dataTableOutput("mytable")
#                                )
#                                
#                            )
#                   )
#                   
# )
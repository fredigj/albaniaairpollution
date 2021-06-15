shinyServer(function(input, output, session){
  # reactive used for creating map
  # air_map <- reactive({
  #   sum_df %>% 
  #     filter(year == input$years[1]) %>% 
  #     group_by(Station.name.district) %>% 
  #     summarise(lat = first(Latitude), 
  #               long = first(Longitude),
  #               min_PM10 = min(PM10),
  #               avg_PM10 = mean(PM10),
  #               max_PM10 = max(PM10),
  #               min_PM2.5 = min(PM2.5),
  #               avg_PM2.5 = mean(PM2.5),
  #               max_PM2.5 = max(PM2.5)) %>% 
  #     select(Station.name.district, lat, long, contains(input$finedust))
  # })
  air_map <- reactive({
    al_info %>% 
      filter(al_info$years == input$years[1]) %>% 
      group_by(al_coo.city) %>% 
      summarise(lat = first(Latitude), 
                long = first(Longitude),
                SO2 = SO2,
                NO2 = NO2,
                O3 = O3,
                PM10 = PM10,
                PM2.5 = PM2.5,
                CO = CO,
                Benzen = Benzen %>% 
      select(al_coo.city, lat, long, contains(input$finedust)))
  })
  # leaflet map of Seoul city
  output$map <- renderLeaflet({
    # assigning colors by the group of the pollutant level
    if (input$finedust == "PM10") {
      getColor <- sapply(air_map()$PM10, getColor1)
    } else {
      getColor <- sapply(air_map()$PM2.5, getColor2)
    }
    # icon of the map pin
    icons <- awesomeIcons(
      icon = "ios-cloud",
      iconColor = 'white',
      library = 'ion',
      markerColor = getColor)
    
    leaflet(air_map()) %>%
      addTiles() %>%
      addAwesomeMarkers(lat = air_map()$lat, 
                 lng = air_map()$long,
                 popup = ~paste('<b>',al_coo.city,'</b><br/>',
                                "Min:", round(air_map()[[4]]), '<br/>',
                                "Avg:", round(air_map()[[5]]), '<br/>',
                                "Max:", round(air_map()[[6]])),
                 icon = icons) %>% 
      addLegend(
        colors = c("#0099FF", "#4CBB17", "#F9A602", "#CC0000"),
        labels = if (input$finedust == "PM10") {
          c("Good: 0 ~ 30", "Normal: 30 ~ 80", "Bad: 80 ~ 150", "Very Bad: 150 ~ 600")
        } else {
          c("Good: 0 ~ 15", "Normal: 15 ~ 35", "Bad: 35 ~ 70", "Very Bad: 70 ~ 500")
        },
        opacity = 0.8
      )
  })
  #   # infoBox of neighborhood with fresh air
  #   output$good_neighborhood <- renderInfoBox({
  #   best_neighborhood = air_map() %>% arrange(air_map()[[5]])
  #   best = best_neighborhood %>% 
  #     summarise(first(Station.name.district), first(best_neighborhood[[5]]))
  #   col = ifelse(input$finedust == "PM10", getColor1(best[[2]]), getColor2(best[[2]]))
    
  #   infoBox(
  #     "Cleanest Air (Average)", best[[1]], icon = icon("thumbs-up", lib = "glyphicon"),
  #     color = col)
  # })
  # # infoBox of neighborhood with bad air
  # output$bad_neighborhood <- renderInfoBox({
  #   worst_neighborhood = air_map() %>% arrange(desc(air_map()[[5]]))
  #   worst = worst_neighborhood %>% 
  #     summarise(first(Station.name.district), first(worst_neighborhood[[5]]))
  #   col = ifelse(input$finedust == "PM10", getColor1(worst[[2]]), getColor2(worst[[2]]))

  #   infoBox(
  #     "Worst Air (Average)", worst[[1]], icon = icon("thumbs-down", lib = "glyphicon"),
  #     color = col)
  # })
  
  # infoBox with the min,avg,max values
})

  
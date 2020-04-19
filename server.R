serverFunctions <- function(input, output, session) {
  output$olympic_map <-
    renderLeaflet({
      leaflet(options = leafletOptions(
        attributionControl = FALSE,
        minZoom = 1,
        maxZoom = 6
      )) %>%
        setView(-2.4609375, 45.8287992519213, zoom = 2) %>%
        setMaxBounds(
          lng1 = -180,
          lng2 = 180,
          lat1 = -85,
          lat2 = 85
        ) %>%
        addPolygons(
          data = sf_world_shape_files,
          stroke = TRUE,
          smoothFactor = 0.2,
          color = 'darkslategray',
          fillOpacity = 0.5,
          fillColor = 'ghostwhite',
          weight = 1,
          opacity = 1,
          label = ~ Country,
          layerId = ~ Country
        ) %>%
        clearMarkers() %>%
        addPolygons(
          data = data_to_plot(),
          stroke = TRUE,
          smoothFactor = 0.2,
          color = 'darkslategray',
          fillColor = ~ color_pallete(TotalMedals),
          fillOpacity = 1,
          weight = 1,
          opacity = 1,
          label = ~ lapply(
            paste(
              Country,
              "<br/>",
              "Year:",
              Year,
              "<br/>",
              "Total Medal(s) Won: ",
              TotalMedals
            ),
            htmltools::HTML
          ),
          layerId = ~ Country,
          labelOptions = labelOptions(
            textsize = "12px",
            style = list("font-weight" = "bold")
          ),
          highlight = highlightOptions(
            weight = 1,
            color = 'black',
            opacity = 1,
            bringToFront = FALSE
          )
        ) %>%
        addCircleMarkers(
          data = df_olympic_regions %>% filter(Year == input$olympicYear),
          lat = ~ Latitude,
          lng = ~ Longitude,
          radius = 6,
          color = 'black',
          weight = 1.5,
          fillColor = 'orangered',
          fillOpacity = 1,
          label = ~ lapply(
            paste0("City: ", City, "<br/>", "Olympic Year: ", Year),
            htmltools::HTML
          ),
          layerId = ~ City,
          labelOptions = labelOptions(
            textsize = "12px",
            style = list("font-weight" = "bold")
          )
        ) %>%
        addControl(paste("OVERVIEW OF THE", input$olympicYear, "OLYMPICS", collapse = " "),
                   position = "bottomleft")
    })
  
  color_pallete <-
    colorQuantile("YlGnBu", df_medals_countries$TotalMedals)
  
  data_to_plot <- reactive({
    df_filtered_countries <-
      df_all_medals_year %>% filter(Year == input$olympicYear)
    
    filtered_world <-
      merge(sf_world_shape_files, df_filtered_countries)
    
    filtered_world
  })
  
  medal_colors <- c("#B8860B", "#C0C0C0", "#FFD700")
  names(medal_colors) <- c("Bronze", "Silver", "Gold")
  
  output$olympic_mapUI <- renderUI({
    leafletOutput("olympic_map", height = "calc(100vh - 500px)")
  })
  
  output$sports_table <- renderUI({
    sports <-
      df_sports %>% filter (Year == input$olympicYear) %>% select(Sport, path)
    
    HTML(
      paste0(
        '<img src = "',
        sports$path ,
        '" width=30, height=30></img>',
        " ",
        sports$Sport,
        collapse = "<br/>"
      )
    )
  })
  
  output$medals_bar_graph <- renderHighchart({
    data_for_medals_bar_graphs <- df_individual_medal_year %>%
      filter (Year == input$olympicYear)
    
    from_colors <- sort(unique(data_for_medals_bar_graphs$Medal))
    to_colors <-
      medal_colors[sort(unique(data_for_medals_bar_graphs$Medal))]
    
    data_for_medals_bar_graphs <- data_for_medals_bar_graphs %>%
      mutate(mapped_medalcolor = plyr::mapvalues(Medal,
                                                 from = from_colors,
                                                 to = to_colors)) %>%
      group_by(Country, Medal, mapped_medalcolor) %>%
      summarise(Total = sum(Count)) %>%
      ungroup() %>%
      top_n(50)
    
    data_for_medals_bar_graphs %>%
      hchart(
        type = "bar",
        hcaes(
          y = Total,
          x = Country,
          group = Medal,
          color = mapped_medalcolor
        ),
        pointWidth = 5,
        color = to_colors
      ) %>%
      hc_plotOptions(series = list(stacking = "stack")) %>%
      hc_title(text = paste("COUNTRY WISE MEDAL COUNT - ", input$olympicYear, collapse = " "))
  })
  
  
  output$sports_bar_graph <- renderHighchart({
    if (!(is.null(input$olympic_map_shape_click$id))) {  
      data_for_sports_bar_graph <- df_sports_medal_year %>%
        filter (Year == input$olympicYear,
                Country == input$olympic_map_shape_click$id)
      
    
      from_colors <- sort(unique(data_for_sports_bar_graph$Medal))
      to_colors <-
        medal_colors[sort(unique(data_for_sports_bar_graph$Medal))]
      
      data_for_sports_bar_graph <- data_for_sports_bar_graph %>%
        mutate(mapped_medalcolor = plyr::mapvalues(Medal,
                                                   from = from_colors,
                                                   to = to_colors)) %>%
        group_by(Sport, Medal, mapped_medalcolor) %>%
        summarise(Total = sum(Count)) %>%
        ungroup()
      
      data_for_sports_bar_graph %>%
        hchart(
          type = "bar",
          hcaes(
            y = Total,
            x = Sport,
            group = Medal,
            color = mapped_medalcolor
          ),
          pointWidth = 5,
          color = to_colors
        ) %>%
        hc_plotOptions(series = list(stacking = "stack")) %>%
        hc_title(
          text = paste(
            "SPORTS WISE MEDAL COUNT FOR",
            toupper(input$olympic_map_shape_click$id),
            "IN THE YEAR",
            input$olympicYear,
            collapse = " "
          )
        )
    }
    else {
      highchart() %>%
        hc_title(text = HTML(paste("CLICK ON THE HIGHLIGHTED COUNTRIES TO DISPLAY SPORTS WISE MEDAL DISTRIBUTION.")))
    }
  })
  
  output$line_graph <- renderHighchart({
    if (!is.null(input$olympic_map_shape_click$id)) {
    highchart() %>%
      hc_add_series(
        data = df_all_medals_year %>%
          filter(Country == input$olympic_map_shape_click$id),
        type = "spline",
        hcaes(y = TotalMedals,
              x = Year,
              group = Country),
        color = "royalblue",
        name = "Medals Won"
      ) %>%
      hc_add_series(
        data = df_gender_count %>%
          filter(Country == input$olympic_map_shape_click$id, Sex == "M"),
        type = "spline",
        hcaes(y = Count,
              x = Year,
              group = Country),
        color = "orangered",
        name = "Male"
        
      ) %>%
      hc_add_series(
        data = df_gender_count %>%
          filter(Country == input$olympic_map_shape_click$id, Sex == "F"),
        type = "spline",
        hcaes(y = Count,
              x = Year,
              group = Country),
        color = "mediumaquamarine",
        name = "Female"
      ) %>%
      hc_title(text = paste(
        "PERFORMANCE OF",
        toupper(input$olympic_map_shape_click$id),
        "IN OLYMPICS",
        collapse = " "
      ))
    }
    else{
      highchart()%>%
        hc_title(text = paste("CLICK ON ANY OF THE COUNTRY TO DISPLAY ITS OVERALL PERFORMANCE IN THE OLYMPICS."))
    }
  })
  
}
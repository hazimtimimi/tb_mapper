# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# TB Mapper
#
# Server-side code to load data and produce maps to be sent to browsers
#
# Hazim Timimi, November 2015
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Code to be run server-side

library(shiny)
library(dplyr)
library(ggplot2)

# Build basic map layers
source("build_base_map.r")

# Load up data from the data downloads page
estimates <- read.csv("https://extranet.who.int/tme/generateCSV.asp?ds=estimates",
                      stringsAsFactors = FALSE) %>%
              select(iso3,
                     year,
                     e_prev_100k,
                     e_inc_100k,
                     e_inc_tbhiv_100k,
                     e_mort_exc_tbhiv_100k,
                     e_mort_tbhiv_100k,
                     c_cdr)




shinyServer(function(input, output) {


  output$world_map <- renderPlot({

    # Create a dataframe restricted to the data needed for the map
    # using choices selected in ui.R (referenced using input$ )
    df_for_map <- estimates %>%
                  select(iso3,
                         year,
                         var_to_plot = contains(input$variable)) %>%
                  # Remove any NAs
                  filter(!is.na(var_to_plot)) %>%
                  # Select the year
                  filter(year == input$year)

    # Generate equally-spaced bins based on number of categories chosen
    bins <- seq(min(df_for_map$var_to_plot),
                max(df_for_map$var_to_plot),
                length.out = input$bins + 1)

    # Generate a new variable using the bins
    df_for_map$map_bins <- cut(df_for_map$var_to_plot,
                               breaks = bins)


    # Merge df_for_map with gworld shape dataframe based on ISO3 code
    to_map <- gworld %>%
              full_join(df_for_map, by = c("id" = "iso3")) %>%
              arrange(order)
    rm(df_for_map)

    # Plot the bins on the standard WHO map
    # (not bothering with the 'not applicable' category in legend for now)

    ggplot(data = to_map,
           aes(long, lat)) +
      geom_polygon(data = to_map,
                   aes(group = group,
                       fill = map_bins)) +
      base_layer +
      lakes +
      jammu_kashmir +
      abyei +
      western_sahara +
      sold_grey +
      dashed_grey_white +
      dashed_grey +
      dotted_grey_white +
      theme_x +
      theme_y +
      theme_overall +

      # Add Lesotho and Swaziland again so they sit on top of South Africa
      geom_polygon(data = filter(to_map, id %in% c("SWZ", "LSO")),
                   aes(group = group,
                       fill = map_bins)) +

      # Add colour scheme and legend
      scale_fill_brewer(name= paste(input$variable, input$year)) +

      # Set coordinate system and limits so get the appropriate zoom level
      coord_cartesian(xlim = c(-180,180)) +
      theme(aspect.ratio = 2.2/4,
            legend.position = c(0.1, 0.3),
            panel.border = element_blank())

  })


})

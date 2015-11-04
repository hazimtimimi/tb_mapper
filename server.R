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
library(whomap)

# Load up data from the data downloads page
estimates <- read.csv("https://extranet.who.int/tme/generateCSV.asp?ds=estimates") %>%
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
    x    <- estimates %>%
            select(iso3,
                   year,
                  var_to_plot = contains(input$variable)) %>%
            # Remove any NAs
            filter(!is.na(var_to_plot)) %>%
            # Select the year
            filter(year == input$year)

    # Generate equally-spaced bins based on number of categories chosen
    bins <- seq(min(x$var_to_plot), max(x$var_to_plot), length.out = input$bins + 1)

    # Generate a new variable using the bins
    x$var <- cut(x$var_to_plot,
                 breaks = bins
                 )

    #Plot the bins on the standard WHO map
    whomap(x,
           Z=scale_fill_brewer(name= paste(input$variable,
                                           input$year)
                               )
           )

  })


})

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# TB Mapper
#
# Define the page layout and the input and output controls to be displayed in
# web browsers using Shiny
#
# Hazim Timimi, November 2015
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


library(shiny)


shinyUI(fluidPage(

titlePanel("TB Mapper"),

  sidebarLayout(
    sidebarPanel(
      helpText("Create a map using data from the WHO global TB database"),

      # Drop-down to select what is shown on map
      selectInput("variable",
        label = "Choose what to map",
        choices = c("Incidence (all)" = "e_inc_100k",
                    "Incidence (HIV-positive)" = "e_inc_tbhiv_100k",
                    "Prevalence" = "e_prev_100k",
                    "Mortality (HIV-negative)" = "e_mort_exc_tbhiv_100k",
                    "Mortality (HIV-positive)" = "e_mort_tbhiv_100k",
                    "Case detection rate (%)" = "c_cdr"
                    )),

      # Slider to select the year to plot
      sliderInput("year",
        label = "Year",
        min = 1990, max = 2014, value = 2014,
        #don't have thousands separators for years!
        sep="",
        # Just for fun, add some animation
        animate=animationOptions(interval = 3000, loop = TRUE)),


      # Widget to select number of categories in the map
      numericInput("bins",
        label = "Number of categories",
        value = 3, min = 3, max = 8, step = 1)
    ),

    mainPanel(

      # Placeholder where the map produced server-side is displayed
      plotOutput("world_map",
                 height = "600px")


      )
  )

))

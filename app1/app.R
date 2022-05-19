# Load packages ----------------------------------------------------------------

library(shiny)
library(tidyverse)

# Load data --------------------------------------------------------------------

life_meaning <- read_csv("data/babynames.csv", show_col_types = FALSE)

# Define UI --------------------------------------------------------------------


ui <- ...

# Define server function --------------------------------------------
server <- function(input, output, session) {

  ...
}

# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)

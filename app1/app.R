# Load packages ----------------------------------------------------------------

library(shiny)
library(tidyverse)

# Load data --------------------------------------------------------------------

babydata <- read_csv("data/babynames.csv", show_col_types = FALSE)

# Data manipulation ------------------------------------------------------------

popular_names <- babydata %>%
  group_by(sex) %>%
  filter(year == 2020) %>%
  arrange(desc(n)) %>%
  slice(1:15) %>%
  mutate(most_popular = 1)

babydata <- babydata %>%
  filter(name %in% popular_names$name)

#extract names as a character vector
name_choices <- babydata %>%
  distinct(name) %>%
  arrange(name) %>%
  pull(name)

#random sample of two names to compare
selected_name_choices <- sample(name_choices, 2)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  titlePanel(title = "Name Popularity"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      checkboxGroupInput(
        inputId = "name_choices",
        label = "Select a Name",
        choices = name_choices,
        selected = selected_name_choices
      )
    ),
    mainPanel = mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel(
          title = "Name Popularity over Time, in Absolute Numbers",
          plotOutput(outputId = "name_abs_plot")
        ),
        tabPanel(
          title = "Name Popularity over Time, in Relative Numbers",
          plotOutput(outputId = "name_rel_plot")
        ),
        tabPanel(
          title = "Data",
          DT::dataTableOutput(
            outputId = "namedata"
          )
        )
      )
    )
  )
)

# Define server function --------------------------------------------
server <- function(input, output, session) {
   output$name_choices <- reactive({
     paste("You've selected",  length(input$name_choices), "names")
   })

   babydata_fun <- reactive({
     babydata %>%
       filter(name %in% input$name_choices) %>%
       group_by(name, year) %>%
       summarize(n = sum(n),
                 prop = sum(prop))
   })

   output$name_abs_plot <- renderPlot({
     validate(
       need(
         #if
         expr = length(input$name_choices) <= 10,
         #else
         message = "Please select a maximum of 10 names"
       )
     )

     babydata_fun() %>%
       # draw the plot
       ggplot(
         mapping = aes(
           x = year,
           y = n,
           group = name,
           color = name
         )
       ) +
       geom_line(size = 1) +
       theme_minimal(base_size = 16) +
       theme(legend.position = "bottom") +
       labs(
         x = "Year",
         y = "Number of Babies Named {named_choices}",
         color = "Name",
         title = "Absolute Name Popularity over Time"
       )
     })

   output$name_rel_plot <- renderPlot({
     validate(
       need(
         #if
         expr = length(input$name_choices) <= 10,
         #else
         message = "Please select a maximum of 10 names"
       )
     )

     babydata_fun() %>%
       # draw the plot
       ggplot(
         mapping = aes(
           x = year,
           y = prop,
           group = name,
           color = name
         )
       ) +
       geom_line(size = 1) +
       theme_minimal(base_size = 16) +
       theme(legend.position = "bottom") +
       labs(
         x = "Year",
         y = "Number of Babies Named {named_choices}",
         color = "Name",
         title = "Absolute Name Popularity over Time"
       )

   })

   output$namedata <- DT::renderDataTable({
     babydata_fun()})
}

# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)

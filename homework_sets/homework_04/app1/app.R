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
          title = "Absolute Name Popularity over Time",
          plotOutput(outputId = "name_abs_plot")
        ),
        tabPanel(
          title = "Relative Name Popularity over Time",
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
                 percent = (sum(prop) * 100))
   })

   output$name_abs_plot <- renderPlot({
     validate(
       need(
         #if
         expr = input$name_choices,
         #else
         message = "Please select at least 1 name."
       )
     )

     validate(
       need(
         #if
         expr = length(input$name_choices) <= 8,
         #else
         message = "Please select a maximum of 8 names."
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
       theme(legend.position = "bottom",
             plot.caption = element_text(hjust = 0)) +
       labs(
         x = "Year",
         y = "Number of Babies Born",
         color = "Name",
         title = paste("Number of Babies Named", paste(input$name_choices, collapse = ", ")),
         subtitle = "in the United States, 1880-2020",
         caption = "Options are limited to the 15 most popular names by sex in the United States in 2020"
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
           y = percent,
           group = name,
           color = name
         )
       ) +
       geom_line(size = 1) +
       theme_minimal(base_size = 16) +
       theme(legend.position = "bottom",
             plot.caption = element_text(hjust = 0)) +
       labs(
         x = "Year",
         y = "Percentage of Babies Born",
         color = "Name",
         title = paste("Percentage of Babies Named", paste(input$name_choices, collapse = ", ")),
         subtitle = "in the United States, 1880-2020",
         caption = "Options are limited to the 15 most popular names by sex in the United States in 2020"
       )

   })

   output$namedata <- DT::renderDataTable({
     babydata_fun()})
}

# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)

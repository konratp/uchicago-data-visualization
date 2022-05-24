# Load packages ----------------------------------------------------------------

library(shiny)
library(shinythemes)
library(thematic)
library(tidyverse)

# Load data --------------------------------------------------------------------

babydata <- read_csv("data/babynames.csv", show_col_types = FALSE)

thematic_on()

# Data manipulation ------------------------------------------------------------

friend_names <- babydata %>%
  filter((name == "Konrad" & sex == "M") | (name == "Hayley" & sex == "F") | (name == "Lisa" & sex == "F") | (name == "Zachary" & sex == "M") | (name == "William" & sex == "M") | (name == "Zachariah" & sex == "M") | (name == "Levi" & sex == "M") | (name == "Alison" & sex == "F") | (name == "Carter" & sex == "M") | (name == "Emmanuel" & sex == "M") | (name == "Jack" & sex == "M") | (name == "Logan" & sex == "M") | (name == "Caroline" & sex == "F") | (name == "Richard" & sex == "M") | (name == "Wendy" & sex == "F") | (name == "Nikita" & sex == "M") | (name == "Clara" & sex == "F") | (name == "Silvio" & sex == "M") | (name == "Brenna" & sex == "F"))

babydata <- babydata %>%
  filter(name %in% friend_names$name)

#extract names as a character vector
name_choices <- babydata %>%
  distinct(name) %>%
  arrange(name) %>%
  pull(name)

#random sample of two names to compare
selected_name_choices <- sample(name_choices, 2)

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  theme = shinytheme("united"),
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
        caption = "Options are limited to the names of a selection of Konrat's friends"
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
        caption = "Options are limited to the names of a selection of Konrat's friends"
      )


  })

  output$namedata <- DT::renderDataTable({
    babydata_fun()})
}

# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)

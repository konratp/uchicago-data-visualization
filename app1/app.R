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

names_data <- babydata %>%
  filter(name %in% popular_names$name)

#extract names as a character vector
name_choices <- names_data %>%
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
  output$name_abs_plot =

}

renderPlot({
  # base plot
  age_plot +
    # label the current point
    geom_point(
      data = tibble(
        you = input$age_you,
        partner = input$age_partner
      ),
      mapping = aes(x = you, y = partner),
      shape = 4,
      size = 4
    ) +
    # leave appropriate cushion on x and y axes
    coord_cartesian(
      xlim = c(
        max(age_min_data, input$age_you - cushion),
        min(age_max_data, input$age_you + cushion)
      ),
      ylim = c(
        max(age_min_data, input$age_partner - cushion),
        min(age_max_data, input$age_partner + cushion)
      )
    )
})


server <- function(input, output) {
  # create a reactive plot based on age inputs
  output$age_plot <- renderPlot({
    # base plot
    age_plot +
      # label the current point
      geom_point(
        data = tibble(
          you = input$age_you,
          partner = input$age_partner
        ),
        mapping = aes(x = you, y = partner),
        shape = 4,
        size = 4
      ) +
      # leave appropriate cushion on x and y axes
      coord_cartesian(
        xlim = c(
          max(age_min_data, input$age_you - cushion),
          min(age_max_data, input$age_you + cushion)
        ),
        ylim = c(
          max(age_min_data, input$age_partner - cushion),
          min(age_max_data, input$age_partner + cushion)
        )
      )
  })

  # calculate if the relationship is permissible
  output$age_check <- renderText(age_check(
    input$age_you,
    input$age_partner
  ))
}

# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)

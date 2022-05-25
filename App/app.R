# load packages

library(shiny)
library(tidyverse)
library(rsconnect)

# load data


# define UI

tab1_sidebar_content <- sidebarPanel(
    "tab1 sidebar panel"
)

tab1_main_content <- mainPanel(
    "tab1 main panel"
)

tab1 <- tabPanel(
    "Tab1",
    titlePanel("Tab1 title"),
    sidebarLayout(tab1_sidebar_content, tab1_main_content)
)

tab2_sidebar_content <- sidebarPanel(
    "tab2 sidebar panel"
)

tab2_main_content <- mainPanel(
    "tab2 main panel"
)

tab2 <- tabPanel(
    "Tab2",
    titlePanel("Tab2 title"),
    sidebarLayout(tab2_sidebar_content, tab2_main_content)
)

ui <- navbarPage(
    "Title of the project",
    tab1,
    tab2
)

# define server function
server <- function(input, output, session) {

}

# create the shiny app object
shinyApp(ui = ui, server = server)
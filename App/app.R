# load packages

library(shiny)
library(tidyverse)
library(rsconnect)
library(colorspace)
library(scales)
library(lubridate)
library(data.table)

# load data
# read in all ATP ranking csv files
my_files <- list.files(path = "./data/atp/",
                    pattern = "atp_rankings*",
                    full.names = TRUE)

rankings_all_ATP <- my_files %>% map_df(~read_csv(., show_col_types = FALSE))

# read in all WTP ranking csv files
my_files <- list.files(path = "./data/wta/",
                    pattern = "wta_rankings*",
                    full.names = TRUE)

rankings_all_WTA <- my_files %>% map_df(~read_csv(., show_col_types = FALSE))

# define helper functions

# slices a df along the time axis,
# uses start date, end data, and time period to skip
  # s: start date. string or Date.
  # e: end date. Ditto.
  # p: period. integer.
  # return: a data.table object,
  # with an extra int `period` column that gives the index of the time slice
time_slice <- function(s, e, p, u=c("y", "m", "d")) {
    u <- match.arg(u)
    uf <- list("y" = years,"m" = months, "d" = days)
    data.table(s = seq(as.Date(s),
            as.Date(e),
            by = paste(p, u)))[, `:=` (e = s %m+% uf[[u]](p), period = 1:.N)]
}

# filters and slices rankings date
  # R: subset data for only top R rankings. integer.
  # Y: make Y-year time slices. integer.
  # returns: data.frame dataframe with time encoded in the variable `period`
treat_rankings_data <- function(df, R, Y) {
    # treat df, incl. resticting to top R ranks
    df <- df %>%
        # keep only top R rankings
        filter(rank <= R) %>%
        # turn year column into a Date object
        mutate(rankingDate = ymd(ranking_date)) %>%
        select(-ranking_date)
    # slice into Y-year slices (or whatever period you wish)
    setDT(df)
    start <- min(df$rankingDate) # must be a string or Date, like "2000-01-01"
    end <- max(df$rankingDate)
    # slice data and collect mean and SD of `rank` variable
    df_sliced <- df[time_slice(start, end, Y),
                    on = .(rankingDate >= s, rankingDate <= e)] %>%
        .[,.(avg_rank = mean(rank, na.rm = T),
        sd_rank = sd(rank, na.rm = T)), by = .(player, period)]
    df_sliced
}

# define UI

tab1_sidebar_content <- sidebarPanel(
    selectInput(
        "time_slice", "Time Slice",
        c("1" = 1,
            "2" = 2,
            "5" = 5,
            "10" = 10),
        selected = 1
    ),
    selectInput(
        "ranks", "Ranks to Include",
        c("10" = 10,
            "20" = 20,
            "50" = 50,
            "100" = 100,
            "200" = 200,
            "500" = 500,
            "1000" = 1000),
        selected = 10
    )
)

tab1_main_content <- mainPanel(
    plotOutput("plot1")
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
    output$plot1 <- renderPlot({
        R <- input$ranks # top R-rankings
        Y <- input$time_slice # Y-year time slices

        rankings_all_ATP_sliced <- treat_rankings_data(rankings_all_ATP, R, Y)
        rankings_all_WTA_sliced <- treat_rankings_data(rankings_all_WTA, R, Y)

        ## Calculate average SD for each time slice
        ## NB: we want is the average SD for all men = RMS(individual SD's).
        stats_ATP <- rankings_all_ATP_sliced %>%
            group_by(period) %>%
            summarise(total_sd = seewave::rms(sd_rank, na.rm = T))
        stats_WTA <- rankings_all_WTA_sliced %>%
            group_by(period) %>%
            summarise(total_sd = seewave::rms(sd_rank, na.rm = T))

        ## Combine stats df's and plot
        bind_rows(stats_ATP, stats_WTA, .id = "id") %>%
            mutate(id = recode(id, "1" = "ATP", "2" = "WTA")) %>%
        ggplot(aes(x = period, y = total_sd, colour = id)) +
            geom_point() +
            geom_hline(yintercept = mean(stats_ATP$total_sd), colour = "red") +
            geom_hline(yintercept = mean(stats_WTA$total_sd), colour = "blue") +
            labs(
                title = "Inconsistency in performance of pro tennis players",
                subtitle = paste0("1980-2020, ", Y, "-year time slices, ", "top ", R," ranks only"),
                y = "Spread",
                x = "Time period"
        )
    })
}

# create the shiny app object
shinyApp(ui = ui, server = server)
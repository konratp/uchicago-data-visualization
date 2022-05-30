
# load packages
library(shiny)
library(tidyverse)
library(rsconnect)
library(colorspace)
library(scales)
library(lubridate)
library(data.table)
library(shinythemes)
library(thematic)
library(ggtext)
library(stringi)

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


# read in all ATP match data
filenames <- list.files(path = "./data/atp/",
                        pattern = "atp_matches*",
                        full.names = TRUE)

combo_data_ATP <- map_df(filenames,
    ~read_csv(.x,
    col_types = cols_only(best_of = "i",
                            w_bpFaced = "i",
                            w_bpSaved = "i",
                            l_bpFaced = "i",
                            l_bpSaved = "i",
                            surface = "c"),
    show_col_types = FALSE)
    %>% mutate(year = as.integer(stri_extract_last(.x, regex = "(\\d+)")))
) %>%
    na.omit()

# read in all WTP match data
filenames <- list.files(path = "./data/wta/",
                        pattern = "wta_matches*",
                        full.names = TRUE)

combo_data_WTA <- map_df(filenames,
    ~read_csv(.x,
    col_types = cols_only(best_of = "i",
                            w_bpFaced = "i",
                            w_bpSaved = "i",
                            l_bpFaced = "i",
                            l_bpSaved = "i",
                            surface = "c"),
    show_col_types = FALSE)
    %>% mutate(year = as.integer(stri_extract_last(.x, regex = "(\\d+)")))
) %>%
  na.omit()

# calculate stats
# ATP stats
breaks_stats_ATP <- combo_data_ATP %>%
    mutate(total_breaks = (w_bpFaced - w_bpSaved) + (l_bpFaced - l_bpSaved)) %>%
    mutate(breaks_per_set = total_breaks / best_of) %>%
    group_by(year, surface) %>%
    summarise(
        avg_breaks_surface = mean(breaks_per_set, na.rm = TRUE)
    )

breaks_per_year_ATP <- breaks_stats_ATP %>%
    summarise(avg_breaks = mean(avg_breaks_surface))

# WTA stats
breaks_stats_WTA <- combo_data_WTA %>%
    mutate(total_breaks = (w_bpFaced - w_bpSaved) + (l_bpFaced - l_bpSaved)) %>%
    mutate(breaks_per_set = total_breaks / best_of) %>%
    group_by(year, surface) %>%
    summarise(
        avg_breaks_surface = mean(breaks_per_set, na.rm = TRUE)
    )

breaks_per_year_WTA <- breaks_stats_WTA %>%
  summarise(avg_breaks = mean(avg_breaks_surface))

#set theme

thematic_on()

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

tab0 <- tabPanel(
    "About",
    h1("Title stuff"),
    p("other stuff")
)

tab1_sidebar_content <- sidebarPanel(
    selectInput(
        "time_slice", "Time Slice",
        c("2" = 2,
            "5" = 5,
            "10" = 10),
        selected = 5
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
        selected = 100
    ),
    p("- Change the time slice to aggregate a different number of years into a single period.  The value selected operates as the number of years to aggregate."),
    p("- Change the ranks to include to incorporate greater or fewer players into each aggregation.  Ranks up to the value selected will be included.")
)

tab1_main_content <- mainPanel(
    plotOutput("plot1")
)

tab1_vis_elements <- sidebarLayout(tab1_sidebar_content, tab1_main_content)

tab1 <- tabPanel(
    "Standard Deviation of Ranks",
    titlePanel("Do (long-term) fluctuations in rankings differ significantly between men and women?"),
    verticalLayout(
        tab1_vis_elements,
        p(
            "In this plot, we are investigating the ",
            strong("standard deviation"),
            "for ",
            strong("ATP", style = "color:#c82027"),
            " (male) and ",
            strong("WTA", style = "color:#1f1a4f"),
            " (female) player rankings in order to evaluate differences between long-term fluctuations between the two."
        ),
        p(
            ""
        ),
    )
)

tab2_sidebar_content <- sidebarPanel(
    selectInput(
        "surface", "Surface",
        c("All" = "All",
            "Hard" = "Hard",
            "Grass" = "Grass",
            "Clay" = "Clay",
            "Carpet" = "Carpet")
    ),
    p("- Select a specific surface to only include data for that surface or all to include the entire data set.")
)

tab2_main_content <- mainPanel(
    plotOutput("plot2")
)

tab2_vis_elements <- sidebarLayout(tab2_sidebar_content, tab2_main_content)

tab2 <- tabPanel(
    "Rate of Broken Serves",
    titlePanel("Do (short-term) fluctuations in matches (measured by tracking average number of service breaks per match) differ significantly between men and women?"),
    verticalLayout(
        tab2_vis_elements,
        p(
            "In this plot, we are investigating the ",
            strong("rate of service breaks"),
            "for ",
            strong("ATP", style = "color:#c82027"),
            " (male) and ",
            strong("WTA", style = "color:#1f1a4f"),
            " (female) players on different court surfaces."
        )
    )
)

ui <- navbarPage(
    theme = shinytheme("united"),
    "",
    tab0,
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

        limits <- c(0)
        breaks <- c(0)
        labels <- c(0)
        
        if (Y == 2) {
            limits <- c(1, 20)
            breaks <- c(1, 5, 10, 15, 20)
            labels <- c("1980-1981", "1988-1989", "1998-1999", "2008-2009", "2018-2019")
        } else if (Y == 5) {
            limits <- c(1, 8)
            breaks <- c(1, 2, 3, 4, 5, 6, 7, 8)
            labels <- c("1980-1984", "1985-1989","1990-1994","1995-1999","2000-2004","2005-2009","2010-2014","2015-2019")
        } else {
            limits <- c(1, 4)
            breaks <- c(1, 2, 3, 4)
            labels <- c("1980-1989", "1990-1999", "2000-2009", "2010-2019")
        }

        ## Combine stats df's and plot
        bind_rows(stats_ATP, stats_WTA, .id = "id") %>%
            mutate(id = recode(id, "1" = "ATP", "2" = "WTA")) %>%
        ggplot(aes(x = period, y = total_sd, colour = id)) +
            geom_point() +
            geom_hline(yintercept = mean(stats_ATP$total_sd), colour = "#c82027") +
            geom_hline(yintercept = mean(stats_WTA$total_sd), colour = "#1f1a4f") +
            scale_color_manual(values = c("ATP" = "#c82027", "WTA" = "#1f1a4f")) +
            scale_x_continuous(
                limits = limits,
                breaks = breaks,
                labels = labels
            ) +
            theme(legend.position = "none") +
            labs(
                title = "Average Standard Deviation in Rankings of <span style = 'color:#c82027;'>**ATP**</span> and <span style = 'color:#1f1a4f;'>**WTA**</span> Tennis Players",
                subtitle = paste0("1980-2019, ", Y, "-year time slices, ", "Top ", R," ranks only"),
                y = "Spread",
                x = "Time period"
            ) +
            theme(plot.title = element_markdown())
    })

    output$plot2 <- renderPlot({
        selected_surface <- input$surface

        if (selected_surface == "All") {
            bind_rows(breaks_per_year_ATP, breaks_per_year_WTA, .id = "id") %>%
            mutate(id = recode(id, "1" = "ATP", "2" = "WTA")) %>%
            ggplot(aes(x = year, y = avg_breaks, colour = id)) +
                geom_point() +
                scale_color_manual(values = c("ATP" = "#c82027", "WTA" = "#1f1a4f")) +
                labs(
                    title = "Rate of Service Breaks for <span style = 'color:#c82027;'>**ATP**</span> and <span style = 'color:#1f1a4f;'>**WTA**</span> players",
                    subtitle = "1991 - Current",
                    y = "Breaks per set",
                    x = "Year"
                ) +
                theme(legend.position = "none") +
                theme(plot.title = element_markdown())
        } else {
            bind_rows(breaks_stats_ATP, breaks_stats_WTA, .id = "id") %>%
            mutate(id = recode(id, "1" = "ATP", "2" = "WTA")) %>%
            filter(surface == selected_surface) %>%
            ggplot(aes(x = year, y = avg_breaks_surface, colour = id)) +
                geom_point() +
                scale_color_manual(values = c("ATP" = "#c82027", "WTA" = "#1f1a4f")) +
                labs(
                    title = "Rate of Service Breaks for <span style = 'color:#c82027;'>**ATP**</span> and <span style = 'color:#1f1a4f;'>**WTA**</span> players",
                    subtitle = "1991 - Current",
                    y = "Breaks per set",
                    x = "Year"
                ) +
                theme(legend.position = "none") +
                theme(plot.title = element_markdown())
        }
    })
}

# create the shiny app object
shinyApp(ui = ui, server = server)
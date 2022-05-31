
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
library(plotly)

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
#   s: start date. string or Date.
#   e: end date. Ditto.
#   p: period. integer.
#   return: a data.table object,
#   with an extra int `period` column that gives the index of the time slice
time_slice <- function(s, e, p, u=c("y", "m", "d")) { 
    u <- match.arg(u)
    uf <- list("y" = years, "m" = months, "d" = days)
    data.table(s = seq(as.Date(s),
            as.Date(e),
            by = paste(p, u)))[, `:=`(e = s %m+% uf[[u]](p), period = 1:.N)]
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
    h1("Comparing Consistency in Performance between Men and Women in Professional Tennis"),

    h2("Introduction"),
    p("In this data visualization project, we are interested in gaining a better understanding of trends and fluctuations in professional Tennis
over the years. To accomplish this, we will analyse from the ATP (men) and WTA (women) tours for the past several decades. Furthermore, 
we plan on building a shiny app that lets users interactively explore the evolution of these tennis statistics with time."),

    h2("Goal and Motivation"),
    p("The goal is to measure both long-term and short-term consistency in performance among professional men and women tennis players, 
playing on the ATP and WTA tours resp. To measure consistency, we will measure fluctuations -- a statistically well-defined 
quantity -- since less fluctuation means more consistency. Why do we study this?"),
    p("This is our contribution to the long-standing debate about performance discrepancies between men and women athletes. There was a parallel debate
in the professional tennis world for a long time about whether men and women tennis players should get equal prize money. For example, it was only in 2007 that Wimbledon started offering equal money to men and women."),
    p("One of the issues at hand in this debate is whether men and women athletes perform equally 'well'. There are few objective ways of answering this. 
      Measuring the most evident markers of performance, like race times in athletics and swimming, or number of points played and/or won in a tennis match, is not a very fruitful approach, since men and women are naturally built differently and have different physical abilities. So we thought of a tracking not the average performance (viz. a first-order variable), but fluctuations in the performance (viz., a second-order variable)."),
    p("For this, we will tap into the vast amount of data available on ATP and WTA tournaments. We will measure both long-term fluctuations and short-term fluctuations (see details below). We also seek to make this analysis accessible by building a shiny app that lets users explore different dynamics underlying the data."),

    h2("Data"),
    p("The data we’re using comes from Jeff Sackmann’s GitHub page. The data contains separate .csv files for matches (by
year, starting in 1968/1980 for ATP and WTA, respectively) and rankings
(by decade, starting in the 1970s/1980s for ATP and WTA, respectively).")
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
    "Fluctuations in rankings",
    titlePanel("Long-term analysis: Do fluctuations in rankings differ significantly between men and women?"),
    verticalLayout(
        tab1_vis_elements,
        strong("What:"),
        p(
          "In this plot, we show the ",
            strong("standard deviation (SD) in rankings"),
            "for ",
            strong("ATP", style = "color:#c82027"),
            " (male) and ",
          strong("WTA", style = "color:#1f1a4f"),
          " (female) player rankings."
        ),
        br(),
        strong("How:"),
        p("As a measure of long-term fluctuations, we measure the standard deviation (SD) in rankings over some time period. To be able to 
            explore different different 'regions' of ranking space, we include the ability to analyse only the top-R spots in the rankings. 
            For simplicity, these are restricted to some chosen values."),
        br(),
        strong("Observations:"),
        p("We can see that for a most combinations of rank and time slice, the fluctuation in rankings differs more for the ATP (men’s) division than the WTA (women’s) division. This might indicate a difference in competitiveness of the two divisions, as one could conclude that there is a greater amount of highly-skilled players vying for the top ranks in the ATP than the WTA, and that ATP players are closer to one another when it comes to skill level than players in the WTA. Anecdotal evidence – e.g. Serena Williams’ domination of female Tennis for many years as opposed to multiple male players winning important tournaments on a regular basis – may support this claim, though an analysis of other measures would be crucial before drawing final conclusions. 

Another interesting finding is that the fluctuation in rankings increases as one includes more ranks in the analysis, indicating that there is a higher fluctuation in the lower ranks, and that relative to lower-ranked players, higher-ranked players experience less fluctuation in their rank. Perhaps once players reach a certain level, outside factors such as sponsoring, equipment, or training facilities might all contribute to a cementing of a given player in the top, while lower-ranked players may not be able to assert their dominance over even lower-ranked players as easily.")

        # time slice 5 and top 10 ranks, time slice of 10 and top 500 ranks
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
    "Frequency of service breaks during matches",
    titlePanel("Short-term analysis: Do fluctuations during matches differ significantly between men and women?"),
    verticalLayout(
        tab2_vis_elements,
        strong("What:"),
        p(
            "In this plot, we show the ",
            strong("rate of service breaks"),
            "for ",
            strong("ATP", style = "color:#c82027"),
            " (male) and ",
            strong("WTA", style = "color:#1f1a4f"),
            " (female) players on different court surfaces." 
        ),
        br(),
        strong("How:"),
        p("As a proxy for short-term fluctuations -- i.e. fluctuations at the time scale of a match -- we count the average number of service breaks per set. 
          The assumption here is that getting to serve is an advantage in tennis. Thus,", 
          em("holding one's serve is a marker of playing with consistency."), 
          " Therefore, 
          counting the number of breaks of serve in a match is a proxy for the 'net playing inconsistency' in the match."
        ),
        br(),
        strong("Observations:"),
        em("Irrespective of playing surface, we see that there are less service breaks in male tennis matches than female ones."),
        br(),
        p("This clearly indicates the men hold their serve more consistently than women, by a ratio of roughly 70%. However, this 
          what we can infer from this is not evident. The only clear inference is that women are less stronger than serving than men, which
          could easily be attributed to differences in base physique and genetic makeup. To infer from this than women are less 'consistent' 
          than men during a match is still a tenuous claim. It requires a further step in logic, and needs to be backed up with more analysis."),
        p("Interestingly, we also see that the rate of service breaks per match has decreased over time for both WTA and ATP players. This might indicate
        that both men and women are gradually learning to take better advantage of their service games. The trend is more 
          noticeable for ATP since their data extends further back into the past (1991 vs. 2003 for women).")
    )
)

# all, 2.5, 1.6
# hard, 2.5, 1.7
# grass, 2.2, 1.4
# clay, 2.7, 1.7
# carpet, 2.5, 1.5

ui <- navbarPage(
    theme = shinytheme("sandstone"),
    "",
    tab0,
    tab1,
    tab2
)

# define server function
server <- function(input, output, session) {
    output$plot1 <- renderPlot({
        R <- as.integer(input$ranks) # top R-rankings
        Y <- as.integer(input$time_slice) # Y-year time slices

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
            geom_point(size = 3) +
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
                y = "Rankings SD",
                x = "Time period",
                caption = "Source: https://github.com/JeffSackmann"
            ) +
            theme(plot.title = element_markdown())
    })

    output$plot2 <- renderPlot({
        selected_surface <- input$surface

        if (selected_surface == "All") {
            bind_rows(breaks_per_year_ATP, breaks_per_year_WTA, .id = "id") %>%
            mutate(id = recode(id, "1" = "ATP", "2" = "WTA")) %>%
            ggplot(aes(x = year, y = avg_breaks, colour = id)) +
                geom_point(size = 3) +
                scale_color_manual(values = c("ATP" = "#c82027", "WTA" = "#1f1a4f")) +
                labs(
                    title = "Rate of Service Breaks for <span style = 'color:#c82027;'>**ATP**</span> and <span style = 'color:#1f1a4f;'>**WTA**</span> players",
                    subtitle = "1991 - Current",
                    y = "Breaks per set",
                    x = "Year",
                    caption = "Source: https://github.com/JeffSackmann"
                ) +
                theme(legend.position = "none") +
                theme(plot.title = element_markdown())
        } else {
            bind_rows(breaks_stats_ATP, breaks_stats_WTA, .id = "id") %>%
            mutate(id = recode(id, "1" = "ATP", "2" = "WTA")) %>%
            filter(surface == selected_surface) %>%
            ggplot(aes(x = year, y = avg_breaks_surface, colour = id)) +
                geom_point(size = 3) +
                scale_color_manual(values = c("ATP" = "#c82027", "WTA" = "#1f1a4f")) +
                labs(
                    title = "Rate of Service Breaks for <span style = 'color:#c82027;'>**ATP**</span> and <span style = 'color:#1f1a4f;'>**WTA**</span> players",
                    subtitle = "1991 - Current",
                    y = "Breaks per set",
                    x = "Year",
                    caption = "Source: https://github.com/JeffSackmann"
                ) +
                theme(legend.position = "none") +
                theme(plot.title = element_markdown())
        }
    })
}

# create the shiny app object
shinyApp(ui = ui, server = server)
Olympics and Society – Cold War Politics and Gender Equality in the
Arena
================
by Elated Anura (Xinyu Wei, Kamran Ahmed, Konrat Pekkip)

``` r
#load relevant packages
library(tidyverse) # data manipulation
library(psych) # describe function: statistical summary
library(broom) # tidy function: statistical outputs into tibbles
library(kableExtra) # make-up tables
library(stargazer) # nice regression outputs
library(here) # simplifies relative file paths
library(countrycode) #get country names
library(emojifont) # add emoji font
library(cowplot) # combine plots
```

``` r
#read in datasets
olympics_data <- read_csv(here("data", "olympics.csv"))

countrycode <- codelist_panel %>%
  rename(noc = ioc,
         country = country.name.en) %>%
  select(noc, continent, country) %>%
  distinct()

#amend countrycode dataset to  fill crucial missing values
countrycode$noc[70] <- "GDR" #east germany
countrycode$continent[70] <- "Europe"
countrycode$noc[51] <- "TCH" #czechoslovakia
countrycode$continent[51] <- "Europe"
countrycode <- rbind(countrycode, c("URS", "Europe", "Soviet Union"))
countrycode <- rbind(countrycode, c("FRG", "Europe", "West Germany"))

#merge olympics and countrycode datasets
olympics_joined <- left_join(olympics_data, unique(countrycode), by = "noc")

#add/manipulate variables to merged dataset
nato <- c("Belgium", "Canada", "Denmark", "France", "Iceland", "Italy", "Luxembourg", 
          "Netherlands", "Norway", "Portugal", "United Kingdom", "United States",
          "Greece", "Turkey", "West Germany", "Germany", "Spain")
wp <- c("Russia", "Hungary", "Bulgaria", "Poland", "German Democratic Republic", 
        "Romania", "Czechoslovakia", "URS", "Soviet Union")
olympics_joined <- olympics_joined %>%
  mutate(medal_binary = ifelse(!is.na(medal), 1, 0),
         medal_weighted = case_when(medal == "Gold" ~ 3,
                                    medal == "Silver" ~ 2,
                                    medal == "Bronze" ~ 1,
                                    TRUE ~ 0),
         nato_wp = case_when(country %in% nato ~ "NATO",
                             country %in% wp ~ "Warsaw Pact",
                             TRUE ~ "Non-Aligned or not applicable"),
         usa_ussr = case_when(noc == "URS" | noc == "RUS" ~ "USSR/Russia",
                              noc == "USA" ~ "USA",
                              TRUE ~ "Other")) %>%
  group_by(games) %>%
  mutate(medal_sum = sum(medal_binary))

#set theme for graphs
bg_theme <- theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = rel(1.2)),
        axis.title.x = element_text(margin = margin(t = 10), size = rel(0.8)),
        axis.title.y = element_text(margin = margin(r = 10),size = rel(0.8)),
        strip.text = element_text(face = "bold", size = rel(0.8), hjust = 0.5),
        plot.caption = element_text(face = "italic",size = rel(0.8), 
                                    margin = margin(t = 10)),
        legend.title = element_text(face = "bold",size = rel(0.6)),
        legend.text = element_text(size = rel(0.6)))
```

## Introduction

The Olympics have always been about politics as much as sports. The
history of the Olympics mirrors the progress of many international and
social activities. In this project, we name two broad topics - the
across-state competition in the bipolar world after WWII and a long
consisting issue around gender equity in the sports world. Our goal is
to conduct data analysis and visualization to illustrate, first, before
and after the cold war, how the Soviet Union compared to the United
States (or, NATO to Warsaw Pact) competed in the Games; second, how
female participation has changed over the years and which countries have
seen highest contributions from females.

To answer the questions, we use a historical dataset, `olympics_data`,
on the TidyTuesday repository, originally from
[www.sports-reference.com](www.sports-reference.com). It has recorded
the background and participation of each athlete in the summer and
winter Olympics from 1896 until 2016. It contains a total of 271,116
observations and 15 variables. We also combine the dataset from the
`countrycode` package, to add in official country names. The variables
under heavy usage include `noc` or `country`, `year`, `season`, `medal`,
`sex`, `sport`, etc. For a more detailed codebook and data description,
please refer to the `data` folder.

## Question 1 – The Olympics and the Cold War

### Introduction

The Olympics served as an outlet for different (city-)states to compete
with one another through athletics rather than warfare both in antiquity
and modernity. Given that following World War II, there was a bipolar
world order with the United States of America (USA) and the Union of
Soviet Socialist Republics (USSR) as the world’s greatest superpowers,
the Olympics were an outlet for the two players to compete with one
another outside of the many proxy wars they fought. In the following, we
want to examine the following questions:

1.  How has the dominance of the Soviet Union (/Russia as its main
    successor) and the United States changed throughout the cold war and
    after?
2.  How do NATO and Warsaw Pact member-states compare in terms of medals
    won at the Olympics?

In order to answer these questions, we examine the `country` variable
(coded based on the `noc` variable) and, relatedly, the `nato_wp`
variable which indicates whether a country was a member of NATO, the
Warsaw Pact, or non-aligned (also coded based on the `noc` variable). To
measure their success in the Olympics, we calculate the proportion of
medals won by the USSR/Russia or the USA and all other countries (stored
in the `medal_prop` variable), and we also examine the total amount of
medals won by NATO/Warsaw Pact members. Finally, we also assess the
`season` variable in order to differentiate between Summer and Winter
Olympics.

Please note that we categorize countries into the NATO or Warsaw Pact
categories based on their allegiances during the Cold War. Countries
like Poland or the Baltic countries which were part of the Warsaw Pact
during the Cold War and joined NATO after it ended are still coded as
Warsaw Pact members. Moreover, we decided not to include Albania as a
Warsaw Pact member due to the Soviet-Albanian split of 1968.

### Approach

We believe that time-series plots are best-suited to examine changes and
trends over periods of time; thus we construct a time-series plot and
line graph to examine how the proportion of medals won by the USA and
USSR/Russia have developed over time. On the x-axis, we plot the `year`
variable, and on the y-axis, we plot the `medal_prop` variable
indicating the proportion of medals won by the United States and the
USSR/Russia. The color aesthetic helps us differentiate between medals
won by the United States, the USSR/Russia, and other countries. We facet
the plot by the `season` variable to indicate whether medals were won in
Summer or Winter Olympics, and add vertical lines to this plot
indicating the end of World War II (1945), as well as the end of the
Cold War as marked by the dissolution of the USSR (1991).

As the second question is more about the overall performance of members
of the Warsaw Pact and NATO, we choose to represent the type and amount
of medals won by each relevant country in a bar chart. The bars itself
indicate the amount of medals each country won, and the bars are ordered
based on the total amount of medals won in descending order. We use
colors to indicate whether a country was aligned with NATO (blue) or the
Warsaw Pact (red). We believe that this is the best way of assessing the
question visually, as it represents all relevant information in a
simple, straightforward manner. Please note that between 1956 and 1964,
East and West Germany sent a joint team to represent both countries in
the Olympics, thus complicating the visualization of medals won by NATO
and Warsaw Pact countries below.

### Analysis

``` r
#create data frame with information relevant to create visualization
q1_df <- olympics_joined %>%
  filter(year >= 1922) %>%
  group_by(year, usa_ussr, season) %>%
  summarize(medal_prop = (sum(medal_binary)/medal_sum), .groups = "drop")

#create plot mapping USA/USSR/others medals over time
q1_df %>%
  ggplot(mapping = aes(x = year, y = medal_prop, color = usa_ussr, na.rm = TRUE))+
  geom_line() +
  geom_vline(xintercept = 1945,
             linetype = "dashed",
             alpha = 0.75) +
  geom_vline(xintercept = 1991,
             linetype = "dashed",
             alpha = 0.75) +
  annotate("text", label = "End of World War II", x = 1945, y = 0.9, size = rel(2.3), hjust = 0) +
  annotate("text", label = "Dissolution of the USSR", x = 1991, y = 0.5, size = rel(2.3), hjust = 1.01) +
  facet_wrap(vars(season)) +
  scale_color_manual(values = c("grey", "blue", "red")) +
  scale_x_continuous(breaks = seq(1920, 2022, 12),
                     name = "Year") +
  scale_y_continuous(breaks = seq(0, 1, 0.2),
                     name = "Proportion of Medals Won") +
  bg_theme +
  theme(axis.text.x = element_text(hjust = 1, size = rel(0.9)),
        panel.spacing = unit(1.5, "lines")) +
  labs(title = "Olympic Performance of USSR/Russia and USA over Time",
       subtitle = "Proportion of Medals Won by Each Country in Summer and Winter Olympics",
       caption = "Source: data from www.sports-reference.com in 2018",
       color = "Country")
```

![](README_files/figure-gfm/q1-analysis-plot-1-1.png)<!-- -->

``` r
#create function to help recode necessary variables
recode_if <- function(x, condition, ...) {
  if_else(condition, recode(x, ...), x)
}

#create data frame with information relevant to create visualization
q2_df <- olympics_joined %>%
  filter((nato_wp == "NATO" | nato_wp == "Warsaw Pact") & (year >= 1945 & year <= 1991)) %>%
  mutate(country = recode(country, "Germany" = "United Team of Germany (1956-1964)"),
         country = recode(country, "German Democratic Republic" = "East Germany"),
         nato_wp = as.factor(recode_if(nato_wp, country == "United Team of Germany (1956-1964)", "NATO" = "Both"))) %>%
  group_by(country, nato_wp) %>%
  summarize(medals_won = sum(medal_binary), .groups = "drop")

#create stacked bar chart mapping amount of medals won by country
q2_df %>%
  ggplot(mapping = aes(y = reorder(country, medals_won), x = medals_won, fill = nato_wp)) +
  geom_col() +
  scale_fill_manual(values = c("blue", "red", "magenta")) +
  bg_theme +
  labs(title = "Medals Won by NATO and Warsaw Pact Countries",
       subtitle = "In Olympics during the Cold War, 1945-1991",
       x = "Number of Olympic Medals Won",
       y = "Country",
       fill = "Military Alliance")
```

![](README_files/figure-gfm/q1-analysis-plot-2-1.png)<!-- -->

### Discussion

The first plot shows that throughout most of the Cold War (visually
represented as the space between the dashed lines), the Soviet Union won
a higher proportion of medals than the United States did. The difference
is particularly stark for the winter Olympics, where the Soviet Union
maintained a steady lead over the United States ever since the inception
of its Winter Olympics program in the 1950s. While the American
performance has remained somewhat stable in the Summer Olympics and even
improved in the Winter Olympics in the years following the dissolution
of the USSR, the same cannot be said for Russia, the main successor
state to the Soviet Union. The percentage of medals won by the
USSR/Russia decreased immensely right before the dissolution of the USSR
and afterwards, which is likely related to the economic and political
upheaval the country went through in the late 1980s and early 1990s.
Overall, the performance of both the United States and the Soviet Union
during the Cold War was remarkable, which confirms our expectations that
both countries were eager to one-up one another in an effort to prove
their respective system’s superiority.

The second plot provides more context to the previous finding that the
United States and the Soviet Union dominated the medal counts in the
Olympic Games during the Cold War. East Germany and Hungary both earned
a remarkable amount of medals, especially considering that only those
East German medals were counted that were not won by the United Team of
Germany that competed in the Olympics between 1956 and 1964. The only
definitive conclusion we want to draw from this graph is that neither
NATO nor the Warsaw Pact, that is to say, neither the capitalist nor the
communist systems, produced a clear “winner” in terms of outperforming
the other at the Olympics. While the Soviet Union won more medals than
the United States, Italy and France won more medals than, for example,
Romania and Poland. We speculate that the Olympics mattered more in some
national contexts than others: for example, the high number of Olympic
medals won by East and West Germany might reflect the direct competition
the two were in and the high salience of the systemic differences
between the two countries.

## Question 2 – Women in the Olympics

### Introduction

Women started to participate in the Olympic Games beginning in the year
1900 in Paris. Among a total of around 1,000 athletes, only 22 women
competed in five disciplines, according to International Olympic
Committee. Since then, the number of female participants and that of
sports females can compete has increased and is expected to keep
increasing in the near future. Given persisting gender inequalities in
many countries, we are interested in analyzing gender representation in
the sports world. From a historical perspective, first, we are curious
to see how female participation has changed in Olympic Games. Second, we
also look into the female athletes performance on the country level and
plan to spotlight countries with top female contribution. Our following
approach, analysis, and visualization will further demonstrate these two
issues of interest.

To illustrate gender difference in Olympic, our dataset provides rich
information on individual athletes with their `name`, `sex`, `noc`,
`sports`, `year`, `medal`, etc. It allows us to create new variables for
summarized tables and time-series analysis. For example, it is feasible
to compute the proportion of female athletes and the count of sports for
each Game and season over the years. Grouping by the `noc` code, the
dataset aids us in generating summarized tables for ranking and
comparing females medalists across countries. More rigorously, since
countries may differ greatly in the number of female participants, we
normalize the measure of female medalists by calculating the proportion
of medals that comes from female athletes among all medals for a given
country.

### Approach

To answer the first question, “How has female participation in Olympics
changed throughout history?” we construct an overall time-series line
plot. This plot comes from a summarized table with the average
proportion of female athletes and the proportion of games female
athletes participate in over the years. The two measures are positioned
on the y-axis and illustrated in different colors - and they are
manually set to be in Olympic-logo colors\! The year for each event is
on the x-axis. The season information is demonstrated through two
different facets. We choose the line plot format first because it can
best visually represent the trend information. Second, it has an
advantage in terms of data-ink-ratio for visualization, therefore it
helps simplify the complexities in our aggregated data.

For the second part, “Which countries have the highest numbers of female
medalists or enjoy the most contributions from female athletes over the
recent years?” we construct lollipop plots and rank the top 15 countries
with the highest numbers of female medalists. We summarized a table
calculating the number of medals won by female and male participants for
each country, and also divided by the types of medals. We have two
versions to present the female contributions - one with the number of
medals won by women (non-normalized), and the other one with the
proportion of medals won by women for that country (normalized). We use
two plots side by side to demonstrate these two versions. The y-axis
shows the names of countries with the top rankings. The types of medals
are shown in different colors and emoji to be creative. Visually it’s
comparable to a stacked lollipop plot. We choose this format to approach
this question because it can clearly show the winning medal distribution
and the countries rankings. It can clearly give viewers a sense of
quantity through visualization.

### Analysis

``` r
# Create a summarized table for participation by gender for each season
participate_sex <- olympics_joined %>% 
  filter(year >= 1900) %>%
  group_by(year, season, sex) %>%
  summarize(count_sex = n_distinct(id), 
            count_game = n_distinct(sport), .groups = "drop")%>% 
  group_by(year, season) %>%
  mutate(visit = 1:n()) %>%
  gather("sex", "count_sex", "count_game", key = variable, value = number) %>%
  unite(combi, variable, visit) %>%
  spread(combi, number) %>%
  select(-c("sex_1", "sex_2")) %>% 
  mutate(count_sex_1 = as.numeric(count_sex_1),
         count_sex_2 = as.numeric(count_sex_2),
         count_game_1 = as.numeric(count_game_1),
         count_game_2 = as.numeric(count_game_2)) %>%
  mutate(f_athletes_p = count_sex_1 / sum(count_sex_1, count_sex_2),
         f_games_p = count_game_1 / sum(count_game_1, count_game_2))
# Plot the time series plot for female participation
q2_p1 <- participate_sex %>% 
  ggplot(aes(x = year, y = f_athletes_p)) +
  geom_line(aes(color = "Number of female athletes")) +
  geom_line(aes(x = year, y = f_games_p, 
                color = "Disciplines females compete in")) + 
  facet_wrap(vars(season), scales = "free") +
  labs(title = "Female Athletes Participation in the Olympic Games by Season",
       subtitle = "From 1900 to 2016",
       x = "Year",
       y = "Proportion",
       caption = "Source: data from www.sports-reference.com in 2018") +
  scale_color_manual(name = "Proportion of",
                     breaks = c("Number of female athletes",  "Games females compete in"),
                     values=c("Number of female athletes" = "orange",
                              "Disciplines females compete in" = "steelblue")) +
  scale_color_manual(name = "Proportion of",
                    breaks = c("Disciplines females compete in", "Number of female athletes"),
                    values=c("Number of female athletes" = "#F4C300",
                             "Disciplines females compete in" = "#0085C7")) +
  bg_theme
q2_p1 
```

![](README_files/figure-gfm/Q2-1-female%20participation-1.png)<!-- -->

``` r
# create the sum table for a wide table of each country and its' medals.
medalist_rank <- olympics_joined %>%
  filter(year >= 2000) %>% # focusing on  recent years
  mutate(gold = if_else(medal == "Gold", 1, 0),
         silver = if_else(medal == "Silver", 1, 0),
         bronze = if_else(medal == "Bronze", 1, 0)) %>%
  group_by(country, sex) %>%
  summarize(n_gold = sum(gold, na.rm = TRUE), 
            n_silver = sum(silver, na.rm = TRUE), 
            n_bronze = sum(bronze, na.rm = TRUE), .groups = "drop") %>%
  mutate(n_medal = n_gold + n_silver + n_bronze) %>%
  group_by(country) %>%
  mutate(visit = 1:n()) %>%
  gather("sex", "n_gold", "n_silver", "n_bronze", "n_medal", 
         key = variable, value = number) %>%
  unite(combi, variable, visit) %>%
  spread(combi, number) %>%
  select(-c("sex_1", "sex_2"))
medalist_rank[2:9] = lapply(medalist_rank[2:9], FUN = function(y){as.numeric(y)})
medalist_rank <- medalist_rank %>%
  mutate(fp_medal = n_medal_1 / sum(n_medal_1, n_medal_2))
# rank and use only the top 15 countries for plotting
top_15 <- medalist_rank %>%
  arrange(desc(n_medal_1)) %>%
  head(15) %>%
  mutate(n_b_s = n_bronze_1 + n_silver_1)
# create two plots with normalized and non-normalized two versions.
q2_p2_1 <- top_15 %>%
  ggplot(aes(x = n_medal_1, y = reorder(country, n_medal_1))) +
  geom_segment(aes(yend = country), xend = 0, colour = "#F4C300", size = 0.5, alpha = 0.6) +
  geom_emoji(alias = 'trophy', x = top_15$n_medal_1, y = top_15$country, 
             size = 3.5, color = "#D6AF36") +
  geom_emoji(alias = 'trophy', x = top_15$n_bronze_1, y = top_15$country, 
             size = 3.5, color = "#824A02") +
  geom_emoji(alias = 'trophy', x = top_15$n_b_s, y = top_15$country, 
             size = 3.5, color = "#A7A7AD") +
  scale_x_continuous(breaks = seq(0, 1000, 200)) +
  annotate("text", label = "Types of medals", x = 600, y = "United Kingdom", size = rel(2.6)) +
  annotate("rect", xmin = 400, xmax = 800, ymin = "Italy", ymax = "Japan", alpha = .1) +
  annotate("point", x = 500, y = "South Korea", colour = "#D6AF36", size = 1) +
  annotate("point", x = 500, y = "Norway", colour = "#A7A7AD", size = 1) +
  annotate("point", x = 500, y = "France", colour = "#824A02", size = 1) +
  annotate("text", x = 600, y = "South Korea", label = "Gold", size = rel(2.4), colour = "#D6AF36") +
  annotate("text", x = 600, y = "Norway", label = "Silver", size = rel(2.4), colour = "#A7A7AD") +
  annotate("text", x = 600, y = "France", label = "Bronze", size = rel(2.4), colour = "#824A02") + 
  labs(x = "Number of Medals Won by Women", y = "Countries",
       caption = " ") +
  theme_minimal() +
  bg_theme +
  theme(panel.grid.major.y = element_blank(),
        axis.text.y = element_text(size = rel(0.7))) 
q2_p2_2 <- top_15 %>% 
  ggplot(aes(x = fp_medal, y = reorder(country, n_medal_1))) +
  geom_segment(aes(yend = country), xend = 0, colour = "#009F3D", size = 0.5, alpha = 0.6) +
  geom_emoji(alias = 'trophy', 
             x = c(top_15$fp_medal[15], top_15$fp_medal[3], top_15$fp_medal[7]), 
             y = c("Romania", "China", "Netherlands"),
             size = 4, color = "#009F3D") +
  labs(x = "Proportion of Medals Won by Women", 
       caption = "Source: data from www.sports-reference.com in 2018") + 
  bg_theme +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major.y = element_blank()) 
# Adding two plots together for comparison

q2_p2 <- plot_grid(q2_p2_1, NULL, q2_p2_2, rel_widths = c(3.2, -0.7, 3), nrow = 1,
                   align = "hv", labels = c(str_pad("Number", 22, "left", " "), "", 
                                            str_pad("Percent", 23, "left", " ")), label_size = 9)
title <- ggdraw() + 
  draw_label("Countries with the Highest Number of Female Olympic Medalists, 2000-2016",
             fontface = 'bold', x = 0, hjust = -0.1, size = 12) +
  theme(plot.margin = margin(b = 10))
plot_grid(title, q2_p2, ncol = 1, rel_heights = c(0.1, 1))
```

![](README_files/figure-gfm/Q2-2-country%20ranking-1.png)<!-- -->

### Discussion

The first plot indicates a clear upward trend for both the proportion of
female athletes competing and the proportion of games they compete in.
It has gone from nearly 0 to about 0.5 - thus a half - in recent years.
This answers our first part of the question that females are having
increasing representation in Olympic Games. The trends are comparable
and rather similar in both summer and winter Olympics. We believe that
this time-series plot proves that while women were significantly
discriminated against and excluded in many sports, there has been a
shift towards more equality in recent years. This graph does not
showcase the reception of female vs male artists to the audience,
however, and might mask other underlying inequalities. For example, many
Olympics fans might be able to name Usain Bolt as the fastest man in the
world, or Michael Phelps as one of the most successful athletes in terms
of medals won; however, their female counterparts are less known to the
broader public.

The second plot zooms in on the 15 countries with the highest numbers of
medals won by females from the years 2000 to 2016. The descending order
allows us to observe that U.S., Russia, and China are positioned in the
top 3 in numbers, while Romania, China, and Netherlands have top
positions after normalization – in these countries, more than 60% of
medals are won by females. Although not among the top 3, the U.S. also
has over 50% medals contributed by female athletes. The plot answers our
second part of the question, namely which countries sport the highest
numbers of female Olympic medalists, by illustrating the size and degree
of female contributions for top-ranked countries.

## Presentation

Our presentation can be found [here](presentation/presentation.html).

## Data

rgriffin, 2018, `olympics.csv` from
[Kaggle](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results?select=noc_regions.csv).

Vincent Arel-Bundock, 2022, `countrycode` package version 1.3.1 – [See
documentation
here](https://cran.r-project.org/web/packages/countrycode/countrycode.pdf).

## References

Ellis Hughes (2022). tidytuesdayR: Access the Weekly ‘TidyTuesday’
Project Dataset. R package version 1.0.2.
<https://CRAN.R-project.org/package=tidytuesdayR>

International Olympic Committee. October 28, 2013. Archived from the
original
[(PDF)](https://web.archive.org/web/20200422134610/https://stillmed.olympic.org/Documents/Reference_documents_Factsheets/The_Olympic_Summer_Games.pdf)
on April 22, 2020. Retrieved March 17, 2017.

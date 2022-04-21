Project 1 Proposal
================
Elated Anura

## Dataset

The dataset we’re analyzing is available on kaggle and contains
historical data on the modern Olympic game and includes all games
starting from Athens 1896 till 2016. This data was scraped from
[www.sports-reference.com](www.sports-reference.com) in 2018 and
wrangled by rgriffin. Until 1992, winter and summer games used to be
held in the same year. Since 1992, both summer and winter games have
been taking place in a 4-year cycle (an olympiad!), resulting in winter
games in 1994, summer in 1996, then again winter in 1998, and so on. The
data set contains rich information on worldwide participation in Olympic
Games across yeas. We chose it because we’re interested in the Olympics,
and we believe we can show political and historical trends influencing
countries’ performances and contributions to hosting the Games.

This data contains 271,116 observations and 15 variables. Each row
contains data on an individual athlete participating in an individual
Olympic event. There is data on 66 different sports, 1184 different
teams, 51 games, 230 different NOCs, 42 different host cities across 35
different years. The variables are included in the codebook in the
`readme` file in the data folder in this repository.

In our data set, 72.5 percent of the participants are male whereas the
rest are female if we exclude missing values. The average age of the
athletes is 25.6 years, with the oldest athlete being 97 years old, and
the youngest being 10 years old. The average athlete height is 175.4cm,
the maximum height is 226cm, and the minimum height is 127 cm. The
average weight of an athlete is 70.7 kilograms, with the maximum being
214kg and the minimum being 25kg. 222,552 of the athletes participated
in the summer games, while 222,552 participated in the winter season.

``` r
olympics_data <- read_csv(here("data", "olympics.csv"))
```

    ## Rows: 271116 Columns: 15
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (10): name, sex, team, noc, games, season, city, sport, event, medal
    ## dbl  (5): id, age, height, weight, year
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#create dummy variables to ease statistical analysis
olympics_data$sex_dummy <- ifelse(olympics_data$sex=="M", 1,0)
vars_of_interest <- c("sex_dummy", "age", "height", "weight")
olympics_data %>%
  select(vars_of_interest) %>%
  lapply(., function(i) summary(i, na.rm =TRUE)) %>% 
  do.call(rbind, .) %>%
  kable(digits = 3)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Min.
</th>
<th style="text-align:right;">
1st Qu.
</th>
<th style="text-align:right;">
Median
</th>
<th style="text-align:right;">
Mean
</th>
<th style="text-align:right;">
3rd Qu.
</th>
<th style="text-align:right;">
Max.
</th>
<th style="text-align:right;">
NA’s
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sex_dummy
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.725
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
age
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
25.557
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
9474
</td>
</tr>
<tr>
<td style="text-align:left;">
height
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
175.339
</td>
<td style="text-align:right;">
183
</td>
<td style="text-align:right;">
226
</td>
<td style="text-align:right;">
60171
</td>
</tr>
<tr>
<td style="text-align:left;">
weight
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
70.702
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
214
</td>
<td style="text-align:right;">
62875
</td>
</tr>
</tbody>
</table>

``` r
olympics_data %>%
  group_by(team) %>%
   summarise(count=n())
```

    ## # A tibble: 1,184 × 2
    ##    team                  count
    ##    <chr>                 <int>
    ##  1 30. Februar               2
    ##  2 A North American Team     4
    ##  3 Acipactli                 3
    ##  4 Acturus                   2
    ##  5 Afghanistan             126
    ##  6 Akatonbo                  3
    ##  7 Alain IV                  3
    ##  8 Albania                  70
    ##  9 Alcaid                    3
    ## 10 Alcyon-6                  1
    ## # … with 1,174 more rows

``` r
olympics_data %>%
  group_by(sport) %>%
   summarise(count=n())
```

    ## # A tibble: 66 × 2
    ##    sport            count
    ##    <chr>            <int>
    ##  1 Aeronautics          1
    ##  2 Alpine Skiing     8829
    ##  3 Alpinism            25
    ##  4 Archery           2334
    ##  5 Art Competitions  3578
    ##  6 Athletics        38624
    ##  7 Badminton         1457
    ##  8 Baseball           894
    ##  9 Basketball        4536
    ## 10 Basque Pelota        2
    ## # … with 56 more rows

``` r
olympics_data %>%
  group_by(city) %>%
   summarise(count=n())
```

    ## # A tibble: 42 × 2
    ##    city        count
    ##    <chr>       <int>
    ##  1 Albertville  3436
    ##  2 Amsterdam    4992
    ##  3 Antwerpen    4292
    ##  4 Athina      15556
    ##  5 Atlanta     13780
    ##  6 Barcelona   12977
    ##  7 Beijing     13602
    ##  8 Berlin       6506
    ##  9 Calgary      2639
    ## 10 Chamonix      460
    ## # … with 32 more rows

``` r
# this gives the number of participants who participated in the games held in these cities
olympics_data %>%
  group_by(season) %>%
   summarise(count=n())
```

    ## # A tibble: 2 × 2
    ##   season  count
    ##   <chr>   <int>
    ## 1 Summer 222552
    ## 2 Winter  48564

``` r
length(unique(olympics_data$sport))
```

    ## [1] 66

``` r
length(unique(olympics_data$team))
```

    ## [1] 1184

``` r
length(unique(olympics_data$games))
```

    ## [1] 51

``` r
length(unique(olympics_data$year))
```

    ## [1] 35

``` r
length(unique(olympics_data$noc))
```

    ## [1] 230

``` r
length(unique(olympics_data$city))
```

    ## [1] 42

## Questions

We’re planning on creating graphs that will allows us to answer the
following two questions:

1.  How has the dominance of the Soviet Union/Russia and the United
    States changed throughout the cold war and after? Has the share of
    medals won by either NATO or Warsaw Pact countries decreased since
    the end of the cold war?

2.  Given persisting gender inequalities in many countries, we are
    interested in analyzing gender representation at the Olympics. Does
    the proportion of female to male athletes differ between countries
    on different continents? Further, does the distribution of medals
    won by female vs male athletes differ between the different
    continents as well?

## Analysis plan

The following lays out our plan for answering each of the research
questions. A major challenge that spans both of these questions is that
as of now, the dataset does not include the names of the countries each
athelete represents. We will be using country code data from
[geonames.org](geonames.org) to match each country code in the `NOC`
variable with a proper country name.

1.  In a first step, we will construct a time-series plot comparing the
    number of medals won by the United States and the USSR/Russia and
    all other countries. We plot the variable ‘year’ on the x-axis and a
    newly created variable counting the number of gold medals per
    country on the y axis. Finally, different colors (or facets, to be
    determined) will indicate whether medals were won in the Summer
    Olympics or the Winter Olympics, as well as display cumulative medal
    wins. In a second step, we expand the same analysis to not only
    include the United States and the USSR/Russia, but to include
    member-states of both NATO and the Warsaw Pact. In order to do so,
    we will create a variable indicating whether a country is part of
    NATO, the Warsaw Pact, or non-aligned.

2.  We will construct two plots to assess the second set of questions.
    Our first plot, a time-series plot, will indicate the proportion of
    female to male athletes on the y axis and year of the Olympic games
    on the x axis. Furthermore, we will make use of the color aesthetic
    to color code different lines by continent. Our second plot will
    replicate the same basic structure, except on the y axis it will map
    the proportion of medals won by female athletes by continent, which
    is again indicated by the color aesthetic.

Note: Just to distinguish the exact variables used in explaining Q1 and
Q2 so they are not completely overlapping, the potentially used
variables are listed here:

Q1: year/time, country (new variable derived from NOC), average number
of medals per country (new), types of medals, seasons, NATO/Warsaw Pact
member states (new)

Q2: country (new variable derived from NOC), sex, continent (new),
medal, year

Project 1 Proposal
================
Elated Anura

  - [Dataset](#dataset)
  - [Questions](#questions)
  - [Analysis plan](#analysis-plan)
  - [Final Note](#final-note)

## Dataset

The dataset we’re analyzing is available on kaggle and contains
historical data on the modern Olympic game including all games starting
from Athens 1896 till 2016. This data was scraped from
[www.sports-reference.com](www.sports-reference.com) in 2018 and
wrangled by rgriffin. Until 1992, winter and summer games used to be
held in the same year. Since 1992, both summer and winter games have
been taking place in a 4-year cycle (an olympiad\!), resulting in winter
games in 1994, summer in 1996, then again winter in 1998, and so on. The
data set contains rich information on worldwide participation in Olympic
Games across the years.

We choose it because we’re interested in the Olympics, and we believe
that first we can show political and historical trends influencing
countries’ performances. Second, we narrow down to the angle of gender
issues to find out female participation and performance over the years
and across countries.

This data contains 271,116 observations and 15 variables. Each row
contains data on an individual athlete participating in an individual
Olympic event.To give a broad view, our data include information on 66
different sports, 1,184 different teams, 51 games, 230 different NOCs,
42 different host cities across 35 different years. 222,552 of the
athletes participated in the summer games, while 48,564 participated in
the winter season. The description of variables is included in the
codebook in the `readme` file under the data folder in this repository.

    ##                  character  count
    ## 1               Total obs. 271116
    ## 2               Total vars     14
    ## 3            No. of sports     66
    ## 4             No. of teams   1184
    ## 5             No. of games     51
    ## 6              No. of NOCs    230
    ## 7    No. of hosting cities     42
    ## 8 No. of athletes (summer) 222552
    ## 9 No. of athletes (winter)  48564

After excluding missing values, 72.5 percent of the participants in our
data set are male whereas the rest are female. The average age of the
athletes is 25.6 years, with the oldest athlete being 97 years old, and
the youngest being 10 years old. The average athlete’s height is
175.4cm, the maximum height is 226cm, and the minimum height is 127 cm.
The average weight of an athlete is 70.7 kilograms, with the maximum
being 214kg and the minimum being 25kg.

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

sex\_dummy

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
    newly created variable counting the normalized number of medals per
    country on the y axis. Finally, different colors (or facets, to be
    determined) will indicate whether medals were won in the Summer
    Olympics or the Winter Olympics, as well as display cumulative medal
    wins. In a second step, we expand the same analysis to not only
    include the United States and the USSR/Russia, but to include
    member-states of both NATO and the Warsaw Pact. In order to do so,
    we will create a variable indicating whether a country is part of
    NATO, the Warsaw Pact, or non-aligned.

Considering the growing number of events in Olympics over time, we want
to normalize the number of medals to account for changes in the number
of events. There are multiple ways of normalization under consideration,
all of which we plan to test in our analysis. The one we eventually
choose will best help us convey a consistent story for this project.

One approach is to divide the number of medals won by a country in a
year by the total number of medals available in that particular year.
This will ensure that, for example, a country winning 10 medals out of
50 in year x, and then winning 20 out of 100 medals a few years later
doesn’t necessarily show a performance improvement in terms of the
success rate in Olympics, since the percentage of medals won remains the
same. Another approach is to divide a country’s medalists in a year by
the total number of participants from that country in the same year.
This country-level measure allows us to consider the potentially growing
number of participants per country. A third approach would be to
normalize around the average number of medals. This measure allows us to
see how a country is doing relative to the global average.

In a more detailed way, we can also aggregate the events by disciplines
to add more information for our time-series analysis, as long as the
visualization is not overcomplicated. To do so we will create a new
variable that groups the events by sports categories and summarize the
number of medals won in each discipline for each country over years.
This part can be illustrated through either colors or facets.

2.  We will construct two plots to assess the second set of questions.
    Our first plot, a time-series plot, will indicate the proportion of
    female athletes on the y axis and year of the Olympic games on the x
    axis. Furthermore, we will make use of the color aesthetic to color
    code different lines by continent. Our second plot will replicate
    the same basic structure, except on the y axis it will map the
    proportion of medals won by female athletes by continent, which is
    again indicated by the color aesthetic.

Finally, we will also create a bar chart indicating the 15 countries
with the highest number of female Olympic medalists in recent 50 years.
The range of years ensures that the numbers of events and participating
countries/athletes are more stabilized. The number of medals is on the x
axis, and the top-15 countries’ names is on the y axis with a descending
order. The number of different types of medals (gold, silver or bronze)
will be shown in different colors. We also consider putting summer
compared to winter seasons in different facets.

## Final Note

*Just to distinguish the exact variables used in explaining Q1 and Q2 so
they are not completely overlapping, the potentially used variables are
listed here:*

  - Q1: year, country (new variable derived from NOC), average number of
    medals per country (new and with appropriate normalization), types
    of medals, seasons, NATO/Warsaw Pact member states (new categorical
    variable)
  - Q2: year, country (new variable derived from NOC), continent (new
    categorical variable), the proportion of female athletes per year
    and later by continent (new), types of medals, seasons

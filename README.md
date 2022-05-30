Project 2 – Measuring Fluctuation in Professional Tennis
================
Peewee Marten (Anshuman Pal, Konrat Pekkip, Ryan Mazur)

## Introduction

In this data visualization project, we are interested in gaining a
better understanding of trends and fluctuations in professional Tennis
over the years. To accomplish this, we built a shiny application that
allows users to analyze ATP (men’s) and WTA (women’s) data for the past
several decades. In the first tab on the shiny app, users can explore
how the fluctuation in Tennis rankings has changed over the years for
ATP and WTA players. In the second tab, we provide users with the
opportunity to also assess short-term fluctuations of Tennis players,
measured by the rate of service breaks per set. We hope to shed some
light on Tennis players’ performances, and how they differ by gender.

This is our contribution to the long-standing debate about performance
discrepancies between men and women athletes. There was a parallel
debate in the professional tennis world for a long time about whether
men and women tennis players should get equal prize money. For example,
it was only in 2007 that Wimbledon started offering equal money to men
and women
[(source)](https://www.espn.com/tennis/story/_/id/24599816/us-open-follow-money-how-pay-gap-grand-slam-tennis-closed).

One of the issues at hand in this debate is whether men and women
athletes perform equally well. There are few objective ways of doing so.
Measuring the most evident markers of performance, like race times in
athletics and swimming, or number of points played and/or won in a
tennis match, is not a very fruitful approach, since men and women are
naturally built differently and have different physical abilities. So we
thought of a tracking not the average performance (viz. a first-order
variable), but fluctuations in the performance (viz., a second-order
variable).

## Data

The data we’re using comes from Jeff Sackmann’s GitHub page. In the
[data folder](../data), there are two folders, one containing the data
for the [men’s ATP](../data/atp), and one containing the data for the
[women’s WTA](data/wta). Both folders contain separate .csv files for
matches (by year, starting in 1968/1980 for ATP and WTA, respectively)
and rankings (by decade, starting in the 1970s/1980s for ATP and WTA,
respectively). To learn more about the variables contained in the data
as well as the contributors to the dataset, please refer to the README
files. You can find the README file for the ATP data
[here](../data/atp/README.md), and the README file for the WTA data
[here](../data/wta/README.md).

## Question 1

### Overview

Do (long-term) fluctuations in rankings differ significantly between men
and women?

To address this, we made a scatterplot with time on the x-axis, and the
fluctuation on the y-axis, with the color aesthetic mapping gender onto
the graphic. We also added line indicating the average of the
fluctuation over time, and users of the app can select different time
slices and number of ranks to include to customize the visualization.

### Findings

We can see that quite consistently, regardless of how many ranks we
include in the analysis, the fluctuation in rankings differs more for
the ATP (men’s) division than the WTA (women’s) division. This might
indicate a difference in competitiveness of the two divisions, as one
could conclude that there is a greater amount of highly-skilled players
vying for the top ranks in the ATP than the WTA, and that ATP players
are closer to one another when it comes to skill level than players in
the WTA. Anecdotal evidence – e.g. Serena Williams’ domination of female
Tennis for many years as opposed to multiple male players winning
important tournaments on a regular basis – may support this claim,
though an analysis of other measures would be crucial before drawing
final conclusions.

Another interesting finding is that the fluctuation in rankings
increases as one includes more ranks in the analysis, indicating that
there is a higher fluctuation in the lower ranks, and that relative to
lower-ranked players, higher-ranked players experience less fluctuation
in their rank. Perhaps once players reach a certain level, outside
factors such as sponsoring, equipment, or training facilities might all
contribute to a cementing of a given player in the top, while
lower-ranked players may not be able to assert their dominance over even
lower-ranked players as easily.

## Question 2

### Overview

Do (short-term) fluctuations in matches (measured by tracking average
number of service breaks per match) differ significantly between men and
women?

Again, the plot showcases time on the x-axis, and the average number of
service breaks per match on the y-axis. Users can customize the plot by
selecting different surfaces (e.g. clay, grass, etc.).

### Findings

The second question pertains to short-term fluctuations in performance
among female and male players. No matter the surface of the field, there
are less service breaks in male Tennis matches than female ones. This
indicates that once in the lead, a male Tennis player is more likely to
maintain this lead than a female one. One could conclude that female
Tennis matches are more interesting to watch, as there is less certainty
as to who takes away the win in the end. In any year since the data has
been recorded, service breaks occur in WTA matches at a rate of at least
two breaks per set, while observations for male players cluster around
1.5 breaks per set. Interestingly, also, the rate of service breaks per
match has decreased over time for ATP players, while it has stayed more
constant for WTA players.

## Final Takeaways

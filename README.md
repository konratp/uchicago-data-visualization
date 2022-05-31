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

### Long-term analysis: Do fluctuations in rankings differ significantly between men and women?

### **Methods
As a measure of long-term fluctuations, we measured the standard deviation (SD) in player rankings over some time period.

We made a scatterplot with time on the x-axis, and the
fluctuation on the y-axis, with the color aesthetic mapping gender onto
the graphic. We also added line indicating the average of the
fluctuation over time. For better data visualisation and analysis, we enable app users to select two parameters: 
1. The time window (in years) over which the data is averaged, since this can have an effect on the statistics.
2. The top-R ranking spots, to be able to explore different different 'regions' of ranking space.

### **Findings
Our method allows us to see how much movement or churning there is in the rankings. Our findings depend starkly on the value of R.

At the very top of the rankings (R<=10), we find that the women's tour (WTA) has more fluctuations, by roughly 10-20% depending on the time window chosen. 
In other words, there is comparatively (lot) more movement among the top 10 players in the women’s game; players are dropping in and out regularly.
In contrast, the list of top 10 players on the men’s tour (ATP) is more stable.  

However, outside the top 10 (e.g., choosing R>=20), we find that ranking fluctuations on the men's tour (ATP) are slightly higher 
(by ~2-5% depending on the time window chosen).  

While an effect of ~2-5% is not that significant, the ~10-20% difference between ATP and WTA in the top 10 of the rankings warrants some explanation. 
If we understand higher ranking fluctuations to mean the presence of equally-skilled players and more competition, then our findings imply
that the women's tour has more players of equal capability in the top 10, with few players standing out. Comparatively, the men's tour 
generally has some players that stand out at the very top. In terms of probability distributions, the men's tour has a 'fat tail', 
leading to the simultaneous presence of multiple exceptional players that stand out from the rest. Anecdotal evidence: Over the past decade (the 2010s), 
the women's game has been dominated by one player: Serena Williams. In comparison, the men's tour has been dominated by
three players: Roger Federer, Rafael Nadal and Novak Djokovic.  

However, further analysis is needed before drawing final conclusions.

## Question 2
### Short-term analysis: Do fluctuations during matches (measured by tracking frequency of service breaks in a match) differ significantly between men and women?

### **Methods  

As a proxy for short-term fluctuations -- i.e. fluctuations at the time scale of a match -- we count the average number of service breaks per set. 
The assumption here is that getting to serve is an advantage in tennis. Thus, *holding one's serve is a marker of playing with consistency*.
Therefore, counting the number of breaks of serve in a match is a proxy for the 'net playing inconsistency' in the match.

To plot the data, we again made a scatterplot with time on the x-axis, and the average number
of service breaks per set -- a tennis match can have 3 or 5 sets -- on the y-axis. The color aesthetic again
maps gender onto the scatterplot, with blue dots indicating WTA values,
and red indicating ATP values. Users can customize the plot by selecting
different surfaces (e.g. clay, grass, etc.).

### **Findings

The results for the second question, again, seem quite clearly separated
by gender. No matter the surface of the field, there are less service
breaks in male tennis matches than female ones. This clearly indicates
the men hold their serve more consistently than women, by a ratio of
roughly 70%. However, this what we can infer from this is not evident.
The only clear inference is that women are less stronger than serving
than men, which could easily be attributed to differences in base
physique and genetic makeup. To infer from this than women are less
‘consistent’ than men during a match is still a tenuous claim. It
requires a further step in logic, and needs to be backed up with more
analysis.

One could conclude that female tennis matches are more interesting to
watch, as there is less certainty as to who takes away the win in the
end. In any year since the data has been recorded, service breaks occur
in WTA matches at a rate of at least two breaks per set, while
observations for male players cluster around 1.5 breaks per set.
Interestingly, also, the rate of service breaks per match has decreased
over time for ATP players, while it has stayed more constant for WTA
players.

Interestingly, we also see that the rate of service breaks per match has
decreased over time for both WTA and ATP players. This might indicate
that both men and women are gradually learning to take better advantage
of their service games. The trend is more noticeable for ATP since their
data extends further back into the past (1991 vs. 2003 for women).

## Final Takeaways

While it is hard to draw crystal-clear conclusions about performance
discrepancies betweeen men and women in professional tennis, we can
firmly state that differences between players of the two sexes do exist.
Of course, a major limitation to our study is that there is little
evidence that short-term or long-term fluctuation are meaningfully
related to performance in any sport; however, the fact that these
differences exist suggests these things are not meaningless. 

We hope that users of our Shiny application enjoy the process of customizing the
visualizations and exploring how trends change over time and under
different parameters, and we encourage users to come to their own
conclusions about what to make of this data.

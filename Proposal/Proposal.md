Data Visualization Project 2 Proposal
================
Peewee Marten (Anshuman Pal, Konrat Pekkip)

-   [Comparing Fluctuations in Performances among Men and Women in
    Professional
    Tennis](#comparing-fluctuations-in-performances-among-men-and-women-in-professional-tennis)
    -   [Goals](#goals)
    -   [Plan of Attack](#plan-of-attack)
    -   [Repository Organization](#repository-organization)

# Comparing Fluctuations in Performances among Men and Women in Professional Tennis

In this data visualization project, we are interested in gaining a
better understanding of trends and fluctuations in professional Tennis
over the years. To accomplish this, we plan on building a shiny app that
lets users interactively explore the statistics and historical
trajectories of professional Tennis.

## Goals

While neither Anshuman nor Konrat are particularly talented Tennis
players, we are intrigued by the sport and the extensive data collection
that followers and organizers of professional Tennis events have engaged
in the last century. There is a vast amount of data available on ATP and
WTA tournaments which we seek to make accessible by building a shiny app
that lets users explore different dynamics underlying the data.

### Data

The data we’re using comes from Jeff Sackmann’s GitHub page. In the
[data folder](data), there are two folders, one containing the data for
the [men’s ATP](data/atp), and one containing the data for the [women’s
WTA](data/wta). Both folders contain separate .csv files for matches (by
year, starting in 1968/1980 for ATP and WTA, respectively) and rankings
(by decade, starting in the 1970s/1980s for ATP and WTA, respectively).
To learn more about the variables contained in the data as well as the
contributors to the dataset, please refer to the README files. You can
find the README file for the ATP data [here](data/atp/README.md), and
the README file for the WTA data [here](data/wta/README.md).

### Research Question(s)

Question 1: Does the (long-term) fluctuation in rankings differ
significantly between men and women?

Question 2: Does the (short-term) fluctuation in matches (measured by
tracking average number of service breaks per match in a season) differ
significantly between men and women?

The first question concerns long-term fluctuation in professional
Tennis. A lot of Tennis players experience highs and lows, and very few
constantly remain successul at the same level throughout their career.
Based on our perception of the sport, we believe that such long-term
fluctuation might be more pronounced in women’s Tennis than men’s
Tennis.

The second question concerns short-term fluctuations. By measuring the
average number of service breaks per match in a season, we hope to see
if there are significant differences in how men and women perform within
given matches.

For both of these questions, we want to restrict our analysis to matches
played since the year 2000, and focus on players who at some point
entered the top-20 of their respective rankings.

## Plan of Attack

Week 1 (beginning May 2nd): Meet to brainstorm topics and potential
visualization strategies.

Week 2: (beginning May 9th): Finalize the proposal and begin peer-review
process.

Week 3: (beginning May 16th): Finalize peer-review process and
incorporate peer-review edits into the project.

Week 4: (beginning May 23rd): Do the bulk of the coding work and
finalize the write-up.

Week 5: (beginning May 30th): Finalize the coding work and the
presentation.

## Repository Organization

As it stands now, this repository contains several files and folders.
This proposal exists in the [Proposal folder](Proposal), and our data,
alongside more detailed information on the datasets, can be found in the
[data folder](data). Eventually, the [Presentation folder](Presentation)
will contain our presentation, while the [README file](README.md) in the
main repository will contain the write-up of our results. Furthermore,
depending on whether or not we will go through with the plan to build a
shiny app, we might create another folder to store .Rmd files and R
scripts relevant for our analysis.

The final organization of your project repository. This means describing
the project organization in your proposal as well as implementing that
organization in your repo. Create any folders needed and place a
README.md in each folder explaining what goes in there.

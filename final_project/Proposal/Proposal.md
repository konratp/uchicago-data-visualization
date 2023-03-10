Data Visualization Project 2 Proposal
================
Peewee Marten (Anshuman Pal, Konrat Pekkip, Ryan Mazur)

-   [Comparing Fluctuations in Performances among Men and Women in
    Professional
    Tennis](#comparing-fluctuations-in-performances-among-men-and-women-in-professional-tennis)
    -   [Introduction](#introduction)
    -   [Goal and Motivation](#goal-and-motivation)
    -   [Data](#data)
    -   [Research Questions](#research-questions)
    -   [Shiny App](#shiny-app)
    -   [Plan of Attack](#plan-of-attack)
    -   [Repository Organization](#repository-organization)

# Comparing Fluctuations in Performances among Men and Women in Professional Tennis

-   Table of Contents
    -   [Introduction](#introduction)
    -   [Goal and Motivation](#goal-and-motivation)
    -   [Data](#data)
    -   [Research Questions](#research-questions)
    -   [Shiny App](#shiny-app)
    -   [Plan of Attach](#plan-of-attack)
    -   [Repository Organization](#repository-organization)

------------------------------------------------------------------------

## Introduction

In this data visualization project, we are interested in gaining a
better understanding of trends and fluctuations in professional Tennis
over the years. To accomplish this, we will analyse from the ATP (men)
and WTA (women) tours for the past several decades. Furthermore, we plan
on building a shiny app that lets users interactively explore the
evolution of these tennis statistics with time.

------------------------------------------------------------------------

## Goal and Motivation

The goal is to measure both long-term and short-term consistency in
performance among professional men and women tennis players, playing on
the ATP and WTA tours resp. To measure consistency, we will measure
fluctuations – a statistically well-defined quantity – since less
fluctuation means more consistency. Why do we study this?

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

For this, we will tap into the vast amount of data available on ATP and
WTA tournaments. We will measure both long-term fluctuations and
short-term fluctuations (see details below). We also seek to make this
analysis accessible by building a shiny app that lets users explore
different dynamics underlying the data.

------------------------------------------------------------------------

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

------------------------------------------------------------------------

## Research Questions

**Question 1**: Do (long-term) fluctuations in rankings differ
significantly between men and women?

To address this, we will make a plot with time on the x-axis, and the
fluctuation on the y-axis, one line for women and another for women. So
it will show the time evolution of the fluctuations. The exact details
will be determined later.

**Question 2:** Do (short-term) fluctuations in matches (measured by
tracking average number of service breaks per match) differ
significantly between men and women?

Again, the plot will have time on the x-axis, and the fluctuation on the
y-axis. Match data allows for access to more variables/dimensions. Thus,
we could consider additional faceting over, say, match surface (clay,
grass or hard courts).

**Details:** The first question concerns long-term fluctuation in
professional Tennis. A lot of Tennis players experience highs and lows,
and very few constantly remain successul at the same level throughout
their career. Based on our perception of the sport, we believe that such
long-term fluctuation might be more pronounced in women’s Tennis than
men’s Tennis.

The second question concerns short-term fluctuations. By measuring the
average number of service breaks per match in a season, we hope to see
if there are significant differences in how men and women perform within
given matches.

For both of these questions, we want to restrict our analysis to the
period between 1980 and today, and focus on players who at some point
entered the top-20 or top-50 of their respective rankings.

------------------------------------------------------------------------

## Shiny App

The Shiny app will be where users can view and interact with the data
and plots generated to answer our research questions. The structure of
the app wil be comprised of two tabs; one for each research question.
Within each tab, there will be a plot displaying the underlying data
along with a series of controls for the user to interact with in order
to change the paramters for each plot. While not finalized, we
anticipate that these will consist of the ability to change the time
window, filter for certain ranges of ranks among the players, and filter
for the type of court (clay, grass, hard) that matches were played on.

------------------------------------------------------------------------

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

------------------------------------------------------------------------

## Repository Organization

As it stands now, this repository contains several files and folders.
This proposal exists in the [Proposal folder](.), and our data,
alongside more detailed information on the datasets, can be found in the
[data folder](../data). Eventually, the [Presentation
folder](../Presentation) will contain our presentation, while the
[README file](../README.md) in the main repository will contain the
write-up of our results. Furthermore, all files related to the cleaning
and processing of the source data will be in
[Data-Processing](../Data-Processing) and the shiny app source code will
be in [App](../App).

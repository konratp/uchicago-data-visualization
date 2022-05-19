# homework-04

For any exercise where you're writing code, insert a code chunk and make
sure to label the chunk. Use a short and informative label. For any
exercise where you're creating a plot, make sure to label all axes,
legends, etc. and give it an informative title. For any exercise where
you're including a description and/or interpretation, use full
sentences. Make a commit at least after finishing each exercise, or
better yet, more frequently. Push your work regularly to GitHub. Once
you're done, inspect your GitHub repo to make sure it has all the
components you want to submit in the `homework-04.md` file, including the
prose, the code, and all plots.

------------------------------------------------------------------------

For this set of exercises, we are going to use the
[`babynames`](http://hadley.github.io/babynames/) dataset. The original
package has not been updated since 2017. The `data` folder contains four files
that follow the exact same structure as `babynames::babynames` and includes
births through 2020 courtesy of [Frank Kovacs](https://github.com/hadley/babynames/pull/37).

- `babynames`: For each year from 1880 to 2020, the number of children of 
  each sex given each name. All names with more than 5 uses are given.
  (Source: http://www.ssa.gov/oact/babynames/limits.html)

- `applicants`: The number of applicants for social security numbers (SSN) for
  each year for each sex. 
  (Source: http://www.ssa.gov/oact/babynames/numberUSbirths.html)

- `lifetables`: Cohort life tables data
  (Source: http://www.ssa.gov/oact/NOTES/as120/LifeTables_Body.html)

It also includes the following data set from the US Census:

- `births`: Number of live births by year, up to 2020.
  (Source: an Excel spreadsheet from the Census that has since been removed
  from their website and https://www.cdc.gov/nchs/data/nvsr/nvsr66/nvsr66_01.pdf. 
  Data for 2017-2020 obtained from https://www.cdc.gov/nchs/data/nvsr/nvsr68/nvsr68_13-508.pdf, 
  https://www.cdc.gov/nchs/data/nvsr/nvsr70/nvsr70-02-508.pdf and
  https://www.cdc.gov/nchs/data/nvsr/nvsr70/nvsr70-17.pdf.)
  
You may need to use multiple files, but the most important one is `babynames.csv`.

1. **How popular am I?** Create a static visualization that shows the popularity of your name over time.
    
- Use a line graph visualizing the number of live births annually.
- Make it look pretty - leverage all your skills thus far from this class
- Include the name in the title of the graph. Use `ggtext` to change the formatting
  of your name from the rest of the plot.
- If your name does not appear in the `babynames` database, feel free to
  pick a different name.

For example, it might look something like this:

<img src="images/benjamin-1.png" width="90%" />

2. **The app.** Construct an interactive Shiny application that allows users to visualize
   the popularity of names over time. It should include at least two separate
   visualizations and at least one reactive element.
   
-   The code of the app should go in the `app1` folder.
-   The link to the deployed app should be included in your R Markdown
    folder.
-   If you have a custom dataset you've created and placed in the `data` folder
    in the root of your project/repo, move that data file into the
    `app1/data` folder. You need everything needed to run the app in the
    `app1` folder for deployment. This creates multiple copies of the
    data in your repo, but that's okay.
-   Note: You've learned about Shiny in class, but we haven't covered
    deployment, so completing this question will require a bit of
    self-learning. See [this article on
    deployment](https://shiny.rstudio.com/articles/shinyapps.html) for
    instructions) for instructions for deployment to shinyapps.io, and
    ask questions if you need further guidance!

3.  **The styled app.** Change the look of your app using the theming
    features (aka [`shinythemes`](https://rstudio.github.io/shinythemes/))
    and the auto-theming option offered by the
    [`thematic`](https://rstudio.github.io/thematic) package. This will
    allow the look of your app to match the look of your visualization.
    Deploy the app to Shinyapps.io.

-   The code of the app should go in the `app2` folder.
-   The link to the deployed app should be included in your R Markdown
    folder.
-   Note: You've learned about Shiny in class, but we haven't covered
    the `thematic` package and auto theming. See [this article on auto
    theming](https://rstudio.github.io/thematic/articles/auto.html) for
    instructions on how to use auto theming in a Shiny app, and ask
    questions if you need further guidance!
   
   
   
   
   
   
   
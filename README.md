# homework-03

For any exercise where you’re writing code, insert a code chunk and make
sure to label the chunk. Use a short and informative label. For any
exercise where you’re creating a plot, make sure to label all axes,
legends, etc. and give it an informative title. For any exercise where
you’re including a description and/or interpretation, use full
sentences. Make a commit at least after finishing each exercise, or
better yet, more frequently. Push your work regularly to GitHub. Once
you’re done, inspect your GitHub repo to make sure it has all the
components you want to submit in the `homework-03.md` file, including the
prose, the code, and all plots.

1.  **Adopt, don’t shop.** The data for this exercise comes from [The
    Pudding](https://github.com/the-pudding/data/blob/master/dog-shelters/README.md)
    via
    [TidyTuesday](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-12-17).

    -   Load the `dog_travel` dataset included in the `data` folder of
        your repository with `read_csv()`.

    -   Make a histogram of the number of dogs available to adopt and
        describe the distribution of this variable.

    -   Calculate the number of dogs available to adopt per
        `contact_state`. Save the result as a new data frame with
        variables `contact_state` and `n`.

    -   Use this dataset to make a map of the US states, where each
        state is filled in with a color based on the number of dogs
        available to adopt in that state.
        
        *Hints:*

        -   Use the `state_list` dataset which you can find in the
            `data` folder of your repo as a lookup table to match state
            names to abbreviations.
        -   Use a gradient color scale and `log10` transformation.

    -   Interpret the visualization.

2.  **Country populations.** For this exercise you will work with data
    on country populations. The data come from [The World
    Bank](https://data.worldbank.org/indicator/SP.POP.TOTL). The dataset
    you will use is in your `data/` folder and it’s called
    `country-pop.csv`.

    -   Load the two dataset using `read_csv()`.

    -   Find the countries with the top 10 highest population count
        in 2020. Subset the data for just these 10 counries.

    -   Create a racing bar chart, using **gganimate** for the change in
        population for these countries.

3.  **Battle of the newspapers.** For this exercise you will work with
    data on headlines from The Chicago Sun-Times and The Baltimore Sun.
    The data come from the publication titled "A method for measuring
    investigative journalism in local newspapers" ([Turkel et al.,
    2021](https://www.pnas.org/content/118/30/e2105155118)).
    Specifically, I grabbed the data from for these two newspapers from
    the Harvard DataVerse
    [here](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HSZ2QL)
    and filtered them for 2019 headlines for your use. The relevant
    files can be found in the `data/` folder, and are titled
    `chicago_sun_times_2019.csv` and `baltimore_sun_2019.csv`.

    -   Load the two dataset using `read_csv()`.

    -   Omitting stop words, find the 20 most common words in headlines
        (`title`) for the two newspapers. Save the resulting tibbles as
        two separate objects and print out the contents of the tibbles
        (including all 20 rows). Provide an interpretation for how the
        common words across the two newspaper headlines are similar or
        different in terms of focus.

    -   Using the tibble objects you saved in the previous step, create
        bar charts showing the top 20 most common words and their counts
        for each of the newspapers. Use different colors for the bars
        for the two newspapers (and stick to these colors for the
        remainder of this exercise). Place the two visualizations
        side-by-side using functionality from the [`patchwork`](https://patchwork.data-imaginist.com/) package.

    -   Go back to the original datasets you loaded in the first step,
        and row-bind them. Recreate the barplots (and their layout)
        based on this combined dataset, this time using faceting instead
        of `patchwork`.

4.  **Brexit.** In September 2019, [YouGov
    survey](https://d25d2506sfb94s.cloudfront.net/cumulus_uploads/document/x0msmggx08/YouGov%20-%20Brexit%20and%202019%20election.pdf)
    asked 1,639 Great Britain adults the following question:

    > How well or badly do you think the government are doing at handling
    > Britain’s exit from the European Union?
    >
    > -   Very well
    > -   Fairly well
    > -   Fairly badly
    > -   Very badly
    > -   Don’t know
    
    The dataset containing responses to this question can be found in the
    `data/` folder and is called `brexit.csv`. Load the two dataset using
    `read_csv()` and create the following visualization. Your task is to
    recreate the following visualization, and to add a caption describing
    what each plot represents (Plots A, B, and C). Some hints to help you
    along the way:
    
    -   Before you get started, filter out the "Don’t know" responses.
    -   Use a diverging color scale from the `colorspace` package.
    -   Use `patchwork` along with its `plot_annotation()` functionality
        to label plots.
    -   "Collect" the legends (guides).
    -   For ease of copy-paste, the shortlink in the caption is
        `bit.ly/2lCJZVg`.
    
    <img src="images/brexit-1.png" width="90%" />

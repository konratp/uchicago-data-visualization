# Data

## Broad Description

The dataset we’re analyzing is available on kaggle and contains historical data on the modern Olympic game including all games starting from Athens 1896 till 2016. This data was scraped from [www.sports-reference.com](www.sports-reference.com) in 2018 and wrangled by rgriffin. Until 1992, winter and summer games used to be held in the same year. Since 1992, both summer and winter games have been taking place in a 4-year cycle (an olympiad!), resulting in winter games in 1994, summer in 1996, then again winter in 1998, and so on. The data set contains rich information on worldwide participation in Olympic Games across the years. 

We choose it because we're interested in the Olympics, and we believe that first we can show political and historical trends influencing countries' performances. Second, we narrow down to the angle of gender issues to find out female participation and performance over the years and across countries.

This data contains 271,116 observations and 15 variables. Each row contains data on an individual athlete participating in an individual Olympic event.To give a broad view, our data include information on 66 different sports, 1,184 different teams, 51 games, 230 different NOCs, 42 different host cities across 35 different years. 222,552 of the athletes participated in the summer games, while 48,564 participated in the winter season.

In our data set, 72.5 percent of the participants are male whereas the rest are female if we exclude missing values. The average age of the athletes is 25.6 years, with the oldest athlete being 97 years old, and the youngest being 10 years old. The average athlete height is 175.4cm, the maximum height is 226cm, and the minimum height is 127 cm. The average weight of an athlete is 70.7 kilograms, with the maximum being 214kg and the minimum being 25kg.

## Codebook

|variable         |description |
|:----------------|:-----------|
|id               | A unique number for each athlete |
|name             | Name of the athlete |
|sex              | M or F, M for male, F for Female |
|age              | An integer showing the age of athlete in years |
|height           | Height of athlete in centimeters |
|weight           | Weight of athlete in kilograms |
|team             | Team name (note that this is not necessarily the country name) |
|noc              | 3-letter country code for each National Olympic Committee (NOC) |
|games            | Year and season in which the game occurs |
|year             | An integer showing the year in which the event takes place |
|season           | Summer or Winter |
|city             | Name of the hosting city |
|sport            | Name of the sport played |
|event            | Name of the particular athletic event |
|medal            | Gold, Silver, Bronze, or NA |

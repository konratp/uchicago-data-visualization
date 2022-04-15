# Data

## Broad Description

The dataset we’re analyzing is available on kaggle and  contains historical data on the modern Olympic game and includes all games starting from Athens 1896 till 2016. This data was scraped from [www.sports-reference.com](www.sports-reference.com) in 2018 and wrangled by rgriffin. Until 1992, winter and summer games used to be held in the same year. Since 1992, both summer and winter games have been taking place in a 4-year cycle (an olympiad!), resulting in winter games in 1994, summer in 1996, then again winter in 1998, and so on. The data set contains rich information on worldwide participation in Olympic Games across yeas. We chose it because we're interested in the Olympics, and we believe we can show political and historical trends influencing countries' performances and contributions to hosting the Games.

This data contains 271,116 observations and 15 variables. Each row contains data on an individual athlete participating in an individual Olympic event. There is data on 66 different sports, 1184 different teams, 51 games, 230 different NOCs, 42 different host cities across 35 different years. The variables are included in the codebook in the `readme` file in the data folder in this repository.

In our data set, 72.5 percent of the participants are male whereas the rest are female if we exclude missing values. The average age of the athletes is 25.6 years, with the oldest athlete being 97 years old, and the youngest being 10 years old. The average athlete height is 175.4cm, the maximum height is 226cm, and the minimum height is 127 cm. The average weight of an athlete is 70.7 kilograms, with the maximum being 214kg and the minimum being 25kg. 222,552 of the athletes participated in the summer games, while 222,552 participated in the winter season.

## Codebook

|variable         |description |
|:----------------|:-----------|
|ID               | A unique number for each athlete |
|Name             | Name of the athlete |
|Sex              | M or F, M for male, F for Female |
|Age              | An integer showing the age of athlete in years |
|Height           | Height of athlete in centimeters |
|Weight           | Weight of athlete in kilograms |
|Team             | Team name (note that this is not necessarily the country name) |
|NOC              | 3-letter country code for each National Olympic Committee (NOC) |
|Games            | Year and season in which the game occurs |
|Year             | An integer showing the year in which the event takes place |
|Season           | Summer or Winter |
|City             | Name of the hosting city |
|Sport            | Name of the sport played |
|Event            | Name of the particular athletic event |
|Medal            | Gold, Silver, Bronze, or NA |

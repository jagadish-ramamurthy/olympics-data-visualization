# 120 years of Olympics Games Data Visualization
The visualization depicted is a type of Explanatory Visualization which conveys information on the evolution of Olympic Games and number of countries participating in sports over the 120-year period. A total of five charts are used to visualize and explain the history of the Olympic Games. These five charts can be interacted with using a slider to slide over the years the Olympic Games was held. Additional information is provided over mouse button clicks and hovering.

The 120 years of Olympic Games history (from the start to the recent 2016 Games) is visualized using R Shiny package in RStudio. The visualization provides an overview on the Olympic Games held for the individual year such as the host city, the number of countries that won at least one medal, the number of sports held, etc. The visualization provides a breakdown of the countries medal count into either Gold, Silver, or Bronze, and a further breakdown into each of the medals listing the different sports that won the medals, and finally, an overall performance of the country in Olympics.

#### Datasets
The dataset for the visualization was taken from Kaggle [1] database of datasets. The dataset contains approximately three hundred thousand rows with a total of 15 columns. Each row represents an athlete competing in an Olympic event. The important columns in the dataset include Name, Sex, NOC (National Olympic Committee Code), Year, Season, City, Sport, Medal.

Apart from the above-mentioned dataset, an additional dataset had to be downloaded to represent the countries on hovering over them. These datasets were downloaded from Natural Earth [2], a public domain to construct custom maps.

#### References
[1] [120 Years of Olympic History](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results)  
[2] [Natural Earth dataset](https://www.naturalearthdata.com/downloads/50m-cultural-vectors/)

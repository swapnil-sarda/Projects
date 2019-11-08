# Projects

### [Thesis project - Frequent pattern finding and visual analytics]
Tools used: R and JavaScript

Description:
This project is inspired by the limitation of in-game statistics only table which provides a very basic overview of the player summary. 
Created a custom visualisation which shows more information on how a player plays the game.

Data is collected using popular massive multiplayer online game PUBG's API (Top 500 players) and also a Kaggle dataset which consists of >1 Million match details.

Implemented Boruta algorithm to find which factors affect the winning position (WinPlace == 1) in the dataset. Interpreted the result and modified the dataset by discarding columns which have no effect on winning the game.

Applied Apriori algorithm on the datasets to find hidden patterns of playing style of the participants. Applied 'Rule Power Factor'(RPF) evaluation method to assess the accuracy of the rules / patterns generated.

Selected the dataset with higher RPF. Interpreted the result with patterns having upto six different attributes.

#Custom Visualisation: 
This visualisation has 5 donuts and a circle, circling one another and decreasing in size from out to in. 

Darker the colour, highly frequent pattern (or set of patterns).

Lighter the colour, less frequent pattern.

The outermost circle shows the frequently occuring single attribute.
The inner circle immediate to the outermost one, shows frequently occuring two attributes. 
Similarly, a set of six frequent patterns can be seen in the visualisation.

Legend is placed to the left of the visualisation to ease the use.

Clicking on 'Subset 1' will only display visualisation which has one frequent pattern, while other are hidden.
Similarly other options will keep desired visual on the front hiding others.

The desired slice is rotated in front of the tooltip by clicking on it.

[Live demo of the visualisation on codepen](https://codepen.io/swapnil-sarda/pen/JjjvZwz)



### [Analysis of air quality index and prediction of PM2.5 pollutant level](https://github.com/swapnil-sarda/projects/tree/Machine-learning)

Tools used:	R, Python, Excel

Description: 
Researched air quality index for eight Tier-1 and Tier-2 Indian cities. Predicted the level of PM2.5 pollutants in the air for a period of seven days. Data mining method LSTM is used for this time series problem.
Data cleaning on the dataset to have consistent date format and handling of missing values using rolling mean is performed in R.
LSTM implementation including optimization of model is done using Python. Best performing model has RMSE 3.8 percent.


### [Data Warehouse](https://github.com/swapnil-sarda/projects/tree/Data-warehouse)

Tools used: R, MS SQL Server, Tableau and Visual Studio

Description:
Developed a data warehouse using Visual studio and Microsoft SQL Server. Flat files sources are automated to be downloaded from the internet at the time of deployment of data warehouse.
A database of tweets is generated using AWS EC2 instance and imported in R to perform sentiment analysis to find brand perception of with respect to electric cars offered by the respective brands.
BI queries visualised in Tableau.


### [Analytical CRM](https://github.com/swapnil-sarda/projects/tree/Analytical-CRM)

Tools used: Rstudio

Description:
Combined different datasets detailing college information.
Data preprocessing operations performed are, making college name variable consistent across different files and finding and removing outliers of number of students.
Implemented Chi square test by identifying two groups of variables which described college administration type and number of infrastructure facilities available.
Interpreted the outcome of the test by visualising the chi square matrix. Altered the dataset on this outcome.
Linear regression test performed to find correlation among variables.
From the output, deduced that there is positive correlation between number of students in a college and number of infrastructure facilities provided in rural areas in India.
Almost non existent correlation is found in Urban areas for the same set of variables as above.


### Data Visualisation

Tools used: R, Python, Tableau, PowerBI, Microsoft Excel and Infogram(online tool to create infographs).

Description: 
Made a report on car sales in Ireland which involved using various tools like R, Python, Tableau, PowerBI, Microsoft excel to choose appropriate visualisations.

Created an inforgraphic on the topic of 'Income of $100,000 in New York city' showing tax deductions percent, rent for studio apartments across all the boroughs, daily expenditures and monthly and yearly savings.

Documents present in the 'Files' section above.

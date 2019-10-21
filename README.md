## Project description

Predicted PM2.5 pollutant levels for 7 days, for 8 cities of India using Long short-term memory (LSTM) artificial recurrent neural network (RNN) architecture.

Data for this project is collected from National Air Quality Index website.

Data cleaning process done in R.

Machine learning model implementation done in Python.

The output is evaluated using the RMSE parameter. 

The  lowest RMSE values achieved is 3.6% for our best performing model in which the missing values were replaced with rolling mean.

While performing EDA on the datasets, we observed that PM2.5 levels on an average, are higher in tier 2 cities then tier 1 with the exception of Pune(a tier 2 city).

The cities of Mumbai and Bangalore had lower PM2.5 levels despite housing higher population and many more vehicles.

Other observation is that the geographic locations of these cities are also unique (seaside and hillstation) which also affect the PM2.5 levels.

Tier 2 cities should perform source profiling to curtail the PM2.5 levels.


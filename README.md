# Predicting Air Pollution for 7 days, for 8 cities of India using Long short-term memory (LSTM) artificial recurrent neural network (RNN) architecture.

# Data for this project is collected from National Air Quality Index website.

# [Data cleaning process done in R.](https://github.com/swapnil-sarda/projects/blob/Machine-learning/R%20Code)

# Machine learning model implementation done in Python.

# Data cleaning process in R

===========================================================================

============================================================================================================================================

# Machine learning model implementation in Python

### Part 1 - Data Preprocessing

import numpy as np

import matplotlib.pyplot as plt

import pandas as pd

### Importing the training set

dataset_train = pd.read_csv('F:\\ADM\\LSTM\\City1.csv')

training_set = dataset_train.iloc[:, 2:3].values

### Feature Scaling

from sklearn.preprocessing import MinMaxScaler

sc = MinMaxScaler(feature_range = (0, 1))

training_set_scaled = sc.fit_transform(training_set)

### Creating a data structure with 60 timesteps and 1 output

X_train = []

y_train = []

for i in range(60, 574):
    X_train.append(training_set_scaled[i-60:i, 0])
    y_train.append(training_set_scaled[i, 0])

X_train, y_train = np.array(X_train), np.array(y_train)

### Reshaping
X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

### Part 2 - Building the RNN

### Importing the Keras libraries and packages

from keras.models import Sequential

from keras.layers import Dense

from keras.layers import LSTM

from keras.layers import Dropout

### Initialising the RNN

regressor = Sequential()

### Adding 4 LSTM layers and some Dropout regularisation at each step
regressor.add(LSTM(units = 70, return_sequences = True, input_shape = (X_train.shape[1], 1)))

regressor.add(Dropout(0.2))


regressor.add(LSTM(units = 70, return_sequences = True))

regressor.add(Dropout(0.2))


regressor.add(LSTM(units = 70, return_sequences = True))

regressor.add(Dropout(0.2))


regressor.add(LSTM(units = 70))

regressor.add(Dropout(0.2))

### Adding the output layer
regressor.add(Dense(units = 1))

### Compiling the RNN
regressor.compile(optimizer = 'adam', loss = 'mean_squared_error')

### Fitting the RNN to the Training set
regressor.fit(X_train, y_train, epochs = 40, batch_size = 15)


### Part 3 - Making the predictions and visualising the results

### Getting the real pollution data of last 7 days
dataset_test = pd.read_csv('F:\\ADM\\LSTM\\City2.csv')

real_data = dataset_test.iloc[:, 2:3].values

### Getting the predicted value of last week pollution 
dataset_total = pd.concat((dataset_train['Concentration'], dataset_test['CO']), axis = 0)

inputs = dataset_total[len(dataset_total) - len(dataset_test) - 60:].values

inputs = inputs.reshape(-1,1)

inputs = sc.transform(inputs)

X_test = []

for i in range(60, 67):
    X_test.append(inputs[i-60:i, 0])

X_test = np.array(X_test)

X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))

predictedValue = regressor.predict(X_test)

predictedValue = sc.inverse_transform(predictedValue)


### Visualising the results
plt.plot(real_data, color = 'red', label = 'Real Pollution Data')

plt.plot(predictedValue, color = 'blue', label = 'Predicted value')

plt.title('Delhi pollution PM2.5')

plt.xlabel('Time')  

plt.ylabel('PM2.5')

plt.legend()

plt.show()


### Calculating RMSE to check model accuracy

import math
from sklearn.metrics import mean_squared_error
rmse = math.sqrt(mean_squared_error(real_data, predictedValue))
 

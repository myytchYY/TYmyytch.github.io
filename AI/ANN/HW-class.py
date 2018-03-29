# -*- coding: utf-8 -*-
"""
Created on Sat Mar 17 20:49:54 2018

@author: tianc
"""
from sklearn import preprocessing
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import confusion_matrix
import numpy as np
from sklearn.model_selection import train_test_split
import pandas as pd

#"https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
data = pd.read_csv("D:/Grad2017/AI/ANN/winequality-white.csv",delimiter=";", header=0,
                   names = ['f_acidity', 'v_acidity', 'citric Acid', 'r_sugar', 'chlorides', 'free_so2',
                            'total_so2', 'density', 'pH', 'sulphates', 'alcohol', 'quality'])
data = data.dropna()
x_vars = ['f_acidity', 'v_acidity', 'citric Acid', 'r_sugar', 'chlorides', 'free_so2',
                            'total_so2', 'density', 'pH', 'sulphates', 'alcohol']
y_vars = ['quality']
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
x_data = data[x_vars]
y_data = data[y_vars]

np.random.seed(2018)

x_data_MinMax = preprocessing.MinMaxScaler()
x_data.as_matrix(x_data)
x_data = np.array(x_data).reshape((len(x_data), 11))
y_data.as_matrix(y_data)
y_data = np.array(y_data).reshape((len(y_data), 1))

y_avg = (sum(y_data)/len(y_data))[0]
new_y = []
for num in y_data:
    if num < 7:
        new_y.append("common quality")
    else:
        new_y.append("high quality")

x_data = x_data_MinMax.fit_transform(x_data)

x_train, x_test, y_train, y_test = train_test_split(x_data, new_y, test_size=0.33, random_state=2018)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
testScore = []
learningRate = np.arange(0.1,0.5,0.05)
for i in learningRate:
    mlp = MLPClassifier(hidden_layer_sizes=(50,), max_iter=10, alpha=1e-4,
                        solver='sgd', verbose=10, tol=1e-4, random_state=2018,
                        learning_rate_init=i)
    
    mlp.fit(x_train, y_train)
    testScore.append(mlp.score(x_test, y_test))
bestRate = learningRate[testScore.index(max(testScore))]

mlp = MLPClassifier(hidden_layer_sizes=(50,), max_iter=10, alpha=1e-4,
                        solver='sgd', verbose=10, tol=1e-4, random_state=2018,
                        learning_rate_init=bestRate)
mlp.fit(x_train, y_train)
y_pred=mlp.predict(x_test)
print("Best Learning rate init: ", bestRate)
print("Test Score is: ",mlp.score(x_test, y_test))
print(confusion_matrix(y_test, y_pred,labels=["common quality","high quality"]))


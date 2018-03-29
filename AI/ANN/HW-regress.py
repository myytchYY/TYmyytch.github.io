# -*- coding: utf-8 -*-
"""
Created on Tue Aug 23 13:04:49 2016

@author: Tianc
"""
from sklearn import preprocessing
from sklearn.model_selection import train_test_split
from sknn.mlp import Regressor, Layer
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_absolute_error
import numpy as np
import pandas as pd
import datetime

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
y_data_MinMax = preprocessing.MinMaxScaler()

x_data.as_matrix(x_data)
x_data = np.array(x_data).reshape((len(x_data), 11))
y_data.as_matrix(y_data)
y_data = np.array(y_data).reshape((len(y_data), 1))

x_data = x_data_MinMax.fit_transform(x_data)
y_data = y_data_MinMax.fit_transform(x_data)

x_train, x_test, y_train, y_test = train_test_split(x_data, y_data, test_size=0.33, random_state=2018)

f = open('activatorCombs.csv','w')
start_time = datetime.datetime.now()
f.write ('2nd Activator, 3rd Activator, 2nd Layer Units, 3rd Layer Units, Train ERROR MSE,Test ERROR MSE,Train ERROR MAE,Test ERROR MAE \n')
start_time = datetime.datetime.now()
li = ["Rectifier", "Sigmoid", "Tanh", "ExpLin"]
for a in li:
    for a2 in li:
        for L2 in range(2, 10,2):
            for L3 in range(4, 14, 2):
                fit = Regressor(layers=[
                        Layer(a, units=L2),Layer(a2, units=L3),Layer("Linear")],
                    learning_rate=0.02,random_state =2018, n_iter=100)
                print ("fitting model right now", a, a2)
                fit.fit(x_train,y_train)
                pred_train=fit.predict(x_train)
                pred_test=fit.predict(x_test)
                mse_1 = mean_squared_error(pred_train, y_train)
                mse_2 = mean_squared_error(pred_test,y_test)
                mae_1 = mean_absolute_error(pred_train, y_train)
                mae_2 = mean_absolute_error(pred_test, y_test)
                outstring= a+","+a2+","+str(L2)+","+str(L3)+","+str(mse_1)+","+str(mse_2)+","+str(mae_1)+","+str(mae_2)+"\n"
                f.write(outstring)
        
stop_time = datetime.datetime.now()
print ("Time required for optimization:",stop_time - start_time)

f.close()

# -*- coding: utf-8 -*-
"""
Created on Mon Jan 17 15:32:11 2022

@author: alejo
"""



import os 
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas
import math
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.stattools import acf
from statsmodels.tsa.seasonal import seasonal_decompose
from matplotlib import pyplot
from keras.models import Sequential
from keras.layers import Dense 
from keras.layers import LSTM
from keras.layers import Bidirectional
from keras.layers import Dropout
from keras.layers import Flatten
from keras.layers import ConvLSTM2D
from keras.layers import TimeDistributed
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error
from sklearn.svm import SVR



######################################## datos ################################
os.chdir('C:/Users/alejo/Desktop/Tesis/Datos')

datos = pd.ExcelFile('Tasas de ocupación y desempleo.xlsx').parse()
datos['Fecha']=pd.to_datetime(datos['Fecha'])


datos = datos.set_index('Fecha')
datos_ts = datos['Valor']



################################### exploratorio #############################

# desc_datos_ts = seasonal_decompose(datos_ts, model='additive')
# descomposicion_datos_ts=desc_datos_ts.plot()

dif_datos_ts=datos_ts.diff(periods=1)
dif2_datos_ts=dif_datos_ts.diff(periods=12)

# plt.plot(dif_datos_ts)
# plt.plot(dif2_datos_ts)

# plot_acf(datos_ts,adjusted=False,lags=120,title='ACF Demanda energetica')
# plot_acf(dif_datos_ts.dropna(),adjusted=False,lags=120,title='ACF Serie Demanda energetica Diferenciada')
# plot_acf(dif2_datos_ts.dropna(),adjusted=False,lags=120,title='ACF Serie Demanda energetica sin Tendencia y ciclo')
 
os.chdir('C:/Users/alejo/Desktop/Tesis/Imagenes documento/Metodologia/Tasa desempleo')
plt.plot(datos_ts)
plt.savefig("desempleo_ts.pdf")


################################## graficas ciclos ############################

f = plt.figure()

ax1 = f.add_subplot(321)
ax1.plot(datos_ts);ax1.set_title('Serie Orginal')

ax2 = f.add_subplot(322)
plot_acf(datos_ts,ax=ax2,adjusted=False,lags=60,title='ACF Serie Orginal')

ax3 = f.add_subplot(323)
ax3.plot(dif_datos_ts);ax3.set_title('Diferenciacion de 1st orden')

ax4 = f.add_subplot(324)
plot_acf(dif_datos_ts.dropna(),ax=ax4,adjusted=False,lags=60,title='ACF Diferenciacion 1st')

ax5 = f.add_subplot(325)
ax5.plot(dif2_datos_ts);ax5.set_title('Diferenciacion de 12st orden')

ax6 = f.add_subplot(326)
plot_acf(dif2_datos_ts.dropna(),ax=ax6,adjusted=False,lags=60,title='ACF Diferenciacion 1st y 12st')



f.savefig("desempleo_acf.pdf")



#################################### Modelo LSTM ##################################

######################### preparacion datos #########################

dataset = datos.values
scaler = MinMaxScaler(feature_range=(0, 1))
dataset = scaler.fit_transform(dataset)

train_n = int(len(dataset) * 0.8)
test_n = len(dataset) - train_n

def create_dataset(dataset, look_back):
	dataX, dataY = [], []
	for i in range(len(dataset)-look_back):
		a = dataset[i:(i+look_back), 0]
		dataX.append(a)
		dataY.append(dataset[(i + look_back), 0])
	return np.array(dataX), np.array(dataY)


look_back=12*2

train = dataset[0:train_n] 
test = dataset[-(test_n+look_back):]

trainX, trainY = create_dataset(train, look_back)
testX, testY = create_dataset(test, look_back)

trainX = np.reshape(trainX, (trainX.shape[0], 1, trainX.shape[1]))
testX = np.reshape(testX, (testX.shape[0], 1, testX.shape[1]))

######################### definicion modelo #########################

n_steps=1
neuronas=12*2
model = Sequential()
model.add(LSTM(neuronas, activation='relu',input_shape=(1, look_back)))
model.add(Dense(6))
model.add(Dense(1))
model.compile(loss='mean_squared_error', optimizer='adam')

######################### Ajuste modelo #########################
model.fit(trainX,trainY, epochs = 100,batch_size=10)


######################### Pronostico #########################

testPredict = model.predict(testX)
testPredict = scaler.inverse_transform(testPredict)


######################### Grafico #########################

# pred_LSTM = pd.Series(testPredict[:,0])
# actual = datos.tail(test_n)


# pred_LSTM.index = actual.index



# fig, ax = plt.subplots()
# ax.plot(actual, linewidth=2, color='black')
# ax.plot(pred_LSTM,linestyle="--")

# mse = mean_squared_error(actual, pred_LSTM)
# mse = math.sqrt(mse)
# mse = math.sqrt(mse)
# mse


#################################### Resultados ###############################

os.chdir('C:/Users/alejo/Desktop/Tesis/resultados')
pred_data = pd.read_csv("pred_desempleo")

n_pred = pred_data.shape[0]

real = datos.tail(n_pred)

fechas = real.index
actual = real.values
actual = pd.Series(actual[:,0])


pred_ETS = pred_data['ETS']
pred_ARIMA = pred_data['ARIMA']
pred_GAM = pred_data['GAM']
pred_SVR = pred_data['SVR']
pred_LSTM = pd.Series(testPredict[:,0])

pred_media = (pred_ETS+pred_ARIMA+pred_GAM+pred_SVR+pred_LSTM)/5



actual.index = fechas
pred_ETS.index = fechas
pred_ARIMA.index = fechas
pred_GAM.index = fechas
pred_SVR.index = fechas
pred_LSTM.index = fechas
pred_media.index = fechas

Score_ETS = math.sqrt(mean_squared_error(actual, pred_ETS))
Score_ARIMA = math.sqrt(mean_squared_error(actual, pred_ARIMA))
Score_GAM = math.sqrt(mean_squared_error(actual, pred_GAM))
Score_SVR = math.sqrt(mean_squared_error(actual, pred_SVR))
Score_LSTM = math.sqrt(mean_squared_error(actual, pred_LSTM))
Score_media = math.sqrt(mean_squared_error(actual, pred_media))

print(Score_ETS,Score_ARIMA,Score_GAM,Score_SVR,Score_LSTM,Score_media) 
score = [Score_ETS,Score_ARIMA,Score_GAM,Score_SVR,Score_LSTM,Score_media]
score = pd.DataFrame(score, columns=['desempleo'])
score.index = ['Score_ETS','Score_ARIMA','Score_GAM','Score_SVR','Score_LSTM','Score_media']

score.to_csv('score_desempleo')


#################################### Graficas #################################

fig, ax = plt.subplots()
ax.plot(actual, linewidth=2, color='black')
ax.plot(pred_ETS,linestyle='-') 
ax.plot(pred_ARIMA,linestyle='--')
ax.plot(pred_GAM ,linestyle='-.')
ax.plot(pred_SVR,linestyle=':')
ax.plot(pred_LSTM,linestyle='-')
ax.plot(pred_media,linestyle='--')
ax.legend(labels=['Real','ETS','ARIMA','GAM','SVR','LSTM','media'],loc='upper left',fontsize=16)




os.chdir('C:/Users/alejo/Desktop/Tesis/Imagenes documento/Metodologia/Tasa desempleo')
fig.savefig("desempleo_resul.pdf")

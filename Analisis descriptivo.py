# -*- coding: utf-8 -*-
"""
Created on Mon Nov 29 23:28:29 2021

@author: alejo
"""

import os 
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pylab as plt
from matplotlib.pylab import rcParams
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.stattools import acf
from statsmodels.graphics.tsaplots import plot_pacf
from statsmodels.tsa.stattools import pacf
from pandas.plotting import register_matplotlib_converters
import plotly.express as px
import plotly.graph_objects as go
import random 
import statsmodels.api as sm
import datetime as dt
from statsmodels.tsa.seasonal import seasonal_decompose
from matplotlib import pyplot

%matplotlib qt

os.chdir('C:/Users/alejo/Desktop/Tesis/Datos')


energetica = pd.ExcelFile('Demanda energetica nacional.xlsx').parse()
Carbon = pd.ExcelFile('Consumo Carbon.xlsx').parse()
Gas = pd.ExcelFile('Consumo Gas.xlsx').parse()
Temperatura = pd.ExcelFile('Temperatura media bogota .xlsx').parse()
Inflacion = pd.ExcelFile('Inflacion nacional.xlsx').parse()
desempleo = pd.ExcelFile('Tasas de ocupación y desempleo.xlsx').parse()
petroleo = pd.ExcelFile('ExpPetro.xlsx').parse()
tmr = pd.ExcelFile('Tasa representativa.xlsx').parse()

energetica['Fecha']=pd.to_datetime(energetica['Fecha'])
Carbon['Fecha']=pd.to_datetime(Carbon['Fecha'])
Gas['Fecha']=pd.to_datetime(Gas['Fecha'])
Temperatura['Fecha']=pd.to_datetime(Temperatura['Fecha'])
Inflacion['Fecha']=pd.to_datetime(Inflacion['Fecha'])
desempleo['Fecha']=pd.to_datetime(desempleo['Fecha'])
petroleo['Fecha']=pd.to_datetime(petroleo['Fecha'])
tmr['Fecha']=pd.to_datetime(tmr['Fecha'])


energetica  = energetica.set_index('Fecha')
Carbon = Carbon.set_index('Fecha')
Gas = Gas.set_index('Fecha')
Temperatura = Temperatura.set_index('Fecha')
Inflacion = Inflacion.set_index('Fecha')
desempleo = desempleo.set_index('Fecha')
petroleo = petroleo.set_index('Fecha')
tmr = tmr.set_index('Fecha')


energetica_ts = energetica['Valor']
Carbon_ts = Carbon['Valor']
Gas_ts = Gas['Valor']
Temperatura_ts = Temperatura['Valor']
Inflacion_ts = Inflacion['Valor']
desempleo_ts = desempleo['Valor']
petroleo_ts = petroleo['Valor']
tmr_ts = tmr['Valor']



f = plt.figure()

ax1 = f.add_subplot(421)
ax1.plot(energetica_ts);ax1.set_title('Demanda energetica')

ax2 = f.add_subplot(422)
ax2.plot(Carbon_ts);ax2.set_title('Consumo Carbon')

ax3 = f.add_subplot(423)
ax3.plot(Gas_ts);ax3.set_title('Consumo Gas')

ax4 = f.add_subplot(424)
ax4.plot(Temperatura_ts);ax4.set_title('Temperatura')

ax5 = f.add_subplot(425)
ax5.plot(Inflacion_ts);ax5.set_title('Inflacion Nacional')

ax6 = f.add_subplot(426)
ax6.plot(desempleo_ts);ax6.set_title('Tasa de desempleo')

ax7 = f.add_subplot(427)
ax7.plot(petroleo_ts);ax7.set_title('Exportaciones Petroleo')

ax8 = f.add_subplot(428)
ax8.plot(tmr_ts);ax8.set_title('TMR')


os.chdir('C:/Users/alejo/Desktop/Tesis/Imagenes documento')

f.savefig("petroleo_acf.pdf")


########################## CARBON ################################
CARBON = Carbon.set_index('Fecha')
CARBON_ts = CARBON['Carbon']
CARBON_ts = CARBON_ts.asfreq(freq="D")

desc_CARBON_ts = seasonal_decompose(CARBON_ts, model='additive')

%matplotlib qt
plt.plot(CARBON_ts)
desc_CARBON_ts.plot()

plot_acf(CARBON_ts,adjusted=False,lags=40,title='ACF Serie CARBON')



########################## GAS ################################
GAS = Gas.set_index('Fecha')
GAS_ts = GAS['Gas']
GAS_ts = GAS_ts.asfreq(freq="D")


desc_GAS_ts = seasonal_decompose(GAS_ts, model='additive')

%matplotlib qt
plt.plot(GAS_ts)
descomposicion_GAS_ts=desc_GAS_ts.plot()


########################## ENERGETICA ##############################
ENERGETICA = energetica.set_index('Fecha')
ENERGETICA_ts = ENERGETICA['Demanda Energia SIN']
ENERGETICA_ts = ENERGETICA_ts.asfreq(freq="D")


desc_ENERGETICA_ts = seasonal_decompose(ENERGETICA_ts, model='additive')

%matplotlib qt
plt.plot(ENERGETICA_ts)
descomposicion_ENERGETICA_ts=desc_ENERGETICA_ts.plot()


########################## PRECIPITACION ##############################
PRECIPITACION = Precipitacion.set_index('Fecha')
PRECIPITACION_ts = PRECIPITACION['Value']
PRECIPITACION_ts = PRECIPITACION_ts.asfreq(freq="MS")

desc_PRECIPITACION_ts = seasonal_decompose(PRECIPITACION_ts, model='additive')

%matplotlib qt
plt.plot(PRECIPITACION_ts)
descomposicion_PRECIPITACION_ts=desc_PRECIPITACION_ts.plot()


########################## TEMPERATURA ##############################
TEMPERATURA = Temperatura.set_index('Fecha')
TEMPERATURA_ts = TEMPERATURA['Value']
TEMPERATURA_ts = TEMPERATURA_ts.asfreq(freq="MS")

desc_TEMPERATURA_ts = seasonal_decompose(TEMPERATURA_ts, model='additive')

%matplotlib qt
plt.plot(TEMPERATURA_ts)
descomposicion_TEMPERATURA_ts=desc_TEMPERATURA_ts.plot()


########################## PIB ##############################
PIB = Producto.set_index('Fecha')
PIB_ts = PIB['PIB']


desc_PIB_ts = seasonal_decompose(PIB_ts, model='additive')

%matplotlib qt
plt.plot(PIB_ts)
descomposicion_PIB_ts=desc_PIB_ts.plot()


########################## INFLACION  ##############################
INFLACION = Inflacion.set_index('Fecha')
INFLACION_ts = INFLACION['Inflacion']
INFLACION_ts = INFLACION_ts.asfreq(freq="MS")

desc_INFLACION_ts = seasonal_decompose(INFLACION_ts, model='additive')

%matplotlib qt
plt.plot(INFLACION_ts)
descomposicion_CARBON_ts=desc_INFLACION_ts.plot()


########################## TRM ##############################
TRM = Tasa.set_index('Fecha')
TRM_ts = TRM['Tasa ']
TRM_ts = TRM_ts.asfreq(freq="D")

desc_TRM_ts = seasonal_decompose(TRM_ts, model='additive')

%matplotlib qt
plt.plot(TRM_ts)
descomposicion_TRM_ts=desc_TRM_ts.plot()



########################## DESEMPLEO ##############################
DESEMPLEO = Ocupacion.set_index('Fecha')
DESEMPLEO_ts = DESEMPLEO['desempleo']


desc_DESEMPLEO_ts = seasonal_decompose(DESEMPLEO_ts, model='additive')

%matplotlib qt
plt.plot(DESEMPLEO_ts)
descomposicion_DESEMPLEO_ts=desc_DESEMPLEO_ts.plot()


########################## CAFE ##############################
CAFE = Exportacion.set_index('Fecha')
CAFE_ts = CAFE['Cafe']
CAFE_ts = CAFE_ts.asfreq(freq="MS")


desc_CAFE_ts = seasonal_decompose(CAFE_ts, model='additive')

%matplotlib qt
plt.plot(CAFE_ts)
descomposicion_CAFE_ts=desc_CAFE_ts.plot()


########################## PETROLEO ##############################
PETROLEO = Exportacion.set_index('Fecha')
PETROLEO_ts = PETROLEO['Petroleo']
PETROLEO_ts = PETROLEO_ts.asfreq(freq="MS")


desc_PETROLEO_ts = seasonal_decompose(PETROLEO_ts, model='additive')

%matplotlib qt
plt.plot(PETROLEO_ts)
descomposicion_PETROLEO_ts=desc_PETROLEO_ts.plot()




############################## MODELAMIENTO################################

########################## CARBON ################################

CARBON_ts

%matplotlib qt
plot_acf(CARBON_ts,adjusted=False,lags=200,title='ACF Serie CARBON')

########################## GAS ################################
########################## PRECIPITACION ################################
########################## TEMPERATURA ################################
########################## INFLACION ################################
########################## TRM ################################
########################## CAFE ################################
########################## PETROLEO ########################################################## DESEMPLEO ################################







#df.groupby(df['date'].dt.strftime('%B'))['Revenue'].sum().sort_values()#

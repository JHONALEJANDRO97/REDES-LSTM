

######################### ......LIBRERIAS..... #########################

library(readxl)
library(forecast)
library(tseries)
library(zoo)
library(xgboost)
library(tidymodels)
library(modeltime)
library(tidyverse)
library(lubridate)
library(timetk)
library(e1071)

setwd("C:/Users/alejo/Desktop/Tesis/Datos")
getwd()




######################### IMPORTACION DE DATOS #########################

Carbon = read_excel('Consumo Carbon.xlsx')
Gas = read_excel('Consumo Gas.xlsx')
energetica = read_excel('Demanda energetica nacional.xlsx')
Precipitacion = read_excel('Precipitacion media bogota .xlsx')
Temperatura = read_excel('Temperatura media bogota .xlsx')
Producto = read_excel('Producto interno.xlsx')
Inflacion = read_excel('Inflacion nacional.xlsx')
Tasa = read_excel('Tasa representativa.xlsx')
Ocupacion = read_excel('Tasas de ocupación y desempleo.xlsx')
ExCafe = read_excel('ExpCafe.xlsx')
ExPetro = read_excel('ExpPetro.xlsx')


Carbon$Fecha = as.Date(Carbon$Fecha)
Gas$Fecha = as.Date(Gas$Fecha)
energetica$Fecha = as.Date(energetica$Fecha)
Precipitacion$Fecha = as.Date(Precipitacion$Fecha)
Temperatura$Fecha = as.Date(Temperatura$Fecha)
Producto$Fecha = as.Date(Producto$Fecha)
Inflacion$Fecha = as.Date(Inflacion$Fecha)
Tasa$Fecha = as.Date(Tasa$Fecha)
Ocupacion$Fecha = as.Date(Ocupacion$Fecha)
ExCafe$Fecha = as.Date(ExCafe$Fecha)
ExPetro$Fecha = as.Date(ExPetro$Fecha)


######################### ....SERIE CARBON.... #########################

Carbon %>%
  plot_time_series(Fecha, Carbon)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(Carbon, prop = 0.8)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Carbon ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Carbon ~ Fecha, data = training(particion))


############ Tabla

models_tbl <- modeltime_table(model_fit_ets,
                              model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

############ Visualization

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Carbon
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )



######################### .....SERIE GAS...... #########################

Gas %>%
  plot_time_series(Fecha, Gas)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(Gas, prop = 0.8)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Gas ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Gas ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Gas
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )



######################### ..SERIE ENERGETICA.. #########################

energetica %>%
  plot_time_series(Fecha,Demanda)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(energetica, prop = 0.8)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Demanda ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Demanda ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = energetica
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


######################### SERIE PRECIPITACION  #########################

Precipitacion$Value=as.numeric(Precipitacion$Value)

Precipitacion %>%
  plot_time_series(Fecha, Value)



############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(Precipitacion, prop = 0.8)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Value ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Value ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Precipitacion
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


######################### ..SERIE TEMPERATURA. #########################

Temperatura$Value=as.numeric(Temperatura$Value)

Temperatura %>%
  plot_time_series(Fecha, Value)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(Temperatura, prop = 0.8)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Value ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Value ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Temperatura
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


######################### ......SERIE PIB..... #########################

Producto %>%
  plot_time_series(Fecha, `VAR PIB`)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(Producto, prop = 0.9)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(`VAR PIB` ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(`VAR PIB` ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Producto
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


######################### ...SERIE INFLACION.. #########################

Inflacion %>%
  plot_time_series(Fecha, Inflacion)

############# Datos de Entrenamiento y Prueba 

particion = initial_time_split(Inflacion, prop = 0.9)

############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Inflacion ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Inflacion ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Inflacion
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )



######################### .....SERIE TMR...... #########################

Tasa %>%
  plot_time_series(Fecha, Tasa)

############# Datos de Entrenamiento y Prueba 

particion = initial_time_split(Tasa, prop = 0.8)

############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Tasa ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Tasa ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,
                              model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Tasa
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )




######################### ..SERIE DESEMPLEO... #########################

Ocupacion %>%
  plot_time_series(Fecha, desempleo)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(Ocupacion, prop = 0.85)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(desempleo ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(desempleo ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,
                              model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = Ocupacion
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


######################### .....SERIE CAFE..... #########################

ExCafe %>%
  plot_time_series(Fecha, Cafe)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(ExCafe, prop = 0.85)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Cafe ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Cafe ~ Fecha, data = training(particion))




models_tbl <- modeltime_table(model_fit_ets,model_fit_arima_no_boost)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = ExCafe
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


######################### ...SERIE PETROLEO... #########################

ExPetro %>%
  plot_time_series(Fecha, Petroleo)

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(ExPetro, prop = 0.85)


############# Modelos 

model_fit_ets <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Petroleo ~ Fecha, data = training(particion))

model_fit_arima_no_boost <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Petroleo ~ Fecha, data = training(particion))

model_fit_prophet <- prophet_reg() %>%
  set_engine(engine = "prophet") %>%
  fit(Petroleo ~ Fecha, data = training(particion))
  


models_tbl <- modeltime_table(model_fit_ets,
                              model_fit_arima_no_boost,
                              model_fit_prophet)


calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))

calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = ExPetro
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )



















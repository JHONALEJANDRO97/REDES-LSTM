######################### ......LIBRERIAS..... #########################

library(fpp2)
library(ggplot2)
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



################## DATOS #######################

setwd("C:/Users/alejo/Desktop/Tesis/Datos")
DATOS = read_excel('ExpPetro.xlsx')
DATOS$Fecha = as.Date(DATOS$Fecha)

DATOS %>%
  plot_time_series(Fecha,Valor)


################## CICLOS ##############

inicio=c(2000,1)
nombre='Exportaciones Petroleo'

ts = ts(DATOS[,2],freq=12,inicio)
ts1 = diff(x = ts,lag = 1)

g1 = ggmonthplot(ts1, xlab = "", ylab = "")
g2 = ggseasonplot(ts1, polar = TRUE, continuous = TRUE, xlab = "", main = "")

gt = g1+g2
gt + plot_annotation(title = nombre)

ld = BoxCox.lambda(ts)
Valor2 = BoxCox(ts,ld)

DATOS = cbind(DATOS[,1],Valor2)

################## MODELOS ######################

############# Datos de Entrenamiento y Prueba 

particion <- initial_time_split(DATOS, prop = 0.85)


################## ETSS ######################### 


################## ETSS1

ETS1 <- exp_smoothing() %>%
  set_engine(engine = 'ets' ) %>%
  fit(Valor ~ Fecha, data = training(particion))


models_tbl <- modeltime_table(ETS1)


calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )

################## ETSS2

ETS2 <- exp_smoothing(
  seasonal_period  = 12,
  error            = "multiplicative",
  trend            = "additive",
  season           = "multiplicative"
) %>%
  set_engine("ets")%>%
  fit(Valor ~ Fecha, data = training(particion))


models_tbl <- modeltime_table(ETS2)


calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )




################## ARIMA ########################

############# ARIMA 1 

ARIMA1 <- arima_reg() %>%
  set_engine(engine = "auto_arima") %>%
  fit(Valor ~ Fecha, data = training(particion))

models_tbl <- modeltime_table(ARIMA1)


calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )


############# ARIMA 2 

ndiffs(Valor2)
nsdiffs(Valor2)

ARIMA2 <- arima_reg(
  seasonal_period          = 12,
  non_seasonal_ar          = 2,
  non_seasonal_differences = 1,
  non_seasonal_ma          = 2,
  seasonal_ar              = 1,
  seasonal_differences     = 0,
  seasonal_ma              = 1
) %>%
  set_engine("arima")

ARIMA2 <- ARIMA2 %>%
  fit(Valor ~ Fecha, data = training(particion))


models_tbl <- modeltime_table(ARIMA2)


calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )

ARIMA2$fit
coeftest(ARIMA2$fit$models$model_1)



################## GAMS ########################

############# GAM 1

GAM1 <- prophet_reg() %>%
  set_engine(engine = "prophet") %>%
  fit(Valor ~ Fecha, data = training(particion))

models_tbl <- modeltime_table(GAM1)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )



############# GAM 2

GAM2 <- prophet_reg(
  mode = "regression",
  growth = "linear",
  changepoint_num = 7,
  changepoint_range = 0.8,
  seasonality_yearly = 'auto',
  seasonality_weekly = 'auto',
  seasonality_daily = 'auto',
  season = 'multiplicative',
  prior_scale_changepoints = 0.05,
  prior_scale_seasonality = 10,
  prior_scale_holidays = 10,
  logistic_cap = NULL,
  logistic_floor = NULL
)%>%
  set_engine("prophet")%>%
  fit(Valor ~ Fecha, data = training(particion))


models_tbl <- modeltime_table(GAM2)

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )



################## SVR ########################

y = DATOS$Valor
n = length(y)

yt = y[(12+1):n]
y1 = y[(12):(n-1)]
y2 = y[(11):(n-2)]
y3 = y[(10):(n-3)]
y11= y[(12-10):(n-11)]
y12= y[(12-11):(n-12)]
xt = seq(1:length(yt))

Dt = length(testing(particion)$Valor)
DATA = data.frame(cbind(yt,xt,y1,y2,y3,y11,y12))

form = yt~xt+y1+y2+y12

SVR = NULL
n = length(yt)
for (i in 0:(Dt-1)) {
  
  ntr = n - (Dt-i)
  SVR1 <- svm(formula = form, data = DATA[c(1:ntr),] )
  SVR[i+1] <- predict(SVR1,newdata = DATA[ntr+1,] )
  
}


plot(x = seq(1:Dt),y = tail(DATA,Dt)[,1], type = "l")
lines(x = seq(1:Dt),y = SVR, col=2)


################## MODELOS FINALES ###########################

models_tbl <- modeltime_table(ETS2,
                              ARIMA2,
                              GAM2)


calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(particion))


calibration_tbl %>%
  modeltime_forecast(
    new_data    = testing(particion),
    actual_data = DATOS
  ) %>%
  plot_modeltime_forecast(
    .legend_max_width = 25 # For mobile screens
  )




##################### Resultados ###################################### 

ETS = calibration_tbl$.calibration_data[[1]]$.prediction
ARIMA = calibration_tbl$.calibration_data[[2]]$.prediction
GAM = calibration_tbl$.calibration_data[[3]]$.prediction



data_pred = cbind(ETS,ARIMA,GAM,SVR)
data_pred = boxcox.inv(data_pred,ld)

setwd("C:/Users/alejo/Desktop/Tesis/resultados")

write.csv(data_pred, "pred_petroleo")



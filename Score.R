# library

library(ggplot2)
library(reshape)
library(reshape2)
library(xtable)
library(patchwork)
library(scales)


setwd("C:/Users/alejo/Desktop/Tesis/resultados")


D1=read.csv('score_energetica')
D2=read.csv('score_carbon')
D3=read.csv('score_gas')
D4=read.csv('score_temperatura')
D5=read.csv('score_inflacion')
D6=read.csv('score_desempleo')
D7=read.csv('score_petroleo')
D8=read.csv('score_tmr')

DATA=cbind(D1,D2,D3,D4,D5,D6,D7,D8)
DATA=DATA[,c(1,2,4,6,8,10,12,14,16)]


xtable(DATA)


D1[,2]=rescale(D1[,2],to = c(1,10))
D2[,2]=rescale(D2[,2],to = c(1,10))
D3[,2]=rescale(D3[,2],to = c(1,10))
D4[,2]=rescale(D4[,2],to = c(1,10))
D5[,2]=rescale(D5[,2],to = c(1,10))
D6[,2]=rescale(D6[,2],to = c(1,10))
D7[,2]=rescale(D7[,2],to = c(1,10))
D8[,2]=rescale(D7[,2],to = c(1,10))

DATA=cbind(D1,D2,D3,D4,D5,D6,D7,D8)
DATA=DATA[,c(1,2,4,6,8,10,12,14,16)]



DATA=as.data.frame(DATA)

DATA2=melt(DATA) 
colnames(DATA2)=c('Modelo','Serie','score')

h1 = ggplot(DATA2, aes(fill=Modelo, y=score, x=Serie)) + 
  geom_bar(position="dodge", stat="identity")+
  scale_fill_discrete(name = "Modelo", labels = c("ARIMA", "ETS", "GAM", "LSTM", "MEDIA", "SVR"))+
  scale_x_discrete(labels = c("Energetica", "Carbon" ,"Gas", "Temperatura", "Inflacion", "Desempleo", "Petroleo", "TRM"))+
  scale_y_discrete(name = "RMSE Escalado (1,10)")+ theme_minimal()



h2 = ggplot(DATA2, aes(fill=Serie, y=score, x=Modelo)) + 
  geom_bar(position="dodge", stat="identity")+ 
  scale_x_discrete(name = "Modelo", labels = c("ARIMA", "ETS", "GAM", "LSTM", "MEDIA", "SVR"))+
  scale_fill_discrete(labels = c("Energetica", "Carbon" ,"Gas", "Temperatura", "Inflacion", "Desempleo", "Petroleo", "TRM"))+
  scale_y_discrete(name = "RMSE Escalado (1,10)")+ theme_minimal()




h1+h2

xtable(DATA)

                          #Aula 12 - Modelos  ARIMA

library("urca")                                #Carrega Pacote URCA
library(readxl)                                #Carrega Pacote readxl
library(pwt8)                                  #Carrega o pacote PWT8.0


data("pwt8.0")                                 #Carrega os dados elencados "pwt8.0" dispoin�veis no pacote
View(pwt8.0)                                   #Visualiza os dados na tabela pwt8.0


br <- subset(pwt8.0, country=="Brazil", 
             select = c("rgdpna","emp","xr"))  #Cria a tabela "br" com dados das linhas que assumem o valor "country" (pa�s) igual a "Brazil", selecionando as colunas cujas vari�veis s�o "rgdpna" (PIB), "avh" (TRABALHO)  e "xr" (C�MBIO)

colnames(br) <-  c("PIB","Emprego","C�mbio")   #Renomeia as colunas para PIB, Trabalho e C�mbio

                                        #Separando as vari�veis
PIB <- br$PIB[45:62]                    #Cria o vetor para vari�vel PIB                  
EMPREGO <- br$Emprego[45:62]            #Cria o vetor para vari�vel EMPREGO
CAMBIO <- br$C�mbio[45:62]              #Cria o vetor para vari�vel CAMBIO
Anos <- seq(from=1994, to=2011, by=1)   #Cria um vetor para o tempo em anos de 1994 at� 2011 


                                    #Analise para o Emprego

plot(PIB, type = "l")                            #Cria gr�fico para o PIB
PIB <- ts(PIB, start = 1994, frequency = 1)  #Define como S�rie Temporal
plot(PIB, main="EVOLU��O PIB", 
     ylab="PIB", 
     xlab="Ano")                                      #Cria gr�fico da S�rie Temporal

acf(PIB)                                          #Fun��o de Autocorrela��o
pacf(PIB)                                         ##Fun��o de Autocorrela��o Parcial
reglinPIB <- lm(PIB ~ Anos)                       #Regress�o linear simples do emprego em rela��o ao tempo
reglinPIB                                             #Exibe os resultados da regress�o linear
summary(reglinPIB)
plot(PIB)                                         #Gr�fcio dos dados
abline(reglinPIB, col="Blue")                         #Insere a linha de regress�o linear estimada


#Removendo Tend�ncia

residuosPIB <- reglinPIB$residuals                    #Salva os res�duos no vetor residuosEMP
reglinPIBres <- lm(residuosPIB ~ Anos)                #Regress�o linear dos res�duos em fun��o do tempo
plot(residuosPIB,type="l")                            #Gr�fico dos res�duos
abline(reglinPIBres, col="Blue")                      #Insere a linha de regress�o linear dos res�duos


#Removendo Tend�ncia por meio da diferen�a

pdPIB <- diff(PIB)                                #Calcula a primeira diferen�a da s�rie de dados
diferencaP <- (data.frame(PIB[2:18],pdPIB))       #Exibe a tabela da s�rie original coma diferen�a <- 
DIFERENCAPIB <- ts(diferencaP, start = 1994, frequency = 1)  #Define serie temporal para a tabela diferenca1
plot(DIFERENCAPIB, plot.type="single", col=c("Black","Green")) #Cria o grafico com as duas series
plot(pdPIB, type="l")                                   #Cria gr�pafico somente para a serie da diferen�a

#Teste Dick-Fuller Aumentado conferindo se a serie se tornou estacionaria

pdPIB1 <- diff(PIB)                                            #Calculando-se a primeira diferen�a
TesteDF_PIB1_trend <- ur.df(pdPIB1, "trend", lags = 1)         #Teste DF-DickFuller com drift e com tendencia
summary(TesteDF_PIB1_trend) 

pdPIB2 <- diff(diff(PIB))                                      #Calculando-se a segunda diferen�a
TesteDF_PIB2_trend <- ur.df(pdPIB2, "trend", lags = 1)         #Teste DF-DickFuller com drift e com tendencia
summary(TesteDF_PIB2_trend)

#Estimando a s�rie temporal

arima123P <- arima(PIB, c(1,2,3))

#ARMA
arima120P <- arima(PIB, c(1,2,0))
arima121P <- arima(PIB, c(1,2,1))
arima122P <- arima(PIB, c(1,2,2))

arima220P<- arima(PIB, c(2,2,0))
arima221P<- arima(PIB, c(2,2,1))
arima222P<- arima(PIB, c(2,2,2))
arima223P<- arima(PIB, c(2,2,3))
#MA
arima021P<- arima(PIB, c(0,2,1))
arima022P<- arima(PIB, c(0,2,2))
arima023P<- arima(PIB, c(0,2,3))
#AR
arima020P<- arima(PIB, c(0,2,3))

#Escolher o melhor modelo com base no menor AIC/BIC
estimacoes <- list(arima123P,arima120P,arima121P,
                   arima122P,arima220P,arima221P,
                   arima222P,arima223P,arima021P, arima022P,
                   arima023P,arima020P)
AIC <- sapply(estimacoes, AIC)
BIC <- sapply(estimacoes, BIC)
Modelo <-c(list("arima123P","arima120P","arima121P",
                "arima122P","arima220P","arima221P",
                "arima222P","arima223P","arima021P","arima022P",
                "arima023P","arima020P")) 
Resultados <- data.frame(Modelo,AIC,BIC)

#An�lise para o C�mbio

#An�lise para o PIB



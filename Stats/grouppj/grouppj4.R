rm(list = ls())
#############Fix-start################
numoffers <- function(Q0){
##Model of Demand of Analysts
HistoricD <- c(105,95,75,70,70,110,105,90,65,
               80,90,120,105,95,75)
econGrowth <- rnorm(1,0,.05)
Noise <- rnorm(15,0,0.1)
D <- round(HistoricD*(1+econGrowth)*(1+Noise))
##Model of Supply of Analysts
OfferMade <- rep(0,15)
OfferMade[4] <- Q0 
NumofAnalytst <- rep(0,15)
NumofAnalytst[1] <- 63 #Apr
#Retention rate (starting Apr)
R <- c(runif(1,.9,1),runif(4,.95,1),
       runif(1,.8,1),runif(3,.9,1),
        runif(1,.8,1),runif(2,.9,1),
       runif(1,.9,1),runif(2,.95,1))
for(i in 1:14){
  Acceptd <- rbinom(1,OfferMade[i+1],0.7)
  NumofAnalytst[i+1] <- round(NumofAnalytst[i]*R[i]) +Acceptd}

##Calculations of Earnings Conribution
Earning <- rep(0,15)
for (i in 1:15){
  if(NumofAnalytst[i]!=D[i])
    {
    if(NumofAnalytst[i]>D[i])
      {Earning[i] = 10000*D[i]-6000*NumofAnalytst[i]}
    else
      {Earning[i] = 4000*NumofAnalytst[i]+400*(D[i]-NumofAnalytst[i])}
    }
  else
  {Earning[i] = 4000*NumofAnalytst[i]}
}
#print(rbind(NumofAnalytst,D))
#print(Earning)
return(sum(Earning))
}

avgTEarnings <- rep(0,100)
for (i in 1:100){
  TEarings <- rep(0,5000)
  for (j in 1:5000){
  TEarings[j] <- numoffers(10+i)}
  avgTEarnings[i] <- mean(TEarings)}
  
(maxEarning_d <- max(avgTEarnings))
(optimaloffers_d<- 10+which.max(avgTEarnings))
plot(x = 11:110,y = avgTEarnings, xlab="Job Offers", ylab="Expected Earnings", 
    ylim=c(3200000, 3750000),main="(d)")
legend(x="topright" ,title = "Best Value", 
       c(c("Job Offers:", optimaloffers_d), c("Earnings:", maxEarning_d)), cex=.7)
points(optimaloffers_d, maxEarning_d, type="p", col="red", pch=21, cex=2)

#############Flexible-start###########
#Flexible start
numoffers_flex <- function(Q0){
  ##Model of Demand of Analysts
  H <- c(105,95,75,70,70,110,105,90,65,
         80,90,120,105,95,75)
  econGrowth <- rnorm(1,0,.05)
  Noise <- rnorm(15,0,0.1)
  D <- round(H*(1+econGrowth)*(1+Noise))
  ##Model of Supply of Analysts
  Accepted <- rbinom(1,Q0,0.7)
  A <- rep(0,15)
  A[4] <- round(Accepted/2) #Jun
  A[6] <- round((Accepted - A[4])*runif(1,.7,1)) #Aug
  NumAnalyst <- rep(0,15)
  NumAnalyst[1] <- 63 #Apr
  #Retention rate (starting Apr)
  R <- c(runif(1,.9,1),runif(4,.95,1),
         runif(1,.8,1),runif(3,.9,1),
         runif(1,.8,1),runif(2,.9,1),
         runif(1,.9,1),runif(2,.95,1))
  for(i in 1:14){
      NumAnalyst[i+1] <-round(NumAnalyst[i]*R[i]+A[i+1])}
  
  ContributionA <- 4000
  ContributionT <- 400
  ##Calculations of Earnings Conribution
  Earning<- c()
  for (i in 1:15){
    if ((NumAnalyst[i])>D[i])
    {Earning[i] = 10000*D[i]-6000*NumAnalyst[i]}
    if (NumAnalyst[i]<D[i])
    {Earning[i] = ContributionA*NumAnalyst[i]+ContributionT *(D[i]-NumAnalyst[i])}
    if(NumAnalyst[i]==D[i])
    {Earning[i] = ContributionA*NumAnalyst[i]}
  }
  #print(NumAnalyst)
  return(sum(Earning))
}

avgTEarnings <- rep(0,100)
for (i in 1:100){
  TEarings <- rep(0,5000)
  for (j in 1:5000){
    TEarings[j] <- numoffers_flex(10+i)}
  avgTEarnings[i] <- mean(TEarings)}

(maxEarning_e <- max(avgTEarnings))
(optimaloffers_e<- 10+which.max(avgTEarnings))
plot(x = 11:110,y = avgTEarnings, xlab="Job Offers", ylab="Expected Earnings", 
     main="(e)")
legend(x="topleft" ,title = "Best Value", 
       c(c("Job Offers:", optimaloffers_e), c("Earnings:", maxEarning_e)), cex=.7)
points(optimaloffers_e, maxEarning_e, type="p", col="red", pch=21, cex=2)

rm(list = ls())
#############(f)###########
set.seed(207)
#fixed start
numoffers_f1 <- function(Q01,Q02){
  ##Model of Demand of Analysts
  HistoricD <- c(105,95,75,70,70,110,105,90,65,
         80,90,120,105,95,75)
  econGrowth <- rnorm(1,0,.05)
  Noise <- rnorm(15,0,0.1)
  D <- round(HistoricD*(1+econGrowth)*(1+Noise))
  ##Model of Supply of Analysts
  Accepted <- rep(0,15)
  Accepted[4] <- rbinom(1,Q01,0.7) #Jun
  Accepted[9] <- rbinom(1,Q02,0.7) #Dec
  numAnalyst <- rep(0,15)
  numAnalyst[1] <- 63 #Apr
  #Retention rate (starting Apr)
  R <- c(runif(1,.9,1),runif(4,.95,1),
         runif(1,.8,1),runif(3,.9,1),
         runif(1,.8,1),runif(2,.9,1),
         runif(1,.9,1),runif(2,.95,1))
  for(i in 1:14){
    numAnalyst[i+1] <- round(numAnalyst[i]*R[i] + Accepted[i+1])}

  ContributionA <- 4000
  ContributionT <- 400
  ##Calculations of Earnings Conribution
  E<- c()
  for (i in 1:15){
    if ((numAnalyst[i])>D[i])
    {E[i] = 10000*D[i]-6000*numAnalyst[i]}
    if (numAnalyst[i]<D[i])
    {E[i] = ContributionA*numAnalyst[i]+ContributionT *(D[i]-numAnalyst[i])}
    if(numAnalyst[i]==D[i])
    {E[i] = ContributionA*numAnalyst[i]}
  }
  return(sum(E))
}
#flexible start
numoffers_f2 <- function(Q01,Q02){
  ##Model of Demand of Analysts
  HistoricD <- c(105,95,75,70,70,110,105,90,65,
                 80,90,120,105,95,75)
  econGrowth <- rnorm(1,0,.05)
  Noise <- rnorm(15,0,0.1)
  D <- round(HistoricD*(1+econGrowth)*(1+Noise))
  ##Model of Supply of Analysts
  Accept_June <- rbinom(1,Q01,0.7)
  A <- rep(0,15)
  A[4] <- round(.5*Accept_June) #Jun
  A[6] <- round((Accept_June - A[3])*runif(1,.7,1)) #Aug
  A[9] <- rbinom(1,Q02,0.7) #Dec
  numAnalyst <- rep(0,15)
  numAnalyst[1] <- 63 #Apr
  #Retention rate (starting Apr)
  R <- c(runif(1,.9,1),runif(4,.95,1),
         runif(1,.8,1),runif(3,.9,1),
         runif(1,.8,1),runif(2,.9,1),
         runif(1,.9,1),runif(2,.95,1))
  for(i in 1:14){
    numAnalyst[i+1] <- round(numAnalyst[i]*R[i] + A[i+1])}
  
  ContributionA <- 4000
  ContributionT <- 400
  ##Calculations of Earnings Conribution
  E<- c()
  for (i in 1:15){
    if ((numAnalyst[i])>D[i])
    {E[i] = 10000*D[i]-6000*numAnalyst[i]}
    if (numAnalyst[i]<D[i])
    {E[i] = ContributionA*numAnalyst[i]+ContributionT *(D[i]-numAnalyst[i])}
    if(numAnalyst[i]==D[i])
    {E[i] = ContributionA*numAnalyst[i]}
  }
  return(sum(E))
}

reptime <- 1000
#offers is a list, each item will be a list of (Q1,Q2)
offers <- c()
avgTEarnings1 <- rep(0,400)
avgTEarnings2 <- rep(0,400)
for (i in 1:20){ #loop for Q1
  for (k in 1:20){ #loop for Q2
    TotalE1 <- rep(0,reptime)
    TotalE2 <- rep(0,reptime)
    # For each pair of Q1,Q2, repeat for
    # average Earning in two hiring strategies
    for (j in 1:reptime){       
      TotalE1[j]<- numoffers_f1(10+5*i,10+5*k)
      TotalE2[j]<- numoffers_f2(10+5*i,10+5*k)
    }
    avgTEarnings1[20*(i-1)+k] <- mean(TotalE1)-22000
    avgTEarnings2[20*(i-1)+k] <- mean(TotalE2)-22000
    offers[20*(i-1)+k] <- list(c(10+5*i,10+5*k))
  }
}
#Solution for fixed start
offers[which.max( avgTEarnings1)]
#Solution for flexible start
offers[which.max( avgTEarnings2)]
par(mfrow=c(1,2))
plot(density(avgTEarnings1),main = "fix start")
legend(x="topleft" ,title = "Best Value", legend = 
       c(c("Job Offers in Jun:", offers[[which.max( avgTEarnings1)]][1]),
         c("Job Offers in Dec:", offers[[which.max( avgTEarnings1)]][2]), 
         c("Earnings:", max(avgTEarnings1))), cex=.7)
plot(density(avgTEarnings2),main="flexible start")
legend(x="topleft" ,title = "Best Value", legend = 
       c(c("Job Offers in Jun:", offers[[which.max( avgTEarnings2)]][1]),
         c("Job Offers in Dec:", offers[[which.max( avgTEarnings2)]][2]),
         c("Earnings:", max(avgTEarnings2))), cex=.7)
par(mfrow=c(1,1))
rm(list=ls())

library("FNN")
library("class")

title <- "Assignment 1"
name <- "Tianchu Ye (Section 2)"
title
name
##################### 
#### QUESTION 01 #### 
#####################
homePrices <- read.table("HomePrices.txt",sep="\t",header=T)
meanMedv <- mean(homePrices$medv)
MSE <- mean((homePrices$medv - meanMedv)^2)
MSE
n = nrow(homePrices)
varMedv <- (n-1)*var(homePrices$medv)/n
varMedv
#page3
scaledata <- scale(homePrices[1:12],center = TRUE, scale = TRUE)
mydata <-cbind(scaledata,homePrices[13])
head(mydata,6)
set.seed(5072)
trainprop <- 0.75 
validateprop <- 0.15
train  <-  sample(n, trainprop * n)
validate  <-  sample(setdiff(1:n, train), validateprop * n) 
test <- setdiff(setdiff(1:n, train), validate)
trainset <- mydata[train,]
validateset <- mydata[validate,]
testset <- mydata[test,]
head(trainset,1)
head(validateset,1)
head(testset,1)
#creating 6 data frames
train.x <- trainset[-13]
validate.x <- validateset[-13]
test.x <- testset[-13]
train.y <- trainset$medv
validate.y <- validateset$medv
test.y <- testset$medv
reps = 10
validate.mse <- rep(0, reps)
train.mse <- rep(0, reps)
for (k in 1:reps){
  i <- 2*k - 1
  knn.pred <- knn.reg(train.x, validate.x, train.y, k = i)
  validate.mse[k] <- mean((validate.y - knn.pred$pred)^2)
  
  knn.pred <- knn.reg(train.x, train.x, train.y, k = i)
  train.mse[k] <- mean((train.y - knn.pred$pred)^2)
}
bestk <- 2 * which.min(validate.mse) - 1
bestvalidateMse <- validate.mse[which.min(validate.mse)]

print(paste("Minimum validate set MSE occurred at k =", bestk))
print(paste("Minimum validate MSE was ",bestvalidateMse ))

plot(NULL, NULL, type='n', xlim=c(2*reps-1, 1), ylim=c(0,max(c(validate.mse, train.mse))), xlab='Increasing Flexibility (Decreasing k)', ylab='MSE', main='MSEs as a Function of \n Flexibility for KNN Regression')
lines(2* seq(reps, 1) -1, validate.mse[length(validate.mse):1], type='b', col=2, pch=16)
lines(seq(reps, 1)*2-1, train.mse[length(train.mse):1], type='b', col=1, pch=16)
legend("topright", legend = c("Validation MSE", "Training MSE"), col=c(2, 1), cex=.75, pch=16)

knn.pred <- knn.reg(train.x, test.x, train.y, k = bestk)
test.mse <- mean((test.y - knn.pred$pred)^2)
print(paste("Predicted test MSE is", test.mse))

##################### 
#### QUESTION 02 #### 
#####################
loandata<- read.table("LoanData.csv",sep=",",header=T)
loandataS<- cbind(scale(loandata[1:7]),loandata[8])
#error rate
head(loandataS,6)
n = nrow(loandataS)
errorRate <- mean(loandata[8] != "Yes")
errorRate

set.seed(5072)
trainprop <- 0.75  
validateprop <- 0.15
train  <-  sample(n, trainprop * n)
validate  <-  sample(setdiff(1:n, train), validateprop * n) 
test <- setdiff(setdiff(1:n, train), validate)
trainset <- loandataS[train,]
validateset <- loandataS[validate,]
testset <- loandataS[test,]
#check desired sample
head(trainset,1)
head(validateset,1)
head(testset,1)
train.x <- trainset[-8]
validate.x <- validateset[-8]
test.x <- testset[-8]
train.y <- trainset$loan.repaid
validate.y <- validateset$loan.repaid
test.y <- testset$loan.repaid
reps <- 10
validate.errors <- rep(0, reps)
train.errors <- rep(0, reps)
for(k in 1:reps) {
  i <- 2*k-1
  knn.pred <- knn(train.x, validate.x,  train.y, k = i)
  validate.errors[k] <- mean(validate.y != knn.pred)
  
  knn.pred <- knn(train.x, train.x,  train.y, k = i)
  train.errors[k] <- mean(train.y != knn.pred)    
}
print(paste("Minimum validate set error rate occurred at k =", 2*which.min(validate.errors)-1))
print(paste("Minimum validate error rate was ", validate.errors[which.min(validate.errors)]))
#plotting
plot(NULL, NULL, type='n', xlim=c(2*reps-1, 1), ylim=c(0,max(c(validate.errors, train.errors))), xlab='Increasing Flexibility (Decreasing k)', ylab='Error Rates', main='Error Rates as a Function of \n Flexibility for KNN Classification')
lines(2* seq(reps, 1) -1, validate.errors[length(validate.errors):1], type='b', col=2, pch=16)
lines(2* seq(reps, 1) -1, train.errors[length(train.errors):1], type='b', col=1, pch=16)
legend("topleft", legend = c("Validation Error Rate", "Training Error Rate"), col=c(2, 1), cex=.75, pch=16)

knn.pred <- knn(train.x, test.x,  train.y, k = which.min(validate.errors))
mytable <- table(test.y, knn.pred)
print(mytable)
print(paste("Test set error rate was ",(mytable["Yes", "No"] + mytable["No", "Yes"]) / sum(mytable)))

##################### 
#### QUESTION 03 #### 
#####################
set.seed(5072)
#setting up again in case of overriding
homePrices <- read.table("HomePrices.txt",sep="\t",header=T)
n = nrow(homePrices)
scaledata <- scale(homePrices[1:12],center = TRUE, scale = TRUE)
mydata <-cbind(scaledata,homePrices[13])

trainprop <- 0.75 
validateprop <- 0.15
MinMSEset <- rep(0,50)
TestMSEset <- rep(0,50)

for (repeatT in 1:50){
  train  <-  sample(n, trainprop * n)
  validate  <-  sample(setdiff(1:n, train), validateprop * n) 
  test <- setdiff(setdiff(1:n, train), validate)
  trainset <- mydata[train,]
  validateset <- mydata[validate,]
  testset <- mydata[test,]

  train.x <- trainset[-13]
  validate.x <- validateset[-13]
  test.x <- testset[-13]
  train.y <- trainset$medv
  validate.y <- validateset$medv
  test.y <- testset$medv
  reps = 10
  validate.mse <- rep(0, reps)
  for (k in 1:reps){
    i <- 2*k - 1
    knn.pred <- knn.reg(train.x, validate.x, train.y, k = i)
    validate.mse[k] <- mean((validate.y - knn.pred$pred)^2)
    }
  bestk <- 2 * which.min(validate.mse) - 1
  MinMSEset[repeatT] <- validate.mse[which.min(validate.mse)]
  knn.pred <- knn.reg(train.x, test.x, train.y, k = bestk)
  TestMSEset[repeatT] <-mean((test.y - knn.pred$pred)^2)
}
#disply results
print(paste("mean.validate.mse:", mean(MinMSEset)))
print(paste("sd.validate.mse:", sd(MinMSEset)))
print(paste("mean.test.mse:", mean(TestMSEset)))
print(paste("sd.test.mse:", sd(TestMSEset)))
#ploting
plot(NULL, NULL, type='n', xlim=c(1,50), ylim=c(0,max(c(MinMSEset, TestMSEset))), xlab='Replication', ylab='MSEs', main='Test and Best Validation MSEs for Many Partitionings of the Data')
lines(seq(50,1), MinMSEset[length(MinMSEset):1], type='b', col=2, pch=16)
lines(seq(50,1), TestMSEset[length(TestMSEset):1], type='b', col=1, pch=16)
abline(h = mean(MinMSEset), col=2, lty = 2, lwd = 2)
abline(h = mean(TestMSEset), col=1, lty = 2, lwd = 2)
legend("topright", legend = c("Validate MSEs","Validat MSE mean", "Test MSEs","Test MSEs mean"), col=c(2,2,1,1), cex=.75, pch=c(16,-1,16,-1), lty = c(1,2,1,2))

# Comment:
# Comparing to the mse in Q1, which is 11.81, and 11.81 is in the interval (mean.mse +/- sd.mse),
# in other words, the difference is acceptable. We can't control sample process so this is also
# part of uncertainty we can't avoid.

##################### 
#### QUESTION 04 #### 
#####################
set.seed(5072) #for easier check
#re-read table in case of overriding
q4data <- read.csv("applications.train.csv", header=TRUE, sep=",") 
n4 <- nrow(q4data)
ncol <- ncol(q4data)
trainprop <- .75/(1-.1) 
#Assume testprop is .1. The table doesn't contain test data
#so the trainprop is calculated to keep the 75/15/10 ratio in previous question
bestKset <- rep(0,50)
mse_each <-c()

##choose subset of data
#Print out all each column of the data to choose the dataset
for (i in 2:ncol){
  train  <-  sample(n4, trainprop * n4)
  validate <- setdiff(1:n4, train)
  trainset <- q4data[train,]
  validateset <- q4data[validate,]
  
  train.x <- trainset[i]
  validate.x <- validateset[i]
  
  train.y <- trainset$Applications
  validate.y <- validateset$Applications
  
  mseset <- c()
  for (k in 1:10){
    knn.pred <- knn.reg(train.x, validate.x,  train.y, k = k)
    mseset[k] <- mean((validate.y - knn.pred$pred)^2)}
  mse_each[i-1] <- mean(mseset)
}


#Looking for a dataset with smaller mse, choose (mean-sd/2) as the standard 
meanmse <- mean(mse_each)
sdmse <- sd(mse_each)
colSet <- c()
idxcol <- 1
for (i in 1:length(mse_each)){
  if(mse_each[i] <= meanmse- sdmse){
    colSet[idxcol] <- i + 1
    idxcol <- idxcol+1
  }
}

print("The chosen data subset's column index set in the data frame is:")
colSet

for (t in 1:50){
  train  <-  sample(n4, trainprop * n4)
  validate <- setdiff(1:n4, train)
  trainset <- q4data[train,]
  validateset <- q4data[validate,]

  train.x <- trainset[colSet]
  validate.x <- validateset[colSet]

  train.y <- trainset$Applications
  validate.y <- validateset$Applications

  reps <- 10
  validate.mse <- rep(0, reps)

  for(k in 1:reps) {
    knn.pred <- knn.reg(train.x, validate.x, train.y, k = k)
    validate.mse[k] <- mean((validate.y - knn.pred$pred)^2)
  }
  bestKset[t] <- which.min(validate.mse)
}
print(paste("Minimum validate set error rate occurred at k =", which.max(table(bestKset))))


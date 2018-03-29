rm(list=ls())
title <- "Assignment 3"
name <- "Tianchu Ye (Section 2)"
title
name
### Functions
##########################################################################################
installIfAbsentAndLoad <- function(neededVector) {
  for(thispackage in neededVector) {
    if( ! require(thispackage, character.only = T) )
    { install.packages(thispackage)}
    require(thispackage, character.only = T)
  }
}
### Load required packages 
##############################
needed <- c( "ISLR", "boot","FNN","MASS")  
installIfAbsentAndLoad(needed)
###################
### Question 01 ###
###################
set.seed(5072)
log.fit <- glm(Direction ~ Lag1+Lag2+Lag3+Lag4+Lag5+Volume,family=binomial,data=Weekly)
summary(log.fit)
#b)Lag2 is significant basing on the output of summary() as its p-value is small enough to reject null hypothesis
log.probs <- predict(log.fit, type="response")
contrasts(Weekly$Direction)
log.pred <- rep("Down", nrow(Weekly))
log.pred[log.probs>.5] <- "Up"
table1 <- table(Weekly$Direction, log.pred)
table1
#Overall correct prediction
(table1[1, 1]+table1[2, 2])/sum(table1)
#Overall error rate
(table1[1, 2]+table1[2, 1])/sum(table1)
#Type I eroor rate
table1[1, 2]/sum(table1[1,])
#Type II eroor rate
table1[2, 1]/sum(table1[2,])
#Power
table1[2, 2]/sum(table1[2,])
#Precision
table1[2, 2]/sum(table1[,2])

#e)
train <- Weekly$Year < 2009
Year0910 <- Weekly[!train,]
Direction0910 <- Weekly$Direction[!train] 
log.fit_ <- glm(Direction ~ Lag2,family=binomial,data=Weekly,subset = train)
log.probs_ <- predict(log.fit_,Year0910, type="response")
log.pred_ <- rep("Down", nrow(Year0910))
log.pred_[log.probs_>.5] <- "Up"
table1_ <- table(Direction0910, log.pred_)
table1_
#Overall correct prediction
(table1_[1, 1]+table1_[2, 2])/sum(table1_)
#Overall error rate
(table1_[1, 2]+table1_[2, 1])/sum(table1_)
#Type I eroor rate
table1_[1, 2]/sum(table1_[1,])
#Type II eroor rate
table1_[2, 1]/sum(table1_[2,])
#Power
table1_[2, 2]/sum(table1_[2,])
#Precision
table1_[2, 2]/sum(table1_[,2])


#g)
lda.fit <-lda(Direction~Lag2,data = Weekly,subset=train)
lda.pred <- predict(lda.fit,Year0910)
lda.class <- lda.pred$class
table2 <- table(Direction0910, lda.class)
table2
#Overall correct prediction
(table2[1, 1]+table2[2, 2])/sum(table2)
#Overall error rate
(table2[1, 2]+table2[2, 1])/sum(table2)
#Type I eroor rate
table2[1, 2]/sum(table2[1,])
#Type II eroor rate
table2[2, 1]/sum(table2[2,])
#Power
table2[2, 2]/sum(table2[2,])
#Precision
table2[2, 2]/sum(table2[,2])

#h)
qda.fit <- qda(Direction~Lag2,data = Weekly, subset = train)
qda.pred <- predict(qda.fit,Year0910)
qda.class <- qda.pred$class
table3 <- table(Direction0910, qda.class)
table3
#Overall correct prediction
(table3[1, 1]+table3[2, 2])/sum(table3)
#Overall error rate
(table3[1, 2]+table3[2, 1])/sum(table3)
#Type I eroor rate
table3[1, 2]/sum(table3[1,])
#Type II eroor rate
table3[2, 1]/sum(table3[2,])
#Power
table3[2, 2]/sum(table3[2,])
#Precision
table3[2, 2]/sum(table3[,2])

#i)
knn.fit1 <- knn(Weekly[train,3],Year0910[3],Weekly[train,]$Direction,k=1)
#Overall correct prediction
mean(Direction0910 == knn.fit1) 
#Overall error rate
mean(Direction0910 != knn.fit1) 
table4 <- table(Direction0910, knn.fit1)
table4
#Type I eroor rate
table4[1, 2]/sum(table4[1,])
#Type II eroor rate
table4[2, 1]/sum(table4[2,])
#Power
table4[2, 2]/sum(table4[2,])
#Precision
table4[2, 2]/sum(table4[,2])

#j)
knn.fit2 <- knn(Weekly[train,3],Year0910[3],Weekly[train,]$Direction,k=5)
mean(Direction0910 == knn.fit2) 
#Overall error rate
mean(Direction0910 != knn.fit2) 
table5 <- table(Direction0910, knn.fit2)
table5
#Type I eroor rate
table5[1, 2]/sum(table5[1,])
#Type II eroor rate
table5[2, 1]/sum(table5[2,])
#Power
table5[2, 2]/sum(table5[2,])
#Precision
table5[2, 2]/sum(table5[,2])

#k)Based on confusion matrices, lda and logistic (same prediction) has the best 
# result(s) as they have the highest overall correct prediction.

###################
### Question 02 ###
###################
set.seed(5072)
n2 <- nrow(Auto)
mpg01 <- rep(0,n2)
mpgMean <- median(Auto$mpg)
for (i in 1:n2){
  if(Auto$mpg[i]> mpgMean){
  mpg01[i] <- 1
}}
mydata2 <- data.frame(mpg01,Auto[-1])
#c
trainprop <- 0.8
train  <-  sample(n2, trainprop * n2)

#logistic regression
log.fit2 <- glm(mpg01~cylinders+displacement+weight,family=binomial,
                data=mydata2,subset = train)
log.probs2 <- predict(log.fit2,mydata2[-train,], type="response")
log.pred2 <- rep(0, nrow(mydata2[-train,]))
log.pred2[log.probs2>.5] <- 1
table2.1 <- table(mydata2[-train,1], log.pred2)
table2.1
#Overall correct prediction
(table2.1[1, 1]+table2.1[2, 2])/sum(table2.1)
#Overall error rate
(table2.1[1, 2]+table2.1[2, 1])/sum(table2.1)
#Type I eroor rate
table2.1[1, 2]/sum(table2.1[1,])
#Type II eroor rate
table2.1[2, 1]/sum(table2.1[2,])
#Power
table2.1[2, 2]/sum(table2.1[2,])
#Precision
table2.1[2, 2]/sum(table2.1[,2])

#lda
lda.fit <-lda(mpg01~cylinders+displacement+weight,family=binomial,
              data=mydata2,subset = train)
lda.pred <- predict(lda.fit,mydata2[-train,], type="response")
lda.class <- lda.pred$class
table2.2 <- table(mydata2[-train,1], lda.class)
table2.2
#Overall correct prediction
(table2.2[1, 1]+table2.2[2, 2])/sum(table2.2)
#Overall error rate
(table2.2[1, 2]+table2.2[2, 1])/sum(table2.2)
#Type I eroor rate
table2.2[1, 2]/sum(table2.2[1,])
#Type II eroor rate
table2.2[2, 1]/sum(table2.2[2,])
#Power
table2.2[2, 2]/sum(table2.2[2,])
#Precision
table2.2[2, 2]/sum(table2.2[,2])

#g)
qda.fit <- qda(mpg01~cylinders+displacement+weight,family=binomial,
               data=mydata2,subset = train)
qda.pred <- predict(qda.fit,mydata2[-train,], type="response")
qda.class <- qda.pred$class
table2.3 <- table(mydata2[-train,1], qda.class)
table2.3
#Overall correct prediction
(table2.3[1, 1]+table2.3[2, 2])/sum(table2.3)
#Overall error rate
(table2.3[1, 2]+table2.3[2, 1])/sum(table2.3)
#Type I eroor rate
table2.3[1, 2]/sum(table2.3[1,])
#Type II eroor rate
table2.3[2, 1]/sum(table2.3[2,])
#Power
table2.3[2, 2]/sum(table2.3[2,])
#Precision
table2.3[2, 2]/sum(table2.3[,2])

#h)
#head(mydata2,2)   find the column idx of predicters
#found:c(2,3,5)
predIdx <- c(2,3,5)
knn.fit1 <- knn(mydata2[train,predIdx],mydata2[-train,predIdx],mydata2[train,1],k=1)
#Overall correct prediction
mean(mydata2[-train,1] == knn.fit1) 
#Overall error rate
mean(mydata2[-train,1] != knn.fit1) 
table2.4 <- table(mydata2[-train,1], knn.fit1)
table2.4
#Type I eroor rate
table2.4[1, 2]/sum(table2.4[1,])
#Type II eroor rate
table2.4[2, 1]/sum(table2.4[2,])
#Power
table2.4[2, 2]/sum(table2.4[2,])
#Precision
table2.4[2, 2]/sum(table2.4[,2])

#i)
ErrorRate <- rep(0,20)
for(i in 1:20){
  knn.fit2 <- knn(mydata2[train,predIdx],mydata2[-train,predIdx],mydata2[train,1],k=i)
  ErrorRate[i] <- mean(mydata2[-train,1] != knn.fit2) 
}
#bestk chose by min(Overall Error Rate)
bestk <- which.min(ErrorRate)
bestk
knn.fit2 <- knn(mydata2[train,predIdx],mydata2[-train,predIdx],mydata2[train,1],k=bestk)
#Overall correct prediction
mean(mydata2[-train,1] == knn.fit2) 
#Overall error rate (calculated)
min(ErrorRate) 
#Confusion Matrix
table2.5 <- table(mydata2[-train,1], knn.fit2)
table2.5
#Type I eroor rate
table2.5[1, 2]/sum(table2.5[1,])
#Type II eroor rate
table2.5[2, 1]/sum(table2.5[2,])
#Power
table2.5[2, 2]/sum(table2.5[2,])
#Precision
table2.5[2, 2]/sum(table2.5[,2])

#j) 
#Based on confusion matrices, 2.3/2.5 (knn2) has the best result, samllest number
#for False Negative.

###################
### Question 03 ###
###################
set.seed(5072)
n3 <- nrow(Boston)
trainprop <- 0.8
train  <-  sample(n3, trainprop * n3) 
test <- setdiff(setdiff(1:n3, train), train)

crim01 <- rep(0,n3) 
meanCrim <- median(Boston$crim)
for (i in 1:n3){
  if(Boston$crim[i]> meanCrim){
    crim01[i] <- 1
  }}
mydata3 <- data.frame(crim01,Boston[-1])

trainset <- mydata3[train,]
testset <- mydata3[test,]
pred <- c("nox","rad","dis")
predIndex <- match(pred,colnames(trainset))
train.x <- trainset[,predIndex]
test.x <- testset[,predIndex]
train.y <- crim01[train]
test.y <- crim01[test]
  
#logistic 
log.fit3 <- glm(crim01~nox+rad+dis,family=binomial,
                data=mydata3,subset = train)
log.probs3 <- predict(log.fit3,testset, type="response")
log.pred3 <- rep(0, nrow(testset))
log.pred3[log.probs3>.5] <- 1
table3.1 <- table(test.y, log.pred3)
table3.1
#Overall correct prediction
(table3.1[1, 1]+table3.1[2, 2])/sum(table3.1)
#Overall error rate
(table3.1[1, 2]+table3.1[2, 1])/sum(table3.1)
#Type I eroor rate
table3.1[1, 2]/sum(table3.1[1,])
#Type II eroor rate
table3.1[2, 1]/sum(table3.1[2,])
#Power
table3.1[2, 2]/sum(table3.1[2,])
#Precision
table3.1[2, 2]/sum(table3.1[,2])

#lda
lda.fit <-lda(crim01~nox+rad+dis,family=binomial,
              data=mydata3,subset = train)
lda.pred <- predict(lda.fit,testset, type="response")
lda.class <- lda.pred$class
table3.2 <- table(test.y, lda.class)
table3.2
#Overall correct prediction
(table3.2[1, 1]+table3.2[2, 2])/sum(table3.2)
#Overall error rate
(table3.2[1, 2]+table3.2[2, 1])/sum(table3.2)
#Type I eroor rate
table3.2[1, 2]/sum(table3.2[1,])
#Type II eroor rate
table3.2[2, 1]/sum(table3.2[2,])
#Power
table3.2[2, 2]/sum(table3.2[2,])
#Precision
table3.2[2, 2]/sum(table3.2[,2])

#knn
ErrorRate3 <- rep(0,20)
for(i in 1:20){
  knn.fit3 <- knn(train.x,test.x,train.y,k=i)
  ErrorRate3[i] <- mean(test.y != knn.fit3) 
}
#bestk chose by min(Overall Error Rate)
bestk <- which.min(ErrorRate3)
bestk
knn.fit3 <- knn(train.x,test.x,train.y,k=bestk)
#Overall correct prediction
mean(test.y == knn.fit3) 
#Overall error rate (calculated)
min(ErrorRate3) 
table3.3 <- table(test.y, knn.fit3)
table3.3
#Type I eroor rate
table3.3[1, 2]/sum(table3.3[1,])
#Type II eroor rate
table3.3[2, 1]/sum(table3.3[2,])
#Power
table3.3[2, 2]/sum(table3.3[2,])
#Precision
table3.3[2, 2]/sum(table3.3[,2])

#My findings: KNN(k=1) gives the best result with highest rate of overall corect prediction.

###################
### Question 04 ###
###################
set.seed(5072)
x <- rnorm(100)
y <- x - 2 * x^2 + rnorm(100)
mydata4 <- data.frame(x,y)

plot(x,y)
set.seed(123)
deltaSet <- c()
for (i in 1:4){
  glm.fit <- glm(y ~ poly(x,i))
  cv.err <- cv.glm(mydata4,glm.fit)
  deltaSet[i]<-cv.err$delta[1]
}
deltaSet
#repeat with seed 345
set.seed(345)
deltaSet2 <- c()
for (i in 1:4){
  glm.fit <- glm(y ~ poly(x,i))
  cv.err <- cv.glm(mydata4,glm.fit)
  deltaSet2[i]<-cv.err$delta[1]
}
deltaSet2
#e)Comment: Same, becasue LOOCV methond has no random selection so setting 
# different seed won't effect the result.

which.min(deltaSet)
#f)The quadratic model has the smallest LOOCV error, which is same to my expectation
# from the plot as well as the given function of y.

for (i in 1:4){
  lm.fit <- lm(y~poly(x,i))
  print(summary(lm.fit)$coefficients)
}

#g)According to the least square regression, the second model with poly(x,2) has
# p-value for all its coefficients that are small enough to reject the null hypothesis,
# This result agrees with my previous resulf using LOOCV.

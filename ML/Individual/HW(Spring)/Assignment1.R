rm(list=ls())
"Assignment 1"
"Tianchu Ye (Section 2)"
##############################
### Load required packages ###
##############################
installIfAbsentAndLoad  <-  function(neededVector) {
  if(length(neededVector) > 0) {
    for(thispackage in neededVector) {
      if(! require(thispackage, character.only = T)) {
        install.packages(thispackage)}
      require(thispackage, character.only = T)
    }
  }
}
needed <- c('e1071',"ISLR","splines","boot")      
installIfAbsentAndLoad(needed)
###################
### Question 01 ###
###################
# a)
attach(OJ)
set.seed(5082)
n = dim(OJ)[1]
train_inds = sample(1:n,800)
test_inds = (1:n)[-train_inds]
trainset = OJ[train_inds,]
testset = OJ[test_inds,]
# b)
svmfit <- svm(Purchase ~ ., data=trainset, kernel="linear", cost=0.01,scale=T)
summary(svmfit)
## The obtained result shows that the division is 233:233, which is an evenly seperate of 466 SVs.
# c)
pred.train = predict(svmfit,trainset)
trainingE = sum(pred.train!=trainset$Purchase)/nrow(trainset)
pred.test = predict(svmfit,testset)
testE = sum(pred.test!=testset$Purchase)/nrow(testset)
(TE1 = rbind(trainingE,testE))
# d)
tune.out = tune(svm,Purchase~.,data=trainset,kernel="linear",ranges=list(cost=c(0.01,0.05,0.1,0.5,1,5,10)))
bestmod <- tune.out$best.model
#best cost = 0.05
# e)
pred.train = predict(bestmod,trainset)
trainingE = sum(pred.train!=trainset$Purchase)/nrow(trainset)
pred.test = predict(bestmod,testset)
testE = sum(pred.test!=testset$Purchase)/nrow(testset)
(TE2 = rbind(trainingE,testE))
# f)
svmfit2 <- svm(Purchase~., data=trainset, kernel="radial", cost=0.01,scale=T)
summary(svmfit2)
## The obtained result shows that the division is 308:305 for 613 SVs in total.
pred.train = predict(svmfit2,trainset)
trainingE = sum(pred.train!=trainset$Purchase)/nrow(trainset)
pred.test = predict(svmfit2,testset)
testE = sum(pred.test!=testset$Purchase)/nrow(testset)
(TE3 = rbind(trainingE,testE))

tune.out2 = tune(svm,Purchase~.,data=trainset,kernel="radial",ranges=list(cost=c(0.01,0.05,0.1,0.5,1,5,10)))
bestmod <- tune.out2$best.model
pred.train = predict(bestmod,trainset)
trainingE = sum(pred.train!=trainset$Purchase)/nrow(trainset)
pred.test = predict(bestmod,testset)
testE = sum(pred.test!=testset$Purchase)/nrow(testset)
(TE4 = rbind(trainingE,testE))
# g)
svmfit3 <- svm(Purchase~., data=trainset, kernel="polynomial", degree = 2,scale=T,cost = 0.01)
summary(svmfit3)
## The obtained result shows that the division is 309:305 for 614 SVs in total.
pred.train = predict(svmfit3,trainset)
trainingE = sum(pred.train!=trainset$Purchase)/nrow(trainset)
pred.test = predict(svmfit3,testset)
testE = sum(pred.test!=testset$Purchase)/nrow(testset)
(TE5 = rbind(trainingE,testE))

tune.out3 = tune(svm,Purchase~.,data=trainset,kernel="polynomial", degree = 2,ranges=list(cost=c(0.01,0.05,0.1,0.5,1,5,10)),scale=T)
bestmod <- tune.out3$best.model
pred.train = predict(bestmod,trainset)
trainingE = sum(pred.train!=trainset$Purchase)/nrow(trainset)
pred.test = predict(bestmod,testset)
testE = sum(pred.test!=testset$Purchase)/nrow(testset)
(TE6 = rbind(trainingE,testE))
# h)
cbind(TE1,TE2,TE3,TE4,TE5,TE6)
#Listing every pair of errors, the tuned polynomial kernal has the best training error,and 
#the tuned radial kernal has the second best one in training data;
#For test error, the linear and tuned radial kernals have better performances. 
#Afterall, the tuned radial kernal has the best overall performance basing on both training and test errors.

###################
### Question 02 ###
###################
# b)
set.seed(5082)
attach(Wage)
cv_error = rep(NA,10)
for (i in 1:10){
  polyfit = glm(wage~poly(age,i) ,data=Wage)
  cv_error[i] = cv.glm(data=Wage, glmfit = polyfit, K=10)$delta[1]
}
# c)
plot(1:10,cv_error)
title("CV Errors for Degree 1-10")
(bestd = which.min(cv_error))
legend(x = "topright",legend=c(c("optimal degree:",bestd),c("the cv error:",cv_error[bestd])),cex=.7)
# d)
plot(age,wage)
title("Polynomial Fit with Degree 9 Chosen by C.V")
bestglm = glm(wage~poly(age,bestd) ,data=Wage)
agelims=range(age)
age.grid=seq(from=agelims[1],to=agelims[2],length.out = 100)
pred = predict(bestglm,newdata=list(age=age.grid))
lines(age.grid,pred,lwd=2,col = 2)
# e)
set.seed(5082)
deltas = rep(NA, 12)
for (i in 2:13) {
  Wage$Age.cut = cut(age, i) 
  glmfit = glm(wage ~ Age.cut, data = Wage)
  deltas[i-1] = cv.glm(Wage,glmfit,K=10)$delta[1]
}
# f)
# optimal num of intervals:
(bestCut = which.min(deltas))
plot(1:12,deltas)
title("CV Errors for CUT 1-12")
legend(x = "topright",legend=c(c("optimal cut:",bestCut),c("the cv error:",deltas[bestCut])),cex=.7)
# g)
plot(age,wage)
title("Step Function Using Number of Cuts (7) Chosen by C.V")
bestfit = glm(wage ~ cut(age, bestCut), data = Wage)
age.grid=seq(from=agelims[1],to=agelims[2])
pred = predict(bestfit,list(age=age.grid))
lines(age.grid,pred,col=2,lw =2)

###################
### Question 03 ###
###################
# a)
require(MASS)
attach(Boston)
disrange = range(Boston$dis)
dissamples = seq(from=disrange[1], to=disrange[2], length.out=100)
# b) 
set.seed(5082)
cv_error = rep(NA,10)
plot(dis,nox,xlim = range(dis))
title("Polynomial fit with various degrees of freedom")
for (i in 1:10){
  polyfit = glm(nox~poly(dis,i) ,data=Boston)
  cv_error[i] = cv.glm(data=Boston, glmfit = polyfit, K=10)$delta[1]
  pred = predict(polyfit,list(dis=dissamples))
  lines(dissamples,pred,col = i)
  }
legend(x = "topright",legend = c("Degree 1","Degree 2","Degree 3","Degree 4",
                                 "Degree 5","Degree 6","Degree 7",
                                 "Degree 8","Degree 9","Degree 10"),col = 1:10,lty=1)
# c)
(bestd = which.min(cv_error))
plot(dis,nox,xlim = disrange)
title("Polynomial fit with min cv error at degrees 3")
polyfit = glm(nox~poly(dis,bestd) ,data=Boston)
pred = predict(polyfit,list(dis=dissamples))
lines(dissamples,pred,col = 2,lw =2)
# d)
spline.fit = lm(nox ~ bs(dis, df = 4), data = Boston)
summary(spline.fit)
#i)
#Knots are chosen at location where the data changes faster, cross validation is also another tool chosing number of knots and their location
#ii)
attr(bs(dis,df=4),"knots")
#iii)
spline.pred = predict(spline.fit, list(dis = dissamples))
plot(dis,nox,xlim = disrange,main = "Regression Spline with df = 4")
lines(dissamples, spline.pred, col = 2, lwd = 2)
# e) & d)
plot(dis,nox,xlim = range(dis))
title("Regression splines with various degrees of freedom")
RSS = rep(NA,8)
for(df in 3:10){  
  fit = lm(nox ~ bs(dis, df = df), data = Boston)
  pred = predict(fit, list(dis = dissamples))
  lines(dissamples,pred,col = df)
  RSS[df-2] = summary(fit)$r.squared
  }
legend(x = "topright",legend = c("Df 3","Df 4","Df 5","Df 6","Df 7",
                                 "Df 8","Df 9","Df 10"),col = 3:10,lty=1)
rbind(c(paste("df",3:10)),RSS)
# f)
set.seed(5082)
cv_error = rep(NA, 8)
for (i in 3:10) {
  glm.fit = glm(nox ~ ns(dis, df = i), data = Boston)
  cv_error[i-2] = cv.glm(Boston, glm.fit, K = 10)$delta[1]
} 
(bestDF = which.min(cv_error)+2)
plot(dis,nox,xlim = range(dis))
fit = lm(nox ~ bs(dis, df = bestDF), data = Boston)
pred = predict(fit, list(dis = dissamples))
lines(dissamples,pred,col = 2,lw=2)
title("Regression spline w/ best df (10) chosen with cv")
# g)
set.seed(5082)
fit = smooth.spline(y = Boston$nox,x = jitter(Boston$dis), cv = T) 
bestlam = fit$lambda
fit = smooth.spline(y = nox,x = jitter(dis), lambda = bestlam) 
plot(dis,nox,xlim = range(dis),main = "Smoothing Spline with best lambda(6.9e-05) chosen with cv")
lines(fit,lw = 2,col=2)

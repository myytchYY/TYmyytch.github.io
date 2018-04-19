rm(list=ls())
"Assignment 2 best model"
"Group 2-05"
##############################
### Load required packages ###
##############################
require(ada)
#################
### Read Data ###
#################
mydata<-read.table("Assignment2TrainData.csv",sep=",",header=T)
mydata[,3] <- as.factor(mydata[,3])
dim(mydata)
set.seed(5082)
n <- nrow(mydata)
train <- sample(n, 0.85*n)
trainset <- mydata[train,-1]
testset <- mydata[-train,-1]

set.seed(5082)
bestm = ada(Churn~.,data=trainset,iter=75,bag.frac = 0.05,control=rpart.control(maxdepth=30,cp=0.01,minsplit=20,xval=10))
#> min(result[,8])
#[1] "2539.71885336273"
# i = 0.276

result = c()

for (i in seq(0.01,1,0.01)){
  my.pred <- rep("No", nrow(testset)) #assign each row to no
  pred_temp = predict(bestm,newdata = testset,type = "prob")[,2]
  my.pred[pred_temp>i] <- "Yes" #turn some rows into yes
  FP = sum(testset$Churn!= my.pred & testset$Churn == "No")/ sum(testset$Churn == "No")
  TP = sum(testset$Churn== my.pred & testset$Churn == "Yes")/sum(testset$Churn == "Yes")
  TN = 1- FP
  FN = 1- TP
  cost = 0.73552*FP*1600 + 0.26448*FN*11500 +  (0.26448*1600*0.45 +  (1600+11500)*0.55*0.26448)*TP
  err = mean(testset$Churn != my.pred)
  mytable = table(testset$Churn, my.pred,dnn=c("Actual", "Predicted"))
  outstring = c(i,FP,FN,TP,TN,err,cost)
  result = rbind(result,outstring)
}
colnames(result)=c("cutoff","FP","FN","TP","TN","error.rate","My Expected Cost Per Customer")
(bestcost = min(result[,7]))
(best.cutoff = result[which.min(result[,7]),1])
write.csv(result,file = "Assignment2Costs.csv",sep = ",")

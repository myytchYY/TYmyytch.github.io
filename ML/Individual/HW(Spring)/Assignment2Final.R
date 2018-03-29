rm(list=ls())
"Assignment 2 best model"
"Group 2-05"
##############################
### Load required packages ###
##############################
require(randomForest)
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
calculateCost <- function(mytable){
  totalcost = mytable[1,2]*1600+mytable[2,1]*11500+mytable[2,2]*(1600+11500*.55)
  return(totalcost)
}

set.seed(5082)
bestm = ada(Churn~.,data=trainset,iter=75,bag.frac = 0.05,control=rpart.control(maxdepth=30,cp=0.01,minsplit=20,xval=10))
#> min(result[,8])
#[1] "2539.71885336273"
# i = 0.276

result = c()

for (i in seq(0.06,.8,0.01)){
  my.pred <- rep("No", nrow(testset)) #assign each row to no
  pred_temp = predict(bestm,newdata = testset,type = "prob")[,2]
  my.pred[pred_temp>i] <- "Yes" #turn some rows into yes
  FP = sum(testset$Churn!= my.pred & testset$Churn == "No")/ sum(testset$Churn == "No")
  TP = sum(testset$Churn== my.pred & testset$Churn == "Yes")/sum(testset$Churn == "Yes")
  TN = 1- FP
  FN = 1- TP
  err = mean(testset$Churn != my.pred)
  mytable = table(testset$Churn, my.pred,dnn=c("Actual", "Predicted"))
  outstring = c(i, FP,FN,TP,TN,err,"$3041,52",calculateCost(mytable)/nrow(testset))
  result = rbind(result,outstring)
}
colnames(result)=c("cutoff","FP","FN","TP","TN","error.rate","doNothing cost","cost")
(bestcost = min(result[,8]))
(best.cutoff = result[which.min(result[,8]),1])
write.csv(result,file = "Assignment2.csv",sep = ",")
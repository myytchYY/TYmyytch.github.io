rm(list=ls())
"Assignment 2 best model"
"Group 2-05"
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
needed <- c('rpart',"rattle","splines","boot","randomForest", "pROC", "verification","ada")      
installIfAbsentAndLoad(needed)
####################
### Prepare Data ###
####################
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
##############################
### Load required packages ###
##############################
set.seed(5028)
cutoff = 0.65
mtry = 4
ntree = 204

bestrf= randomForest(Churn~.,data=trainset,mtry=mtry,ntree = ntree,
                     importance=TRUE, na.action=na.roughfix,replace=FALSE,cutoff = c(cutoff,1-cutoff))
pred = predict(bestrf,newdata=testset)
mytable = table(testset$Churn, pred,dnn=c("Actual", "Predicted"))
cost_temp = calculateCost(mytable)/nrow(testset)
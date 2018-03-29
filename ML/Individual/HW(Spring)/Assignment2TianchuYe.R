rm(list=ls())
"Assignment 2 Individual code (Tianchu Ye)"
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

#Prepare data
mydata<-read.table("Assignment2TrainData.csv",sep=",",header=T)
mydata[,3] <- as.factor(mydata[,3])
dim(mydata)
set.seed(5082)
n <- nrow(mydata)
train <- sample(n, 0.85*n)
trainset <- mydata[train,-1]
testset <- mydata[-train,-1] 
#predict no, actural yes
cost_NY = 11500
(cost_nothing = n * 3041.52)
(cost_offerAll = n * 1600 + n*1672.84)
(lowestCost = .26448 * (1600+11500*.55))
bestCost = rep(NA,3)
###############################
#decision tree - Classification
###############################
set.seed(5082)
mytree = rpart(Churn ~ .,data=trainset, method="class")
printcp(mytree)
minxerr <- which.min(mytree$cptable[,"xerror"])
mincp <- mytree$cptable[minxerr,"CP"]
pruned <- prune(mytree,cp=mincp)
fancyRpartPlot(pruned, main="Classification Tree With Minimum C.V. Error")
classT_predict <- predict(pruned, newdata=testset, type="class")
(table1 = table(testset$Churn, classT_predict,dnn=c("Actual", "Predicted")))
cost1 = table1[1,2]*1600+table1[2,1]*cost_NY+table1[2,2]*(1600+11500*.55)
(bestCost[1] = cost1/nrow(testset))
#model:
#min.cp

##############################
#radom forest
##############################
set.seed(5082)
p = ncol(trainset)-1
errors = rep(NA,p)
typeII = rep(NA,p)
bestntree = rep(NA,p)
cutoff = seq(0.1,.4,by = 0.1)
for (t in 1:p){
  myrf = randomForest(Churn~.,data=trainset,mtry=t,ntree = 300,
                  importance=TRUE, na.action=na.roughfix,replace=FALSE) 
  ntree = which.min(myrf$err.rate[,"OOB"])
  cost_temp = c(NA,length(cutoff))
  for (c in cutoff){
  myrf = randomForest(Churn~.,data=trainset,mtry=t,ntree = ntree,
                      importance=TRUE, na.action=na.roughfix,replace=FALSE,cutoff = c(c,1-c)) 
  rf.predict = predict(myrf,newdata = testset,type = "class")
  table2 = table(testset$Churn, rf.predict,dnn=c("Actual", "Predicted"))
  cost_temp[]
  
  errors[t] = (table2[2,1]+table2[1,2])/sum(table2)
  typeII[t] = table2[2,1]/sum(table2[2,])
  bestntree[t] = ntree
}}
#which.min(errors) == which.min(typeII)
best.mtry = which.min(typeII)
best.ntree = bestntree[which.min(typeII)]
myrf = randomForest(Churn~.,data=trainset,mtry=best.mtry,ntree = best.ntree,
                    importance=TRUE, na.action=na.roughfix,replace=FALSE) 
rf.predict = predict(myrf,newdata = testset,type = "class")
table2 = table(testset$Churn, rf.predict,dnn=c("Actual", "Predicted"))
(bestCost[2] =(table2[1,2]*1600+table2[2,1]*cost_NY+table2[2,2]*(1600+11500*.55))/nrow(testset))

#model:
#best.mtry
#best.ntree
##############################
#boosting model
##############################
set.seed(5082)
#optimal iter
iterset = c(10,25,50,75,100,150)
bagfrac = c(0.05,0.1,0.25,0.5,0.75,0.85)
#[i,j]
Costs =matrix(rep(NA,36),ncol = 6,nrow = 6)
for (i in 1:6){
  for (j in 1:6){
    set.seed(5082)
    mybm = ada(Churn~.,data=trainset,iter=iterset[j],bag.frac = bagfrac[i],control=rpart.control(maxdepth=30,cp=0.01,minsplit=20,xval=10))
    pred = predict(mybm,newdata=testset)
    table3 = table(testset$Churn, pred,dnn=c("Actual", "Predicted"))
    Costs[i,j] = (table3[1,2]*1600+table3[2,1]*cost_NY+table3[2,2]*(1600+11500*.55))/nrow(testset)
  }}
#min(Costs) = Costs[1,4]
best.frac = bagfrac[1]
best.iter = iterset[4]
(bestCost[3] =min(Costs))

#################
which.min(bestCost)
#> bestCost
#[1] 2678.969 2645.369 2615.491

#################
set.seed(5028)
cutoff = 0.65
mtry = 4
ntree = 204

bestrf= randomForest(Churn~.,data=trainset,mtry=mtry,ntree = ntree,
                     importance=TRUE, na.action=na.roughfix,replace=FALSE,cutoff = c(cutoff,1-cutoff))
pred = predict(bestrf,newdata=testset)
table3 = table(testset$Churn, pred,dnn=c("Actual", "Predicted"))
cost_temp = (table3[1,2]*1600+table3[2,1]*cost_NY+table3[2,2]*(1600+11500*.55))/nrow(testset)
summary(predict(myrf,newdata =testset,type = "prob"))

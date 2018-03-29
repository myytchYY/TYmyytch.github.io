##############################
### Load required packages ###
##############################
rm(list=ls())
options(warn=-1)
installIfAbsentAndLoad  <-  function(neededVector) {
  if(length(neededVector) > 0) {
    for(thispackage in neededVector) {
      if(! require(thispackage, character.only = T)) {
        install.packages(thispackage)}
      require(thispackage, character.only = T)
    }
  }
}
########packages########
needed <- c("rpart",  #this is the recursive partitioning package
            "rattle", #the fancyRpartPlot and asRules functions at 
                    #the end of this script are in the rattle package
            "ISLR","glmnet")    
installIfAbsentAndLoad(needed)
Hitters <- na.omit(Hitters)[,-c(14,15,20)]
######################
###partition data into training, validate and test subsets (60/20/20)###
set.seed(527)
n <- nrow(Hitters) 
trainrows <- sample(n, 0.6* n) 
validaterows <- sample(setdiff(seq_len(n), trainrows), 0.2* n) 
testrows <- setdiff(setdiff(seq_len(n), trainrows), validaterows)
train <- Hitters[trainrows,]
validate <- Hitters[validaterows,]
test <- Hitters[testrows,]
##############Generate Tree####
rpart<-rpart(Salary ~ .,data=train, method="anova",
             parms=list(split="gini"),
             control=rpart.control(usesurrogate=0, 
                                   maxsurrogate=0,cp=0, minsplit=2,
                                   minbucket=1))
print(rpart)
printcp(rpart)
summary(rpart)
##############Plots####
plot(rpart)
text(rpart, all=TRUE, use.n=TRUE)
title("Training Set's Regression Tree")
fancyRpartPlot(rpart, main="Fancy Plot")
#rules
asRules(rpart)
##############Pruning####
rpart$cptable
plotcp(rpart)
xerr<-rpart$cptable[,"xerror"]
minxerr<-which(xerr==min(xerr))
mincp<-rpart$cptable[minxerr,"CP"]
rpart.prune<-prune(rpart,cp=mincp)
printcp(rpart.prune)
fancyRpartPlot(rpart.prune, main="Pruned Tree")
##############MSE####
predTest <- predict(rpart, newdata=test, type="vector")
tree.mse <- mean((test$Salary - predTest)^2)
predTest.p <- predict(rpart.prune, newdata=test, type="vector")
tree.prune.mse <- mean((test$Salary - predTest.p)^2)
#compare with lasso
x <- as.matrix(Hitters)[,-17]
cv.out <- cv.glmnet(x[trainrows,],train$Salary,alpha = 1)
bestlam <- cv.out$lambda.min
lasso <- glmnet(x[trainrows,],Hitters$Salary[trainrows],alpha = 1)
pred <- predict(lasso,s=bestlam,newx=x[testrows,])
lasso.mse = mean((pred-Hitters$Salary[testrows])^2)
cbind(lasso.mse,tree.prune.mse,tree.mse)

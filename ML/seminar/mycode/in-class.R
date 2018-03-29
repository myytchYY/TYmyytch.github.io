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
needed <- c("rpart","rattle","MASS")    
installIfAbsentAndLoad(needed)
Boston <- na.omit(Boston)
######################
###partition data into training, validate and test subsets (60/20/20)###
set.seed(5028)
n <- nrow(Boston) 
trainrows <- sample(n, 0.6* n) 
validaterows <- sample(setdiff(seq_len(n), trainrows), 0.2* n) 
testrows <- setdiff(setdiff(seq_len(n), trainrows), validaterows)
train <- Boston[trainrows,]
validate <- Boston[validaterows,]
test <- Boston[testrows,]
######################
#1. Build a COMPLETE regression tree using "tax" as response and other variables as predictors
#2. Print out and make sure you understand the complexity table
#3. Prune it, what's your best cp?
#4. Plot your pruned tree
#5. Calculate the test mse for your optimal model.
#See solution in the end of this file















#mymodel <- rpart(tax ~ .,data=train, method="anova",parms=list(split="gini"),control=rpart.control(usesurrogate=0, 
#                      maxsurrogate=0,cp=0,minsplit=2,minbucket=1))
#printcp(mymodel)
#xerr <- mymodel$cptable[,"xerror"]
#minxerr<-which.min(xerr)
#mincp <- mymodel$cptable[minxerr,"CP"]
#pruned <- prune(mymodel,cp=mincp)
#fancyRpartPlot(pruned,main = "Pruned regression tree for tax")
#predTest.p <- predict(pruned, newdata=test, type="vector")
#tree.prune.mse <- mean((test$tax - predTest.p)^2)
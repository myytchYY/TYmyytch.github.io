rm(list = ls())
#Team 2-5

#######################
#Prepare data
#######################
d1=read.table("student-mat.csv",sep=",",header=TRUE)
d2=read.table("student-por.csv",sep=",",header=TRUE)

d3=rbind(d1,d2,by=c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"))

d3 = d3[,-c(31,32)] # delete G1, G2
old_G3 = d3[,31]
newG3 = rep("Pass",length(old_G3))
newG3[old_G3 < 11] <- 'Failed'
mydata = cbind(d3[,-31],newG3)

mydata = na.omit(mydata)
mydata$age = as.numeric(mydata$age)
mydata$absences = as.numeric(mydata$absences)

require(caret)
#splitting data
set.seed(5082)
trainIndex <- createDataPartition(mydata$newG3, p = .8, list = FALSE,times = 1)
trainset <- mydata[ trainIndex,]
testset  <- mydata[-trainIndex,]

############
#boosting
fitControl <- trainControl(method = "repeatedcv",number = 10,repeats = 10)

gbmFit1 <- train(newG3 ~ ., data = trainset , method = "gbm", 
                 trControl = fitControl, verbose = FALSE)
boost.pred <- predict(gbmFit1,testset)
table.b <- table(testset$newG3, boost.pred,dnn=c("Actual", "Predicted"))
table.b
#error rate
mean(testset$newG3 != boost.pred)
# type I error
table.b[1, 2] / sum(table.b[1, ])
# type II error
table.b[2, 1] / sum(table.b[2, ])

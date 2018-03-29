rm(list=ls())
options(warn=-1)   # Supress warning messages
##########################################################################################
installIfAbsentAndLoad <- function(neededVector) {
  for(thispackage in neededVector) {
    if( ! require(thispackage, character.only = T) )
    { install.packages(thispackage)}
    require(thispackage, character.only = T)
  }
}
############################################################
needed <- c( "ISLR", "glmnet")  
installIfAbsentAndLoad(needed)
############################################################
Hitters <- na.omit(Hitters)
x <- model.matrix(Salary ~ ., Hitters)[, -1]    
y <- Hitters$Salary

set.seed(1)
train <- sample(1:nrow(x), nrow(x)/2)
test <- (-train)
y.test <- y[test]

############################################################
ridge.mod <- glmnet(x,y,alpha=0)
############################################################
set.seed(1)
cv.out <- cv.glmnet(x[train,],y[train],alpha=0)
plot(cv.out)
bestlam <- cv.out$lambda.min
bestlam
############################################################
ridge.pred <- predict(ridge.mod,s=bestlam,newx=x[test,])
predict(ridge.mod,type="coefficients",s=bestlam)[1:20,]
###########################################################
ridge.train <- glmnet(x[train,],y[train],alpha = 0)
ridge.pred <- predict(ridge.train,s=0,newx=x[test,],
                      x=x[train,],y=y[train])
mean((ridge.pred-y.test)^2)

ridge.pred <- predict(ridge.train,s=bestlam,newx=x[test,],
                      x=x[train,],y=y[train])
mean((ridge.pred-y.test)^2)
###########################################################

lm <- coef(lm(y~x, subset=train))
glmnet <- predict(ridge.mod,s=0,exact=T,type="coefficients",x=x[train,],
                  y=y[train])[1:20,]
cbind(lm,glmnet)
###########################################################
lambda <- c()
l2 <- c()
for (i in 1:50){
  lambda[i] <- ridge.mod$lambda[i]
  l2[i]<-sqrt(sum(coef(ridge.mod)[-1,i]^2))
}
plot(lambda,l2)
##################
lambda_large<- coef(ridge.mod)[,1]
lambda_small<- coef(ridge.mod)[,50]
cbind(lambda_large,lambda_small)
###########################################################
#Claasification
yclass <- rep("Yes", length(y))
yclass[y < median(y)] <- "No"
yclass <- factor(yclass)
yclass.test <- yclass[test]
##########################################################
#Logstic
train.df <- data.frame(x[train,], "Salary"=yclass[train])
test.df <- data.frame(x[test,], "Salary"=yclass[test])
logistic.mod.class <- glm(Salary ~ ., data=train.df, family="binomial")
logistic.pred.class <- predict(logistic.mod.class,newdata = test.df, type="response")
yhat <- rep("Yes", length(logistic.pred.class))
yhat[logistic.pred.class < .5] <- "No"
error.rate.logistic <- mean(yhat != as.character(yclass.test))
coef_glm <- logistic.mod.class$coefficients
##########################################################
#Ridge
ridge.mod.class <- glmnet(x, yclass, alpha=0, family="binomial")
cv.out.class <- cv.glmnet(x[train, ], yclass[train], alpha=0, family="binomial")
plot(cv.out.class)
bestlam <- cv.out.class$lambda.min
ridge.pred.class <- predict(ridge.mod.class, s=bestlam, newx=x[test, ], type="class")
error.rate.ridge <- mean(ridge.pred.class != yclass.test)
ridge.coefficients <- predict(ridge.mod.class, type="coefficients", s=bestlam)[1:20, ]

##########################################################
cbind(error.rate.logistic,error.rate.ridge)
cbind(coef_glm,ridge.coefficients)

rm(list=ls())
library( "MASS")
title <- "Assignment 2"
name <- "Tianchu Ye (Section 2)"
title
name
###################
### Question 01 ###
###################
set.seed(5072)
x <- rnorm(100,mean = 0, sd = 1)
eps <- rnorm(100,mean = 0, sd = 0.5)
y <- -1 + 0.5 * x + eps
length(y)
#(f)beta_0 is -1, beta_1 is 0.5
plot(x,y,cex = 1.25,ylim = c(-2.5,1),xlab='x', ylab='y', main='Moderate Error in the Population')
##(h)positive relationship, linearity degree and variance are moderate, 
lm.fit <- lm(y~x)
#(j-a)head beta 0 is -1.0029820, head beta 1 is 0.4352255
#(j-b)both are slightly smaller than beta 0 and beta 1; 
abline(lm.fit,lwd = 2, col="black")
abline(a=-1,b=0.5, lwd = 2, col = "red")
legend("bottomright", legend = c("Population", "Least squares"), col=c(2, 1), cex=.75, lty=c(1,1))

lim.fit <- lm(y~poly(x,2))
anova(lim.fit)
anova(lm.fit)
#(o)p-value is small enough to reject H_0

#repeat with less noise
eps2 <-rnorm (100,mean = 0, sd = sqrt(0.1))
y2 <- -1 + .5*x + eps2
#(f_less)beta_0 is -1, beta_1 is 0.5
lm.fit2 <- lm(y2~x)
#(?h_less)positive relationship, high degree of linearity with small variance
#(j-a_less)head beta 0 is -0.9986921, head beta 1 is 0.5219953
#(j-b_less)both are slightly smaller than beta 0 and beta 1;
plot(x,y2,cex = 1.25, xlab='x', ylab='y',main="Less Error in the Population")
abline(lm.fit2,lwd = 2, col = "black")
abline(-1,0.5, lwd = 2, col = "red")
legend("bottomright", legend = c("Population", "Least squares"), col=c(2, 1), cex=.75, lty=c(1,1))

#repeat with higher noise
eps3 <-rnorm (100,mean = 0, sd = sqrt(0.5))
y3 <- -1 + .5*x + eps3
#(f_higher)beta_0 is -1, beta_1 is 0.5
lm.fit3 <- lm(y3~x)
#(?h_higher)positive relationship, low degree of linearity with large amount of variance
#(j-a_higher)head beta 0 is -1.073988, head beta 1 is 0.583202
#(j-b_higher)head beta 0 is slightly smaller while head beta 1 is little larger;
plot(x,y3,cex = 1.25, xlab='x', ylab='y',main="Higher Error in the Population")
abline(lm.fit3,lwd = 2, col = "black")
abline(-1,0.5, lwd = 2, col = "red")
legend("bottomright", legend = c("Population", "Least squares"), col=c(2, 1), cex=.75, lty=c(1,1))

#(r)The population line with the smallest standard diviation of eps set is closest to its regression line
#(cont.)while the eps with largest sd has the largest distance between its population line and regression line

#Construct a 95% confidence interval
confint(lm.fit, level=.95)
confint(lm.fit2, level=.95)
confint(lm.fit3, level=.95)
#(t) The width depends on its mean and variance (standard diviation), so the out put of confidence intervals match
#the pattern as we set up these data; the higher its variance is, the wider its confidence interval

###################
### Question 02 ###
###################
set.seed (5072)
x1 <- runif (100)
x2 <- 0.5 * x1 + rnorm (100) /10
y <- 2 + 2 * x1 + 0.3* x2 + rnorm (100)
#(b)beta_0 is 2, beta_1 is 2, beta_2 is 0.3
cor(y,x1) ^ 2
cor(y,x2) ^ 2 
cor(x2,x1) ^ 2

pairs(~y+x1+x2, main = "y,x1,x2") 
#(e)x2 and x1 has the strongest correlation as 0.84, while cor(y,x1) = .51 and cor(y,x2)=.41.
lm.fit.both <- lm(y~x1+x2)
coef(lm.fit.both)
#(h)Basing on their p-value, except the p-value for y and x2 is not small enough to reject null hypothesis,
#(h cont.)there's no significant evidence to say that x2 has a relationship with y; but for x1&x2, y&x1, the p-value is 
#(h.cont.)small enought to reject the null hypothesis.

#(i)By using anova(), I can reject the null hypothesis that beta1 is 0 since the p-value(< 5e^-8) 
#(cont.) is small enough. But I can't reject the hypothesis that beta2 is 0, since the p-value is large(0.6405)
lm.fit2 <- lm(y~x1)
coef(lm.fit2)
anova(lm.fit2)
#(k) Yes, I can. The p-value from anova() is small enough.
lm.fit3 <- lm(y~x2)
coef(lm.fit3)
anova(lm.fit3)
#(m) Yes, I can. The p-value from anova() is small enough.
#(n) The results contradict, the result in f)-i) is not equivelant to j)-m). It's because that x1 and x2 are not independence, so when we use both to predict y, beta2 is very weak.  
x1 <- c(x1,.1)
x2 <- c(x2,.8)
y <- c(y,6)
rlm.fit <- lm(y~x1+x2)
rlm.fit2 <- lm(y~x1)
rlm.fit3 <- lm(y~x2)
#(q)changes after adding point 101: 
#for fit1, beta2 increases a lot, beta1 decreases about 1 and beta0 only increases slightly;
#for fit2, beta1 decreases little and beta0 increases slightly;
#for fit3, beta1 decreases slightly while beta0 increases a little.
par(mfrow=c(2,2))
plot(rlm.fit)
#Yes it is.
plot(rlm.fit2)
#Yes, it is.
plot(rlm.fit3)
#Only in the residuals vs leverage plot point 101 acts like an outlier.
par(mfrow=c(1,1))

###################
### Question 03 ###
###################
set.seed(5072)
beta0 <- c()
beta1 <- c()
fstat <- c()
pvalue <- c()
for (i in 1:13){
  fit_ <- lm(crim~Boston[,i+1],data = Boston)
  beta0[i] <- coef(fit_)[1]
  beta1[i] <- coef(fit_)[2]
  fstat[i] <- summary(fit_)$fstatistic[1]
  pvalue[i] <- anova(fit_)$'Pr(>F)'[1]
}
predictors <- colnames(Boston[-1])
table <- cbind(predictors,fstat,pvalue,beta0,beta1)
table
#(b) Except "chas", all the other predictors are significantly associated 
#with response at 0.05 level
significantPred <-c()
idx <-1
for (i in 1:13){
  if(as.numeric(table[i,3]) <.05){
    significantPred[idx] <- table[i,1]
    idx <- 1 + idx
  }}
significantPred

par(mfrow=c(3,4))
for (i in 1:12){
  pred <- significantPred[i]
  y <- match(significantPred[i],predictors)
  plot(y=Boston$crim,x= Boston[,y+1],main = significantPred[i],xlab = 'x')
  abline(a = beta0[y] , b = beta1[y],lwd = 3, col="red")
}
par(mfrow=c(1,1))
#(d)
fit_multi <- lm(crim~.,data = Boston)
table_multi <- coef(summary(fit_multi))
#(e)
significantPred_multi <-c()
idx <-1
for (i in 1:13){ 
  if(table_multi[i,4] <.05){
    significantPred_multi[idx] <- rownames(table_multi)[i]
    idx <- 1 + idx
  }}
significantPred_multi
#(f) Because the multiple axis has a smaller range comparing to simple, multiple should be more accurate than simple regression.
plot(x = table[,5], y = coef(fit_multi)[-1], xlab = "simple", ylab = "Multiple")
f_poly <- c()
t_poly <- c()
for(i in 1:12)
{
  n <- match(significantPred[i],colnames(Boston))
  fit_poly <- lm(crim~poly(Boston[,n],3),data = Boston)
  anova_ <- anova(fit_poly,lm(crim~Boston[,n],data = Boston))
  f_poly[i] <- anova_[2,5]
  t_poly[i] <- anova_[2,6]
}
table_poly <- cbind(significantPred,f_poly,t_poly)
colnames(table_poly) <- c('predictor','fstat','pvalueOfFstat')
table_poly <- table_poly[order(as.numeric(table_poly[,3])),]
table_poly
#(g) Except 'black', other predictors in the table has a p-value that is small enough to reject the null hypothesis.
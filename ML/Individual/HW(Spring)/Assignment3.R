rm(list=ls())
"Assignment 3"
"Tianchu Ye (Section 2)"
###################
### Question 01 ###
###################
#a)
pr.out=prcomp(USArrests, scale=TRUE,center = TRUE)
pr.var=pr.out$sdev^2
pve=pr.var/sum(pr.var)
#b)
scaled = scale(USArrests,center = TRUE)
z = c()
for (i in 1:p){z[i] = sum((scaled%*%pr.out$rotation[,i])^2)}
bottom = sum((scaled - mean(scaled))^2)
pve_m = z/bottom
#check
rbind(pve,pve_m)
###################
### Question 02 ###
###################
centered = scale(USArrests,center = TRUE)
corD = (1-cor(t(centered)))
corD = corD[lower.tri(corD)]
eucD = as.matrix(dist(centered)^2)
eucD = eucD[lower.tri(eucD)]
summary(corD/eucD)
###################
### Question 03 ###
###################
#a)
set.seed(5082)
n <- 20 ; p <- 50 
x1 <- matrix(rnorm(n*p), nrow=n, ncol=p)
x2 <- matrix(rnorm(n*p), nrow=n, ncol=p)
x3 <- matrix(rnorm(n*p), nrow=n, ncol=p)
for(i in 1:n){
  x1[i,] <- x1[i,] + rep(1, p)
  x2[i,] <- x2[i,] + rep(-1, p)
  x3[i,] <- x3[i,] + c(rep(+1, p / 2), rep(-1, p / 2))
}
x.values <- rbind(x1, x2, x3)
#b)
y.values <- c(rep(1,n), rep(2,n), rep(3,n)) # the "true" class labels of the points.
#c)
pr=prcomp(x.values, scale=TRUE,center = TRUE)
plot(pr$x[,1:2],col = c(1,2,3),main = "Q3.c - PCA")
legend(x = "topright",c("x1","x2","x3"),col = c(1,2,3),pch = 1)
#d)
mycluster <- kmeans(x.values, 3, nstart =20)
table(mycluster$cluster, y.values)
#each "true" class is correctly distinguished from other classes
#e)
mycluster <- kmeans(x.values, 4, nstart =20)
table(mycluster$cluster, y.values)
#true class "2" is splited evenly to two classes
#f)
mycluster <- kmeans(x.values, 2, nstart =20)
table(mycluster$cluster, y.values)
#true class "2" and "3" are combined to one class
#g)
PCAed = pr$x[,1:2]
newCluster = kmeans(PCAed,3,nstart = 20)
table(newCluster$cluster, y.values)
#Again, the "true" classes are identified correctly
#h)
scaledCluster <- kmeans(scale(x.values), 3, nstart =20)
table(scaledCluster$cluster, y.values)
#Again, the "true" classes are identified correctly
  
library(optrees,igraph)
#original model
nodes <- 1:8
arcs <- matrix(c(1,2,20,1,3,15,2,5,15,5,2,15,
                 2,4,10,3,4,13,4,3,13,3,6,15,3,7,10,
                 4,7,12,5,6,7,6,5,7,4,5,10,6,7,8,
                 7,6,8,5,8,10,6,8,8,7,8,10),
                byrow = T,ncol = 3)
(maxFlowFordFulkerson(nodes,arcs,directed = T)$max.flow)

#Sensitive analysis

# The maxFlowFordFulkerson() doesn't work porperly in this sensitive analysis,
# so I use graph.maxflow() from package igraph in the loop

myMaxFlow <- c()
for (k in 1:10){
arcs <- matrix(c(1,2,20*k,1,3,15*k,2,5,15,5,2,15,
                 2,4,10,3,4,13,4,3,13,3,6,15,3,7,10,
                 4,7,12,5,6,7,6,5,7,4,5,10,6,7,8,
                 7,6,8,5,8,10*k,6,8,8*k,7,8,10*k),
               byrow = T,ncol = 3)
g <- graph_from_data_frame(arcs[,1:2])
myMaxFlow[k] <- graph.maxflow(g,source=V(g)["1"], target=V(g)["8"], capacity=arcs[,3])$value}
#result for sensitive analysis
(limit_k = which.max(myMaxFlow))
(max(myMaxFlow))
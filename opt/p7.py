# -*- coding: utf-8 -*-
"""
Created on Wed Dec 05 20:32:11 2017

@author: tianc
"""
import MySQLdb as mySQL

numDC = 10
numStore = 1100

db= mySQL.connect(user='root',passwd= 'root',host= 'localhost',db='finalexam')
c = db.cursor()

c.execute("select capacity from dc")
capacity = []
for i in range(numDC):
    capacity.append(int("%s"%c.fetchone()))
    
c.execute("select requirements from store")
demand = []
for i in range(numStore):
    demand.append(int("%s"%c.fetchone()))
    
c.execute("select dc_id,store_id, mileage from mileage")
distance = {}
for i in range(numDC*numStore):
    row = c.fetchone()
    distance[int("%s"%row[0]),int("%s"%row[1])] = float("%s"%row[2])
from gurobipy import *

m = Model("dc_store")
m.ModelSense = GRB.MAXIMIZE
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

# Set up decision variables (amount_ij and binary variables b_ij, i for dc, j for stores)
dvars1 = {}
dvars2 = {}
for i in range(numDC):
    for j in range(numStore):
        dvars1[i,j] = m.addVar(vtype=GRB.CONTINUOUS,name="amount"+str(i)+str(j),lb=0.0,ub = capacity[i])

for i in range(numDC):
    for j in range(numStore):
         dvars2[i,j] = m.addVar(vtype=GRB.BINARY,name='b'+str(i)+str(j), lb=0.0,ub = 1.0)

#Update model to include variables
m.update()

# Binary constraints & Supply = Demand
for i in range(numStore):
    store = str(i)
    dcs = []
    amounts = []
    for key in dvars2:
        if key[-1] == i:
            dcs.append(dvars2[key])
    m.addConstr(quicksum((dcs[j] for j in range(len(dcs)))),GRB.EQUAL, 1,"One DC for store" + store)
    for key in dvars1:
        if key[-1] == i:
            amounts.append(dvars1[key])
    m.addConstr(quicksum((amounts[k] for k in range(len(amounts)))),GRB.EQUAL,demand[i],"Demend supplied store"+store)

# dc Capacity
for i in range(numDC):
    dc = str(i)
    supplys = []
    for key in dvars1:
        if key[-2] == i:
            supplys.append(dvars1[key])
    m.addConstr(quicksum(supplys[j] for j in range(len(supplys))),GRB.LESS_EQUAL, capacity[i],"Capacity" +dc)
    
# amount match binary
for i in range(numDC):
    for j in range(numStore):
        m.addConstr(12000*dvars2[(i,j)],GRB.GREATER_EQUAL,dvars1[(i,j)], "Match"+str(i))  # 12000 = capacity of DCs
    
# Set objective function
fixCost = 200* quicksum(dvars1[(i,j)] for i in range(numDC) for j in range(numStore))
unitCost = 0.75* quicksum(distance[i,j] * dvars1[(i,j)]  for i in range(numDC) for j in range(numStore))
m.setObjective(fixCost+unitCost, GRB.MINIMIZE)

m.update()
m.optimize()

store_dc = {}
if m.status == GRB.Status.OPTIMAL:
    varX = []
    for var in m.getVars():
        varX.append(var.x)
        if var.x > 0:
            print "Variable Name = %s, Optimal Value = %s" % (var.varName, var.x)  
            if var.varName[0] == "b":
                store_dc[int(var.varName[2:])] = int(var.varName[1])
    print "Objective value is " + str(m.objVal)
else:
    print "No solution found."
# write into mySQL:
for key in store_dc:
    c.execute("Insert into results values ('%s', '%s')",(store_dc[key],key))
db.commit()

db.close()
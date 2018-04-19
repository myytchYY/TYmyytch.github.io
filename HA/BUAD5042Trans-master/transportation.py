# -*- coding: utf-8 -*-
"""
Created on Thu Apr 05 17:22:09 2018

@author: tianc
"""
def trans(dist, dcs, stores_vol):

    my_team_or_name = "tianchuYe"
    result = []

    dcCap = dcs.copy()
    dcIds = dcCap.keys()    
    stores = {} #vol,driver, rounded difference between nearest two dcs
    for item in stores_vol:
        stores[item[0]] = [item[1]]
        numDriver = item[1] / 4000.0
        stores[item[0]].append(numDriver)
        diff = [dist[(i,item[0])] for i in dcIds]
        diff.sort()
        roundD = round((diff[1]-diff[0])*numDriver,-1)
        stores[item[0]].append(roundD)
    
    options = [[p,dist[p]*stores[p[1]][1]] for p in dist.keys()]
    options.sort(key = lambda x:(round(x[1],-2),-stores[x[0][1]][2],x[1]),reverse = True)       
    added = []
    lostPair = []
    #dcs: vol,door,driver
    while len(added) < len(stores_vol) and options:
        temp = options.pop()[0]
        dc= temp[0]; store = temp[1]
        if store not in added:
            old = dcCap[dc] ; storeCap = stores[store]
            new = (old[0]-storeCap[0], old[1]-1,old[2]- storeCap[1])
            if new[0]>0.0 and new[2]>0.0 and new[1]>0:
                added.append(store)
                result.append((store,dc))
                dcCap[dc] = new
        else:
            lostPair.append((store,dc))
    return my_team_or_name, result
    
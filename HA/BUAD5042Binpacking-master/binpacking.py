# -*- coding: utf-8 -*-
"""
Created on Mon Mar 19 15:57:44 2018

@author: tianc
"""

def binpack(articles,bin_cap):
    """ You write your heuristic bin packing algorithm in this function using the argument values that are passed
             articles: a dictionary of the items to be loaded into the bins: the key is the article id and the value is the article volume
             bin_cap: the capacity of each (identical) bin (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             my_team_number_or_name: if this is a team assignment then set this variable equal to an integer representing your team number;
                                     if this is an indivdual assignment then set this variable to a string with you name
             bin_contents: this is a list containing keys (integers) of the items you want to include in the knapsack
                           The integers refer to keys in the items dictionary. 
   """
        
    my_team_number_or_name = "tianchuYe"    # always return this variable as the first item
    bin_contents = []    # use this list document the article ids for the contents of 
                         # each bin, the contents of each is to be listed in a sub-list

    item_list = [[k,float(articles[k])] for k in articles.keys()]
    item_list.sort(key = lambda x:x[1])
    currBin = [[[],0.0]]
    while len(item_list)>=1:
        #currBin.sort(key = lambda x:-x[1])
        item = item_list.pop()
        vol = item[1]
        added = False
        for b in currBin:
            if vol+b[1] <= bin_cap:
                b[0].append(item[0])
                b[1] +=vol
                added = True
                break
        if not added: 
            currBin.append([[item[0]],vol])
    for b in currBin:
        bin_contents.append(b[0])      
            
    return my_team_number_or_name, bin_contents       # use this return statement when you have items to load in the knapsack




#heap
def bin_heap():
    import heapq
    item_list = [(-float(articles[k]),k) for k in articles.keys()]
    heapq.heapify(item_list)
    currBin = [[[],0.0]]
    while len(item_list)>=1:
        item = heapq.heappop(item_list)
        vol = -item[0]
        added = False
        for b in currBin:
            if vol+b[1] <= bin_cap:
                b[0].append(item[1])
                b[1] +=vol
                added = True
                break
        if not added: 
            currBin.append([[item[1]],vol])
    for b in currBin:
        bin_contents.append(b[0])    





# -*- coding: utf-8 -*-
"""
Created on Fri Mar 16 10:48:37 2018

@author: tianc
"""

def load_knapsack(things,knapsack_cap):
    """ You write your heuristic knapsack algorithm in this function using the argument values that are passed
             items: is a dictionary of the items no yet loaded into the knapsack
             knapsack_cap: the capacity of the knapsack (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             my_team_number_or_name: if this is a team assignment then set this variable equal to an integer representing your team number;
                                     if this is an indivdual assignment then set this variable to a string with you name
            items_to_pack: this is a list containing keys (integers) of the items you want to include in the knapsack
                           The integers refer to keys in the items dictionary. 
   """
        
    my_team_number_or_name = "tianchuYe"    # always return this variable as the first item
    items_to_pack = []    # use this list for the indices of the items you load into the knapsack
    load = 0.0            # use this variable to keep track of how much volume is already loaded into the backpack
    value = 0.0           # value in knapsack   
    
    for i in range(0,3):
        item_list = [[k,things[k],round(things[k][1]/float(things[k][0]),i)] for k in things.keys()]
        for item1 in item_list:
            current_pack = [item1[0]]
            currentValue = item1[1][1]
            currentload = item1[1][0]
            newList = item_list[:]
            newList.remove(item1)
            newList.sort(key = lambda x:(x[2],x[1][1]),reverse = True)
            for item2 in newList:
                newload = currentload + item2[1][0]
                if(newload <=knapsack_cap):
                    current_pack.append(item2[0])
                    currentValue += item2[1][1]
                    currentload = newload
                    if (currentload == knapsack_cap): 
                        break
            if value < currentValue:
                value = currentValue
                items_to_pack = current_pack
            
    return my_team_number_or_name, items_to_pack       # use this return statement when you have items to load in the knapsack

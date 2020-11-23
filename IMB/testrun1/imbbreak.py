#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import numpy as np

x=open("pandas.csv","r")
lines=x.readlines()


df=pd.read_csv("pandas.csv")
df.to_excel("imb.xlsx",sheet_name="IMB Eagle")

tests=list(df.test.unique())
tests.remove('test')
print(tests)
heads={}
for t in tests:
    k=0
    #print(t)
    for l in lines:
        if l.find(t) > -1:
            p=lines[k-1]
            heads[t]=p.strip()
            #print(p)
            break
        k=k+1
#print(heads)
            
            

# We create a dictionary of dataframes with tests as the keys.
bonk={}
for w in tests :
    x=pd.DataFrame(df.loc[df.test==w].copy())
    bonk[w]=x
    bonk[w].columns=heads[w].split(",")
        
# Remove the extra columns from pingpong and barrier.
for x in ['a','b','c','d','e','f','g'] :
    bonk['Barrier'] = bonk['Barrier'].drop(x, 1)
for x in ['b','c','d','e','f','g'] :
    bonk['Pingpong'] = bonk['Pingpong'].drop(x, 1)

# If we don't want to work with the dictionary we can break out entires.
# This is general procedure that should work with all dictionaries.
for w in bonk.keys() :
    astr="WHAT=bonk['WHAT']"
    astr=astr.replace('WHAT',w)
    exec(astr)



if True :
    for w in tests :
        print(w)
        print(bonk[w])

if True :
    for w in tests :
        bonk[w].to_csv(w+".csv")

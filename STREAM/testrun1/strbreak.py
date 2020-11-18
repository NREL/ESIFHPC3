#!/usr/bin/env python
# coding: utf-8
#pip install pandas
#pip install openpyxl

import pandas as pd


# Get our data
df=pd.read_csv("pandas.csv")
header=df.columns

# Save as xlsx
df.to_excel("stream.xlsx",sheet_name="stream Eagle")

tests=list(df.test.unique())
print(tests)

# Create a dictionary of dfs, one for each test
bonk={}
for w in tests :
    bonk[w]=pd.DataFrame(df.loc[df.test==w])
    bonk[w].columns = header

# If we don't want to work with the dictionary we can break out entires.
# This is general procedure that should work with all dictionaries.
for w in bonk.keys() :
    print(w)
    #print(bonk[w])
    astr="WHAT=bonk['WHAT']"
    astr=astr.replace('WHAT',w)
    #print(astr,"\n")
    exec(astr)

if False:
    print(Add)
    print(Copy)
    print(Scale)
    print(Triad)


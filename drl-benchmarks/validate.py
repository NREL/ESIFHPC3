#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import numpy as np
import sys
import os

# change this line to write output files after validation or do it on the command line
write_files=False

startdir=os.getcwd()
headdir=sys.argv[1]
print("Validating " + headdir)
try:
    os.chdir(headdir+"/breakout-dqn")
except:
    print("not valid, breakout-dqn not found")
    sys.exit(-1)

if len(sys.argv) > 2:
    if sys.argv[2] == "True" :
        write_files=True
    if sys.argv[2] == "False" :
        write_files=False

try:
    stuff=os.listdir('.')
except:
    print("not valid, could not list files")
    sys.exit(-1)

gotdqn=""
gotexp=""
for s in stuff:
    x=s.find("DQN_Breakout")
    if x > -1 :
        gotdqn=s
    x=s.find("experiment_state")
    if x > -1 :
        gotexp=s
if len(gotdqn) == 0 or len(gotexp) == 0 :
    print("not valid, DQN_Breakout* or experiment_state* not found")
    sys.exit(-1)
    
try:
    os.chdir(gotdqn)
    stuff=os.listdir('.')
except:
    print("not valid, could not get listing from DQN_Breakout")
    sys.exit(-1)

files=["events.out.tfevents","params.pkl","result.json","params.json","progress.csv"]
k=0
for s in stuff:
    for f in files:
        if s.find(f) > -1 :
            k=k+1 
if k < 5:
    print("not valid, could not get files in DQN_Breakout")
    sys.exit(-1)

try:         
    d0=pd.read_csv("progress.csv")
    d0[['training_iteration','episode_reward_mean','time_total_s']]
    d0_time=np.array(d0['time_total_s'])
    d0_reward=np.array(d0['episode_reward_mean'])
    d0_it=np.array(d0['training_iteration'])
except:
    print("not valid, could not read progress.csv")
    sys.exit(-1)

if d0_time[-1] < 7200.0 :
    print("not valid, did not run for 7200 seconds")
    sys.exit(-1)


fit=np.polyfit(d0_time,d0_reward,deg=1)
a=fit[0]
b=fit[1]
if a <= 0:
    print("not valid, did not make progress")
    sys.exit(-1)

print(headdir+" validates. Saving files.")

if write_files:
    print("Saving files.")
    out0=pd.DataFrame(d0[['training_iteration','episode_reward_mean','time_total_s']])
# change the next two lines as needed 
    l1="As-is"
    l2="Standard 0 GPU"
    out0.insert(0, 'Optimization', l1)
    out0.insert(0, 'Node Description', l2)
    os.chdir(startdir)
    out0.to_csv(headdir+".csv",index=False)
    out0.to_excel(headdir+".xlsx",index=False,sheet_name='breakout-dqn')





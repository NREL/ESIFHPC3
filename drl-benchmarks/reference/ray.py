#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import numpy as np
d0=pd.read_csv("zero.csv")
d1=pd.read_csv("one.csv")
d2=pd.read_csv("two.csv")


# In[ ]:


d0[['training_iteration','episode_reward_mean','time_total_s']]

d1[['training_iteration','episode_reward_mean','time_total_s']]

d2[['training_iteration','episode_reward_mean','time_total_s']]


# In[ ]:


d0_time=np.array(d0['time_total_s'])
d0_reward=np.array(d0['episode_reward_mean'])
d0_it=np.array(d0['training_iteration'])

d1_time=np.array(d1['time_total_s'])
d1_reward=np.array(d1['episode_reward_mean'])
d1_it=np.array(d1['training_iteration'])

d2_time=np.array(d2['time_total_s'])
d2_reward=np.array(d2['episode_reward_mean'])
d2_it=np.array(d2['training_iteration'])


# In[ ]:


doplot=True


# In[ ]:


if doplot :
    import sys
    import os
    try:
        get_ipython().run_line_magic('matplotlib', 'inline')
    except:
        pass
    os.getcwd()
    #sys.path.append("/Users/tkaiser2/bin")
    sys.path.append(os.getcwd())
    from plsub import myplot


# In[ ]:


if doplot :
    myplot(bl="Time (seconds) ",sl="reward_mean",topl="Eagle breakout-dqn",sets=[[d0_time,d0_reward,"CPU"],[d1_time,d1_reward,"1 GPU"],[d2_time,d2_reward,"2 GPUs"]])


# In[ ]:


if doplot :
    myplot(bl="Time (seconds) ",sl="Interation",topl="Eagle breakout-dqn",sets=[[d0_time,d0_it,"CPU"],[d1_time,d1_it,"1 GPU"],[d2_time,d2_it,"2 GPUs"]])


# In[ ]:


out0=pd.DataFrame(d0[['training_iteration','episode_reward_mean','time_total_s']])
out0.insert(0, 'Optimization', "As-is")
out0.insert(0, 'GPUs', "0")
out0.insert(0, 'Node Description', "Standard")


# In[ ]:


out1=pd.DataFrame(d1[['training_iteration','episode_reward_mean','time_total_s']])
out1.insert(0, 'Optimization', "As-is")
out1.insert(0, 'GPUs', "1")
out1.insert(0, 'Node Description', "Standard")


# In[ ]:


out2=pd.DataFrame(d2[['training_iteration','episode_reward_mean','time_total_s']])
out2.insert(0, 'Optimization', "As-is")
out2.insert(0, 'GPUs', "2")
out2.insert(0, 'Node Description', "Standard")


# In[ ]:


total=pd.concat([out0,out1,out2])


# In[ ]:


total.to_csv("total.cvs",index=False)
total.to_excel("total.xlsx",index=False,sheet_name='Eagle breakout-dqn')


# In[ ]:





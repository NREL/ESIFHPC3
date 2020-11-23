#!/usr/bin/env python
# coding: utf-8

import io
def sprint(*args, **kwargs):
    sio = io.StringIO()
    print(*args, **kwargs, file=sio)
    return sio.getvalue()
    

tab1=open("tab1.csv","w")
header="node_class,system,Code,test,cores,nodes,tpn,size,Metric"
tab1.write(header+"\n")
# In[ ]:
def test4(a,b,c,d):
# this can happen if the code runs out of memory
# here we just replace the messages with a ?
    try: 
      float(a) 
    except : 
      a="?"
    try: 
      float(b) 
    except : 
      b="?"
    try: 
      float(c) 
    except : 
      c="?"
    try: 
      float(d) 
    except : 
      d="?"
    return (a,b,c,d)

#set the title for this output
title="Standard,Reference,As-is code"
if not('get_ipython' in dir()) :
    from sys import argv
    if len(argv) > 1 :
        title=""
        for x in argv[1:] :
            title=title+" "+x
        title=title[1:]    
#print(title)
[node_class,system,optimization]=title.split(",")
indat="rawdat"
f=open(indat,"r")
dat=f.readlines()
val=open(indat+".val","w")
tmp=""
for l in dat:
    if l.find("Running") == 0 :
        if len(tmp) > 0:
            val.write("At least one test did not call MPI_Finalize - validation failed\n")
            val.write(tmp+"\n")
            tmp=l.strip()
        else:
            tmp=l.strip()
    if len(tmp) > 0  and  l.find("Final") > 0:
        val.write(tmp+"\t"+l)
        tmp=""
if len(tmp) > 0:
        val.write("At least one test did not call MPI_Finalize - validation failed")

val.close()
#Clean up our data, remove comments and blank lines
cleaned=[]
for d in dat:
    if len(d.strip()) > 0:
        if d[0] != "#" :
            cleaned.append(d)
dat=cleaned

# Group tests for different sizes on a single line
single=True
dosplit=True

#Set delim to either tab or comma
delim=","
#delim="\t"


# In[ ]:


tests=['Pingpong']
maxhead="t[usec]"
for test in tests:
    lines=[]
    k=0
    # find the lines that mark the beginning of a test
    for l in dat:
        n=l.find("Running "+test)
        if n > -1:
            lines.append(k)
        k=k+1
    cases=[2,3]
    if single :
        print("node_class","system","optimization","test","cores","nodes","tpn","size",maxhead,"b","c","d","e","f","g",sep=delim)
    else:
        pass
    for i in lines :
        head=dat[i].split()
        cores=head[3]
        nodes=head[5]
        tpn=head[9]
        for case in cases :
                res=dat[i+case]
                res=res.split()
                # this sould not happen, maybe the job crashed
                if len(res) < 3: 
                    print("error,")
                    break
                try:
                    size=res[0]
                    max=res[2]
                except:
                    print("error,")
                    break
                if single:
                    if case == cases[0] :
                        cores,nodes,tpn,size=test4(cores,nodes,tpn,size)
                        print(node_class,system,optimization,test,cores,nodes,tpn,size,max,-1,-1,-1,-1,-1,-1,sep=delim)
                        xout=sprint("%s,%s,%s,%s,%s,%s,%s,%s,%s" % (node_class,system,optimization,test,cores,nodes,tpn,size,max))
                        tab1.write(xout)
                    else:
                        cores,nodes,tpn,size=test4(cores,nodes,tpn,size)
                        print(node_class,system,optimization,test,cores,nodes,tpn,size,max,-1,-1,-1,-1,-1,-1,sep=delim)
                        xout=sprint("%s,%s,%s,%s,%s,%s,%s,%s,%s" % (node_class,system,optimization,test,cores,nodes,tpn,size,max))
                        tab1.write(xout)
                else:
                    pass




# In[ ]:
if dosplit : print()

tests=['Barrier']
for test in tests:
    lines=[]
    k=0
    # find the lines that mark the beginning of a test
    for l in dat:
        n=l.find("Running "+test)
        if n > -1:
            lines.append(k)
        k=k+1
    print("node_class","system","optimization","test","cores","nodes","tpn","t_max[usec]","a","b","c","d","e","f","g",sep=delim)
    for i in lines :
            head=dat[i].split()
            cores=head[3]
            nodes=head[5]
            tpn=head[9]
            res=dat[i+2]
            #print(res)
            res=res.split()
            res=res[2]
            #(cores,nodes,tpn,size)=test4(cores,nodes,tpn,size)
            print(node_class,system,optimization,test,cores,nodes,tpn,res,-1,-1,-1,-1,-1,-1,-1,sep=delim)
            xout=sprint("%s,%s,%s,%s,%s,%s,%s,%s,%s" % (node_class,system,optimization,test,cores,nodes,tpn," ",res))
            tab1.write(xout)


# In[ ]:

if dosplit : print()

tests="Alltoall Allgather Allreduce Sendrecv Exchange Uniband Biband"
tests=tests.split()

for test in tests:
    maxhead="t_max[usec]"
    if test == "Uniband" :
        maxhead="Msg/sec"
    if test == "Biband" :
        maxhead="Msg/sec"
    #if you run more cases this line will need to be changed
    cases=[2,3,4,5]
    #print(test)
    lines=[]
    k=0
    # find the lines that mark the beginning of a test
    for l in dat:
        n=l.find("Running "+test)
        if n > -1:
            lines.append(k)
        k=k+1
    #print(lines)
    if single :
        buf=sprint("node_class","system","optimization","test","cores","nodes","tpn","size",maxhead,sep=delim,end=delim)
        buf.rstrip(",")
        for case in cases[1:]:
            buf=buf+sprint("size",maxhead,sep=delim,end=delim)
        buf=buf.rstrip(",")
        print(buf)
    else:
        pass
    for i in lines :
        head=dat[i].split()
        cores=head[3]
        nodes=head[5]
        tpn=head[9]
        for case in cases :
                #print("where",i,i+case)
                res=dat[i+case]
                #print("res",res)
                res=res.split()
                # this sould not happen, maybe the job crashed
                if len(res) < 4: 
                    print("error,")
                    break
                try:
                    #print(res)
                    size=res[0]
                    max=res[3] 
                    if test.find("band") > 0 :
                        max=res[3]
                except:
                    print("error,")
                    break
                if single:
                    if case == cases[0] :
                        cores,nodes,tpn,size=test4(cores,nodes,tpn,size)
                        if size == "?" : max="?"
                        buf=sprint(node_class,system,optimization,test,cores,nodes,tpn,size,max,sep=delim,end=delim)
                        xout=sprint("%s,%s,%s,%s,%s,%s,%s,%s,%s" % (node_class,system,optimization,test,cores,nodes,tpn,size,max))
                        tab1.write(xout)
                    else:
                        size,max,d1,d2=test4(size,max,"1","1")
                        if size == "?" : max="?"
                        buf=buf+sprint(size,max,sep=delim,end=delim)
                        xout=sprint("%s,%s,%s,%s,%s,%s,%s,%s,%s" % (node_class,system,optimization,test,cores,nodes,tpn,size,max))
                        tab1.write(xout)
                    if case == cases[-1]:
                        buf=buf.rstrip(",")
                        print(buf)
                else:
                    pass
    if dosplit : print()


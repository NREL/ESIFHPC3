#!/usr/bin/env python

import re
import sys

RE1 = re.compile('Summary of all tests')
RE2 = re.compile('write')
RE3 = re.compile('read')

def get_data(line):
   t = line.split()
   mean_MiB = float(t[3])
   stddev_MiB = float(t[4])
   return (mean_MiB, stddev_MiB)

datadict = {}
f = open(sys.argv[1], 'r')
data = f.readlines()
f.close()
test = 0; done = True
for i in data:
   if RE1.match(i):
      test += 1
      done = False
      continue
   if RE2.match(i) and done == False:
      datadict['write' + str(test)] = get_data(i)
   if RE3.match(i) and done == False:
      datadict['read' + str(test)] = get_data(i)
      done = True

nodeclasses = ['Standard', 'Large Data', 'Accelerated']
filesystems = ['ScratchFS', 'ProjectFS', 'local']
systems = ['Reference', 'Test', 'Offered']
codes = ['As-is', 'Optimized']
conditions = ['1 - 100 ranks', '2 - peak 1node shared', '3 - peak 1node local', '4 - peak Nnode shared']
tests = {1:'1 - POSIX Streaming 1segment', 2:'2 - MPI Streaming 1segment', \
         3:'3 - HDF5 Streaming 1segment', 4:'4 - HDF5 Streaming 10segment', \
         5:'5 - POSIX Random', 6:'6 - HDF5 Small Transfer'}
parameters = {1:'100 MB block; 1 MB transfer', 2:'1 GB block; 1 MB transfer', \
         3:'1 GB block; 1 MB transfer', 4:'100 MB block; 1 MB transfer', \
         5:'10 MB block; 2 kB transfer', 6:'10 MB block; 2 kB transfer'}

print('Node Class,File system,System,Code,Condition,Test,Ranks,Nodes,Mean Read (MiB/s),Stddev Read (MiB/s),Mean Write (MiB/s),Stddev Write (MiB/s),Parameters')
for nodeclass in nodeclasses:
   for filesystem in filesystems:
      if nodeclass != 'Large Data' and filesystem == 'local': continue
      for system in systems:
         for code in codes:
            for condition in conditions:
               if condition == '1 - 100 ranks': ranks = '100'
               else: ranks = ''
               if filesystem == 'local' and condition != '3 - peak 1node local': continue
               if filesystem != 'local' and condition == '3 - peak 1node local': continue
               for test in tests:
                  if system == 'Reference':
                     if nodeclass != 'Standard': continue
                     elif filesystem != 'ScratchFS': continue
                     elif code != 'As-is': continue
                     elif condition != '1 - 100 ranks': continue
                     print(f"{nodeclass},{filesystem},{system},{code},{condition},{tests[test]},{ranks},,{datadict['read'+str(test)][0]},{datadict['read'+str(test)][1]},{datadict['write'+str(test)][0]},{datadict['write'+str(test)][1]},{parameters[test]}")
                  elif condition == '1 - 100 ranks' and nodeclass != 'Standard': continue
                  elif condition != '3 - peak 1node local' and filesystem == 'local': continue
                  #elif condition != '3 - peak 1node local' and nodeclass != 'Large Data': continue
                  elif condition == '4 - peak Nnode shared' and nodeclass == 'Large Data': continue
                  else:
                     print(f"{nodeclass},{filesystem},{system},{code},{condition},{tests[test]},{ranks},,,,,,{parameters[test]}")

#!/usr/bin/env python

import re
import sys
import glob

REbfsmin = re.compile('bfs  min_time:')
REbfsQ1 = re.compile('bfs  firstquartile_time:')
REbfsmedian = re.compile('bfs  median_time:')
REbfsQ3 = re.compile('bfs  thirdquartile_time:')
REbfsmax = re.compile('bfs  max_time:')
REssspmin = re.compile('sssp min_time:')
REssspQ1 = re.compile('sssp firstquartile_time:')
REssspmedian = re.compile('sssp median_time:')
REssspQ3 = re.compile('sssp thirdquartile_time:')
REssspmax = re.compile('sssp max_time:')
RE_logfile = re.compile('(?P<test>[a-z]+)_(?P<ranks>[0-9]+)r(?P<nodes>[0-9]+)n.out')

REdict = {REbfsmin:('BFS','min'), REbfsQ1:('BFS','Q1'), \
          REbfsmedian:('BFS','median'), REbfsQ3:('BFS','Q3'), \
          REbfsmax:('BFS', 'max'), REssspmin:('SSSP','min'), \
          REssspQ1:('SSSP','Q1'), REssspmedian:('SSSP','median'), \
          REssspQ3:('SSSP','Q3'), REssspmax:('SSSP','max')}

headings = ['Node Class', 'System', 'Code', 'Problem Size', 'Test', '# Ranks', '# Nodes', '# Physical Cores', 'Min', 'First Quartile', 'Median', 'Third Quartile', 'Max']
nodeclasses = ['Standard', 'Large Data', 'Accelerated']
systems = ['Reference', 'Test', 'Offered']
codes = ['As-is', 'Optimized']

for i in headings[:-1]: print(f'{i},', end='')
print(headings[-1])
for nodeclass in nodeclasses:
   for system in systems:
      for code in codes:
         if system == 'Reference':
            if nodeclass == 'Standard' and code == 'As-is':
               timings = {'BFS': {'min':None, 'Q1':None, 'median':None, 'Q3':None, 'max':None}, \
                          'SSSP': {'min':None, 'Q1':None, 'median':None, 'Q3':None, 'max':None}}
               filelist = glob.glob('*.out')
               for filename in filelist:
                  t = RE_logfile.match(filename)
                  testsize, ranks, nodes = (t.group('test'), t.group('ranks'), t.group('nodes'))
                  with open(filename, 'r') as f:
                     data = f.readlines()
                  for i in data:
                     for j in list(REdict.keys()):
                        if j.match(i):
                           timings[REdict[j][0]][REdict[j][1]] = float(i.rstrip().split()[-1])
                  for i in ['BFS', 'SSSP']:
                     print(f"{nodeclass},{system},{code},{testsize},{i},{ranks},{nodes},{ranks},{timings[i]['min']},{timings[i]['Q1']},{timings[i]['median']},{timings[i]['Q3']},{timings[i]['max']}")
            else: continue
         else:
            for i in ['BFS', 'SSSP']:
               print(f"{nodeclass},{system},{code},toy,{i},,,,,,,,")

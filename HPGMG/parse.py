#!/usr/bin/env python

from collections import namedtuple

Reference = namedtuple('Reference', ['nodes', 'cores', 'threads', 'DOF'])
nodeclasses = ['Standard', 'Accelerated']
systems = ['Reference', 'Test', 'Offered']
codes = ['As-is', 'Optimized']
reference_data = {64:Reference(2,64,64,1.18e7), 128:Reference(4,128,128,1.98e7), 256:Reference(8,256,256,3.4e7), \
   512:Reference(15,512,512,7.49e7), 1024:Reference(29,1024,1024,1.23e8), 8928:Reference(248,8928,8928,8.85e8), \
   17856:Reference(496,17856,17856,1.52e9)}
rank_counts = [64, 128, 256, 512, 1024, 'N/4', 'N/2', 'N']

print('Node Class,System,Code,# Compute Units,# Cores,# MPI Ranks,# Execution Threads,DOF/s')
for nodeclass in nodeclasses:
   for system in systems:
      for code in codes:
         # First the reference data
         if system == 'Reference':
            if nodeclass == 'Accelerated': continue
            elif code == 'Optimized': continue
            else:
               for ranks in reference_data:
                  print(f'{nodeclass},{system},{code},{reference_data[ranks].nodes},{reference_data[ranks].cores},{ranks},{reference_data[ranks].threads},{reference_data[ranks].DOF:.2e}')
         else:
            for rank_count in rank_counts:
               if type(rank_count) == type(1):
                  print(f"{nodeclass},{system},{code},,,{rank_count},,")
               else:
                  print(f"{nodeclass},{system},{code},{rank_count},,,,")


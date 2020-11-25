#!/usr/bin/env python

nodeclasses = ['Standard']
systems = ['Reference', 'Test', 'Offered']
codes = ['As-is', 'Optimized']
meshes = [256, 512]
ranks  = {192:6, 384:12, 768:24, 1536:48, 3072:96, 6144:192}
ref_times = {256:{192:2626.54, 384:1246.66, 768:682.64, 1536:367.34, 3072:222.70, 6144:204.10}, 512:{768:20056.80,1536:10899.50,3072:6237.54, 6144:3272.32}}

print('Capability,System,Code,Mesh size,# Compute Units,# MPI Ranks,# Execution Threads, # Physical Cores, Wallclock time (s)')
for nodeclass in nodeclasses:
   for system in systems:
      for code in codes:
         for mesh in meshes:
            for rank in ranks:
               if system == 'Reference':
                  if code == 'Optimized': continue
                  if rank < 768 and mesh == 512: continue
                  else: print(f"{nodeclass},{system},{code},{mesh},{ranks[rank]},{rank},{rank},{rank},{ref_times[mesh][rank]}")
               else:
                  print(f'{nodeclass},{system},{code},{mesh},,{rank},,,')

#!/usr/bin/env python

nodeclasses = ['Accelerated']
systems = ['Reference', 'Test', 'Offered']
codes = ['As-is', 'Optimized']
meshes = [256, 512]
nodes = [4, 8, 16, 32, 64, 128]
ranksperGPU = [1, 2]
ref_times = {256:{4:1319.02, 8:808.46, 16:541.72}, 512:{4:8743.84,8:4628.36,16:2463.38}}

print('Node class,System,Code,Mesh size,# Compute Units,# MPI Ranks,# GPUs,Wallclock time (s)')
for nodeclass in nodeclasses:
   for system in systems:
      for code in codes:
         for mesh in meshes:
            for node in nodes:
               for rankperGPU in ranksperGPU:
                  if system == 'Reference':
                     if node > 16: continue
                     if rankperGPU == 1: continue
                     else: print(f"{nodeclass},{system},{code},{mesh},{node},{2*node},{2},{ref_times[mesh][node]}")
                  else:
                     print(f'{nodeclass},{system},{code},{mesh},{node},,{rankperGPU},,')

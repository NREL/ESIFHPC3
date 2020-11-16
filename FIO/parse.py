#!/usr/bin/env python

import re
from sys import exit

RE1 = re.compile('   READ: bw=(?P<read_bandwidth>[0-9]+\.?[0-9]?)(?P<prefix>[KMG])iB/s')
RE2 = re.compile('  WRITE: bw=(?P<write_bandwidth>[0-9]+\.?[0-9]?)(?P<prefix>[KMG])iB/s')

abbreviations = { \
   'buffered': 'buf', \
   'unbuffered': 'un', \
   'sequential': 'seq', \
   'random': 'rand', \
   'mixed': 'm', \
   'read': 'r', \
   'write': 'w' }

unit_conversions = { \
   'K': 1./1024, 'M': 1., 'G': 1024 \
}

print('Node Class,File system,System,As-is or Optimized,Buffering,Randomness,Read or write,Block size,File size,# Processes,Read BW (MiB/s),Write BW (MiB/s)')
for buffering in ['buffered', 'unbuffered']:
   for randomness in ['sequential', 'random']:
      for rw in ['read', 'write', 'mixed']:
         for bs in ['4k', '64k', '1m'] :
            for size in ['1m', '64m', '1g']:
               for processes in [1, 18, 35]:
                  filestring = f"{abbreviations[buffering]}{abbreviations[randomness]}{abbreviations[rw]}.bs{bs}.size{size}.{processes}"
                  readBW = None
                  writeBW = None
                  f = open(filestring, 'r')
                  data = f.readlines()
                  f.close()
                  for line in data:
                     t = RE1.match(line)
                     if t:
                        readBW = float(t.group('read_bandwidth')) * unit_conversions[t.group('prefix')]
                     t2 = RE2.match(line)
                     if t2:
                        writeBW = float(t2.group('write_bandwidth')) * unit_conversions[t2.group('prefix')]
                  for nodeclass in ['Standard', 'Accelerated', 'Large Data']:
                     for system in ['Reference', 'Test', 'Offered']:
                        for code in ['As-is', 'Optimized']:
                           for fs in ['Home', 'Projects', 'Scratch']:
                              if nodeclass == 'Standard' and system == 'Reference' and code == 'As-is' and fs == 'Scratch':
                                 print(f'{nodeclass},{fs},{system},{code},{buffering},{randomness},{rw},{bs},{size},{processes},{readBW},{writeBW}')
                              elif (system == 'Reference' and code == 'Optimized') or (system == 'Reference' and code == 'As-is' and (fs != 'Scratch' or nodeclass != 'Standard')):
                                 continue
                              else:
                                 if processes == 18:
                                    print(f'{nodeclass},{fs},{system},{code},{buffering},{randomness},{rw},{bs},{size}, N/2,,')
                                 elif processes == 35:
                                    print(f'{nodeclass},{fs},{system},{code},{buffering},{randomness},{rw},{bs},{size}, N-1,,')
                                 else:
                                    print(f'{nodeclass},{fs},{system},{code},{buffering},{randomness},{rw},{bs},{size},{processes},,')
                             

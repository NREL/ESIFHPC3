#!/usr/bin/env python
  
from collections import namedtuple

data = namedtuple('data', ['Write', 'Compute', 'Total'])
nodeclasses = ['Standard']
systems = ['Reference', 'Test', 'Offered']
codes = ['As-is', 'Optimized']
io = ['Netcdf', 'PNetcdf']
iorankscores = {'Netcdf':{60:60, 120:120, 240:240, 480:480, 960:960, 1440:1440}, 'PNetcdf':{60:84, 120:144, 240:272, 480:512, 960:992, 1440:1472}}
tests = ['Write','Compute','Total']

ref_times = {'Netcdf':{60:data(1790.67, 8767.67, 10956.84), 120:data(1793.94,5190.53,7218.78), \
240:data(1945.50,2880.52,4975.76), 480:data(1953.03,1549.10,3607.65), 960:data(1828.35,751.74,2658.84), \
1440:data(1837.85,364.34,2285.14)}, 'PNetcdf':{60:data(23.89, 9316.44, 9789.27), 120:data(17.04, 3803.35, 4083.29), \
240: data(10.61, 2859.29, 3029.58), 480: data(13.15, 1449.61, 1572.98), 960: data(10.25, 754.75, 869.44), 1440: data(9.47, 363.71, 469.80)}}
#ref_times_write = {'Netcdf':{60:1790.67, 120:1793.94, 240:1945.50, 480:1953.03, 960:1828.35, 1440:1837.85}, 'PNetcdf':{60:23.89,120:17.04,240:10.61,480:13.15,960:10.25,1440:9.47}}
#ref_times_compute = {'Netcdf':{60:8767.67, 120:5190.53, 240:2880.52, 480:1549.10, 960:751.74, 1440:364.34}, 'PNetcdf':{60:9316.44,120:3803.35,240:2859.29,480:1449.61,960:754.75,1440:363.71}}
#ref_times_total = {'Netcdf':{60:10956.84, 120:7218.78, 240:4975.76, 480:3607.65, 960:2658.84, 1440:2285.14}, 'PNetcdf':{60:9789.27,120:4083.29,240:3029.58,480:1572.98,960:869.44,1440:469.80}}
 
print('Capability,System,Code Type,I/O Type,# MPI Ranks,# Cores,Timing Class,Time(s)')
for nodeclass in nodeclasses:
   for system in systems:
      for code in codes:
         for io_type in io:
            for rank in iorankscores['Netcdf']:
               for timing_class in tests:
                  if system == 'Reference':
                     if code == 'Optimized': continue
                     #print(f"{nodeclass},{system},{code},{io_type},{rank},{iorankscores[io_type][rank]},{ref_times[io_type][rank].timing_class}")
                     print(f"{nodeclass},{system},{code},{io_type},{rank},{iorankscores[io_type][rank]},{timing_class},{getattr(ref_times[io_type][rank], timing_class)}")
                  else:
                     print(f'{nodeclass},{system},{code},{io_type},{rank},,,')

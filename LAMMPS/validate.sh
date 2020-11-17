#!/bin/bash
# Usage: ./validate.sh PATH/LAMMPS_OUTPUT_FILE NREL_RESULTS_Path

grep -A 101 'Step ' $1 | awk '{print $1,$2,$5}' > 'thermo.dat'
#tail -n 1 $1 > 'walltime.dat'

# Compare to NREL supplied results and form the *relative* RMS deviation between NREL-supplied and vendor-produced results for the temperature and total energy time series
paste -d' ' $2/NREL_thermo.dat thermo.dat | awk 'BEGIN{count = 0; t2 = 0.0; t_avg = 0.0; e2 = 0.0; e_avg = 0.0}{if ($1!="Step") {
tav = tav + $5;
eav = eav + $6;
t2 = t2 + ($2-$5)**2;
e2 = e2 + ($3-$6)**2; 
count = count + 1}}
END{
tav = tav/count;
eav = eav/count;
t_rms = sqrt(t2/count)/tav;
e_rms = sqrt(e2/count)/eav;
if (t_rms < 1.0e-3 && e_rms < 1.0e-5) {
  validate_string = "run validated"
} else {
  validate_string = "run not validated"
}
rms_string = sprintf("Average T and E: %e %e \nRelative RMS errors: %e %e",tav,eav,t_rms, e_rms);print rms_string; print validate_string}' > rms_errors.dat
cat rms_errors.dat

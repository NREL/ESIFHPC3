#!/bin/bash
grep nproc $1 > $1.result
grep @ $1 >> $1.result

grep nproc ref.log > ref.log.result
grep @ ref.log >> ref.log.result

#Must use python3
python validate.py $1.result ref.log.result



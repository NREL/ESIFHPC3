#!/bin/bash
export OUTFILE=out.dat
#The utility script jlines takes input and joins lines together.  In this case "2".  We end up with 
#with a nice table of data.  Then we use sed to remove unwanted text and then awk to print the columns
#we want.
cat $OUTFILE | egrep "OMP_NUM_THREADS=|Copy"  | ./jlines 2  | sed "s/ OMP_NUM_THREADS=//" | sed "s/Copy://"  | awk '{print $1 " " $2}' > Copy
cat $OUTFILE | egrep "OMP_NUM_THREADS=|Add"   | ./jlines 2  | sed "s/ OMP_NUM_THREADS=//" | sed "s/Add://"   | awk '{print $1 " " $2}' > Add
cat $OUTFILE | egrep "OMP_NUM_THREADS=|Scale" | ./jlines 2  | sed "s/ OMP_NUM_THREADS=//" | sed "s/Scale://" | awk '{print $1 " " $2}' > Scale
cat $OUTFILE | egrep "OMP_NUM_THREADS=|Triad" | ./jlines 2  | sed "s/ OMP_NUM_THREADS=//" | sed "s/Triad://" | awk '{print $1 " " $2}' > Triad

#Make headers for the files
for test in Copy Add Scale Triad ; do
  echo $test > $test.tab
  echo "Threads	Rate (MB/s)	Avg time	Min time	Max time" >> $test.tab
done

#Split the files based on the number of threads/processors
export MAXTHREADS=36
for test in Copy Add Scale Triad ; do
  split -l $MAXTHREADS  $test $test.
done

#Paste them back together making a table, one for each test
paste Add.a*   | awk '{print $1 "\t" $2 "\t" $4 "\t" $6 "\t" $8}' >> Add.tab
paste Copy.a*  | awk '{print $1 "\t" $2 "\t" $4 "\t" $6 "\t" $8}' >> Copy.tab
paste Scale.a* | awk '{print $1 "\t" $2 "\t" $4 "\t" $6 "\t" $8}' >> Scale.tab
paste Triad.a* | awk '{print $1 "\t" $2 "\t" $4 "\t" $6 "\t" $8}' >> Triad.tab

#Now we will put all of the tests together in a single file.
#First we make a header which gives the node type.  The default
#is "Test System,  Reference, As-is code" but it can be read from the command line.
#If you enter a system and code description on the command line they
#should be seperated by a comma ",".
if [[ $# -eq 0 ]]  ; then
	echo "Standard,Reference,As-is code" >STREAM.tab
else
	echo $@  >STREAM.tab
fi

export nodetype=`head -1 STREAM.tab`
echo $nodetype

for test in Copy Add Scale Triad ; do
  cat $test.tab >> STREAM.tab
done

#Create a CSV version of the TAB file
sed "s/\t/,/g" STREAM.tab > STREAM.csv

for test in Copy Add Scale Triad ; do
  echo -e "$nodetype\n$(cat $test.tab)" > $test.tab
  sed "s/\t/,/g" $test.tab > $test.csv
done


echo "Node type,System,Optimization,test,Threads,Rate (MB/s),Avg time,Min time,Max time" > pandas.csv
for test in Copy Add Scale Triad ; do
   tail --lines=+4 $test.csv | sed s/^/"$nodetype,$test,"/ >> pandas.csv
done

#At this point we are done. We have the files STREAM.tab and STREAM.csv, pandas.csv
#but below we create some additional files that might be useful for 
#analysis and ploting.  Actually, it is kind of silly.  These files
#are created and then deleted in the last 5 lines of this script unless
#you change the "true" to "false" as indicated.  

DO_EXTRAS=true
if $DO_EXTRAS ; then

# Here we rename files for plotting
  for test in Copy Add Scale Triad ; do
    mv $test.aa CC-$test-default
    mv $test.ab FC-$test-default
    mv $test.ac CC-$test-large
    mv $test.ad FC-$test-large
  done
fi

#We are not required to keep all the files. Here we delete
#the temporary files and the extras created above.  
#Change true to false if you want to keep the files.
RM_EXTRAS=true
if $RM_EXTRAS ; then
  rm Copy* Scale* Add* Triad*
  rm CC* FC*
fi

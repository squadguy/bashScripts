#!/bin/bash

#Declare directory to be searched and where to write results to
searchDir=~/Sandbox/scripts/findDups 
outFile=~/Sandbox/findDupsDir/found.txt
dupsFile=~/Sandbox/findDupsDir/dups.txt

#Ensure we are in the search directory
cd $searchDir

echo Changing directories

#Get list of all current directory non-hidden contents 
#Pipe to awk and print file size and name
#Include space delimiter
#Send data to output file
ls -l | awk '{print NR-1" "$5" "$9}' > $outFile


#Get and set variable to number of lines in outFile
numLines=`wc -l < $outFile`
realNumLines=$((numLines+1))
OUTTERCTR=2
INNERCTR=3


while [ $OUTTERCTR -lt $realNumLines ]; do
	compareFileSize=`cat $outFile | sed ''$OUTTERCTR'q;d' | awk '{print $2}'`
	compareFileName=`cat $outFile | sed ''$OUTTERCTR'q;d' | awk '{print $3}'`

	while [ "$INNERCTR" -lt "$realNumLines" ]; do
		withFileSize=`cat $outFile | sed ''$INNERCTR'q;d' | awk '{print $2}'`
		withFileName=`cat $outFile | sed ''$INNERCTR'q;d' | awk '{print $3}'`
		echo comparing $compareFileName with $withFileName
		if [ "$compareFileSize" -eq "$withFileSize" ]
		then
			echo $compareFileName is equal to $withFileName
			echo writing to possible dups files
			echo
			echo $compareFileName >> $dupsFile	
		else
			echo $compareFileName is not equal to $withFileName
			echo
		fi
		let INNERCTR=INNERCTR+1
	done
	let OUTTERCTR=OUTTERCTR+1
	let INNERCTR=OUTTERCTR+1
	
done

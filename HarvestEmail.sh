#!/bin/bash
#  HarvestEmail.sh - general email harvester utility
#    requires at least 2 arguments
#       $1 is Name of file to which we append harvested emails
#       $2-$n are the names of files in which we search for emails
#

StartTime=`date`
# echo initial startup date and time for logging
echo "}} HarvestEmail.sh initiated at $StartTime"

# set the initial state of ReturnFlag as 0 or no errors encountered.
ReturnFlag="0"

# create counter for emails
let emailcount=0

if [ $# -lt 2 ];  # Do we have less than the required 2 arguments
then   # not enough arguments so show usage text
    # Usage
    echo "}}"
    echo "** Error: HarvestEmail.sh requires at least 2 arguments"
    echo "}}"
    echo "}} Usage - bash HarvestEmail.sh (target-file) (file-1) ... (file-n)"
    echo "}}    target-file is the folder to which harvested emails will be added"
    echo "}}    file-1 thru file-n are one or more files from which to harvest emails"
    echo "}}"
    
    ReturnFlag="1"

else   # we have enough arguments
    # create TargetFile variable
    TargetFile=$1
    
    # Shift, so we are left with a list of files to search
    shift
    
    # echo command line arguments for logging
    echo "}}   Target File to append harvested emails is $TargetFile"
    
    #loop through remaining arguments and echo
    for searchfile in "$@"
    do
        # confirm this searchfile exists before searching
        if [ -f $searchfile ]
        then # searchfile exists
            echo "}}   Searching $searchfile"
            
            # harvest emails from searchfile
            grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' $searchfile >> $TargetFile
            
            grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' $searchfile | wc -l > countfile.txt
            
            let filecount=`cat countfile.txt`
            let emailcount=$emailcount+$filecount
            
            echo "}}     $filecount emails harvested"
        else # searchfile does not exist
            echo "**  File to be searched  $searchfile does not exist"
            ReturnFlag="2"                  
        fi
    done
fi
echo "}}   Total emails harvested was $emailcount"  
echo "}}   HarvestEmail.sh returns $ReturnFlag"
echo "}} HarvestEmail.sh terminated at `date`"
exit $ReturnFlag
 
 
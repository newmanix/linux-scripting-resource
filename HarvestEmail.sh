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
            
            # begin harvest emails from searchfile
            # create temp copy for processing
            cp $searchfile workfile1.txt -f
            
            if [ $? -eq 0 ]
            then # successfully copied this searchfile to workfile.txt
            
                # first remove and replace any common mungings to make valid emails
                sed -i -- 's/\[@\]/@/g' workfile1.txt
                sed -i -- 's/\.at\./@/gI' workfile1.txt
                sed -i -- 's/ at /@/gI' workfile1.txt
                sed -i -- 's/ (@) /@/g' workfile1.txt
                sed -i -- 's/(@)/@/g' workfile1.txt
                sed -i -- 's/ [@] /@/g' workfile1.txt
                sed -i -- 's/ (at) /@/gI' workfile1.txt
                sed -i -- 's/(at)/@/gI' workfile1.txt
                sed -i -- 's/&#064;/@/g' workfile1.txt
                
                sed -i -- 's/\.dot\././gI' workfile1.txt
                sed -i -- 's/ dot /./gI' workfile1.txt
                sed -i -- 's/ (dot) /./gI' workfile1.txt
                sed -i -- 's/(dot)/./gI' workfile1.txt
                sed -i -- 's/\.invalid//gI' workfile1.txt

                # last remove any common "REMOVEME" mungings
                sed -i -- 's/\.REMOVETHIS\././gI' workfile1.txt
                sed -i -- 's/\.REMOVETHIS[:space:]?//gI' workfile1.txt
                sed -i -- 's/REMOVETHIS//gI' workfile1.txt
                sed -i -- 's/\.REMOVEME\././gI' workfile1.txt
                sed -i -- 's/\.REMOVEME[:space:]?//gI' workfile1.txt
                sed -i -- 's/REMOVEME//gI' workfile1.txt
                sed -i -- 's/\.REMOVE\././gI' workfile1.txt
                sed -i -- 's/.REMOVE[:space:]?//gI' workfile1.txt
                sed -i -- 's/REMOVE//gI' workfile1.txt

                # then grep for valid emails
                grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' workfile1.txt > workfile2.txt
                
                cat workfile2.txt >> $TargetFile

                # use the let command to do math
                let filecount=`cat workfile2.txt | wc -w`
                let emailcount=$emailcount+$filecount
                
                echo "}}     $filecount emails harvested"
            else # error returned when copying searchfile
                echo "** File IO ERROR searching file $searchfile"
                ReturnFlag="1"  
            fi
        else # searchfile does not exist
            echo "**  ERROR File $searchfile does not exist"
            ReturnFlag="2"                  
        fi
    done
fi

# cleanup temp files
rm -f workfile1.txt workfile2.txt

echo "}}   Total emails harvested was $emailcount"  
echo "}}   HarvestEmail.sh returns errorlevel $ReturnFlag"
echo "}} HarvestEmail.sh terminated at `date`"
exit $ReturnFlag
 
 
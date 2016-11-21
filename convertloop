#!/bin/bash                                                                                        

# begins a for loop
# for every file name that ends in .png                                                                                                    
for FILENAME in *.png
# do the following                                                                             
do
    # create a variable called NEWFILENAME and make it the old FILENAME 
    # with .jpg substituted for .png
    # See documentation below for an explanation of Shell Parameter Expansion                                                                                                
    NEWFILENAME="${FILENAME/%.png/.jpg}"
		# this prints to the screen (echo) while allowing escape characters like tab (-e)
		# the old file name and the new file name, so you can see that it's working 
		# \t is a tab, so that the old file name and new file name line up neatly
		echo -e "Old name: $FILENAME\t" "New name: $NEWFILENAME"  
    # this is the convert command we used above, converting the file with the old name
    # to the jpg file and giving it the new name
    # && says that if and only if the previous command ran properly, do the next thing                           
    convert "$FILENAME" "$NEWFILENAME" && \
        # move the thing called NEWFILENAME to the converted_images folder 
        mv "$NEWFILENAME" converted_images/ && \
        # remove the old file                                                      
        rm "$FILENAME"
# done ends the do command, defining the point at which a single loop stops
# and then, because this is a loop, it does it to every file that ends in .png in the directory
done

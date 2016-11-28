#!/bin/bash
# This script is created to go recursively into folders detect files and create Par2 files to protect data
# Created by Leela Ross - leela@leela-ross.com 28/11/2016

# Get running directory
root=$(pwd)
counter=1

# Start loop based on tree output
tree -dfi | while read line; do
        pdir="$line"
        dir=$(echo $pdir | sed -e "s/.//" -e "s/'/'/") # This is to remove the ./ from each line for when we tack the absolute path on
        if [[ "$root$dir" == "$root" ]] && (($counter > 2)) # Detecting if the loop is completed by waiting for the blank line from tree
        then
                exit 1
        fi
        cd "$root$dir"
        find=$(find . -mindepth 1 -maxdepth 1 -name "*.*") # seeing if there are any files in the directory
        if [[ "$find" != "" ]]
        then
                if [ -e "$root$dir/.mfolder.par2" ] # Detecting to see if a par2 files already exists
                then # if par2 exists then run a repair
                        pwd
                        par2repair -q -a .mfolder
                else # if no par2 file create one
                        pwd
                        par2create -q -a .mfolder *
                fi
        fi
        let counter=counter+1 # loop counter so the script doesn't stop on the first directory
done

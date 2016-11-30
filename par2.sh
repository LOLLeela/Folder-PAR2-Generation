#!/bin/bash
# This script is created to go recursively into folders,  
# detect files and create Par2 files to protect data
# Created by Leela Ross - leela@leela-ross.com 28/11/2016
# Thanks to Reddit Users whetu and 1or2. 

# Declare Vars
declare currentdir
declare cleandir
declare fsroot
declare findresult
declare counter

# Get running directory
fsroot=$PWD
counter=1

# Start loop based on tree output
tree -dfi | while read -r line; do
  currentdir="$line"
  # This is to remove the ./ from each line for when we tack the absolute path on
  cleandir=$(sed -e "s/.//" -e "s/'/'/" <<< "$currentdir") 

  # Detecting if the loop is completed by waiting for the blank line from tree
  if [[ "$fsroot$cleandir" == "$fsroot" ]] && ((counter > 2)); then
    exit 1
  fi

  cd "$fsroot$cleandir" || exit 1

  # seeing if there are any files in the directory
  findresult=$(find . -mindepth 1 -maxdepth 1 -name "*.*") 
  if [[ "$findresult" != "" ]]; then
    # Detecting to see if a par2 files already exists
    # if par2 exists then run a repair
    if [[ -e "$fsroot$cleandir/.mfolder.par2" ]]; then
      pwd
      par2repair -q -a .mfolder
    # if no par2 file create one
    else 
      pwd
      par2create -q -a .mfolder ./*
    fi
  fi
  # loop counter so the script doesn't stop on the first directory
  let counter++ 
done

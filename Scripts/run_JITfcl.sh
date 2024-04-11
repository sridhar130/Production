#!/bin/bash
echo "$(date) starting fclless submission"
echo "args: $@"
echo "fname=$fname"
echo "pwd=$PWD"
echo "ls of default dir"
ls -al

#IND=$( echo $fname | awk -F. '{print $5}' | sed 's/^0*//' )
IND=$(echo $fname | awk -F. '{print $5}')
IND=$((10#$IND)) // Remove leading zeros except the first one.
TARF=$(ls $CONDOR_DIR_INPUT/*.tar)
echo "IND=$IND TARF=$TARF"
mu2ejobfcl --jobdef $TARF --index $IND --default-proto root --default-loc tape > temp.fcl
echo "$(date) submit_fclless temp.fcl content"
cat temp.fcl
echo "$(date) submit_fclless starting mu2e -c temp.fcl"
mu2e -c temp.fcl
echo "$(date) submit_fclless ending mu2e -c temp.fcl"

#echo "$(date) find parents"
#mu2ejobiodetail --jobdef $TARF --index $IND --inputs > $CONDOR_DIR_INPUT/parents.txt
#echo "$(date) head of parents.txt"
#head $CONDOR_DIR_INPUT/parents.txt
#echo $CONDOR_DIR_INPUT
#pwd
#ls -ltr $CONDOR_DIR_INPUT/

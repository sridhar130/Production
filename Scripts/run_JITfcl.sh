#!/bin/bash
# Sctipt to run on the exisiting par file and index dataset
echo "$(date) starting fclless submission"
echo "args: $@"
echo "fname=$fname"
echo "pwd=$PWD"
echo "ls of default dir"
ls -al

cmd="ls -ltr $CONDOR_DIR_INPUT"
echo "Running: $cmd"
$cmd

#IND=$( echo $fname | awk -F. '{print $5}' | sed 's/^0*//' )
IND=$(echo $fname | awk -F. '{print $5}')
IND=$((10#$IND)) # Remove leading zeros except the first one.
TARF=$(ls $CONDOR_DIR_INPUT/*.tar)
echo "IND=$IND TARF=$TARF"
FCL=${TARF::-6}.${IND}.fcl
mu2ejobfcl --jobdef $TARF --index $IND --default-proto root --default-loc tape > ${FCL}
echo "$(date) submit_fclless ${FCL} content"
cat ${FCL}
echo "$(date) submit_fclless starting loggedMu2e.sh -c ${FCL}"
loggedMu2e.sh -c ${FCL}
echo "$(date) submit_fclless ending loggedMu2e.sh -c ${FCL}"


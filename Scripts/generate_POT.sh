#!/bin/bash

# placeholder for the MDC name and version
VERSION=""
NAME=""

# Function: Print a help message.
usage() {                                 
  echo "Usage: $0 [ -n NAME ] [ -v VERSION ] " 1>&2 
}
# Function: Exit with error.
exit_abnormal() {                         
  usage
  exit 1
}
# Loop: Get the next option;
while getopts ":n:v:" options; do         
  case "${options}" in                    
    n)                                  # If the option is n,
      NAME=${OPTARG}                      # set $NAME to specified value.
      ;;
    v)                                    # If the option is v,
      VERSION=${OPTARG}                     # Set $VERSION to specified value.
      ;;
    :)                                    # If expected argument omitted:
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    *)                                    # If unknown (any other) option:
      exit_abnormal                       # Exit abnormally.
      ;;
  esac
done

# Run: run generate fcl with input from user
generate_fcl --dsconf=${NAME}${VERSION} --dsowner=mu2e --run-number=1201 --events-per-job=2000 --njobs=1000 --include Production/JobConfig/beam/POT.fcl --description=POT
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf POT_${NAME}${VERSION}_$dirname
  mv $dirname POT_${NAME}${VERSION}_$dirname
 fi
done


#!/bin/bash

# usage: bash Scripts/gen_S1.sh -c MDC2020 -v u -o mu2e -r 1202 -e 2000 -j 1000 -d POT -f input.fcl

# placeholder for the MDC name and version
VERSION=""
CAMPAIGN=""

# default arguments set, user can override 
OWNER=mu2e
RUN=1202
EVENTS=2000
NJOBS=1000
DESC=POT
FCL="template.fcl"

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

# Function: Print a help message.
usage() {
   echo "Usage: $0
  [ -c name of the campaign ]
  [ -v campaign version of S1 input ]
  [ -o owner (default: mu2e) ]
  [ -r run number ]
  [ -e N events/job ]
  [ -j N jobs ]
  [ -d explicit list of DS stop files ]
  [ -f input FCL file ]
  [ -s explicit simjob setup (required) ]
  e.g. ./Scripts/gen_S1.sh -c MDC2020 -v u -o mu2e -r 1202 -e 2000 -j 1000 -d POT -f Production/JobConfig/beam/POT.fcl -s /cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/MDC2020ae/setup.sh" 1>&2
}

# Loop: Get the next option;
while getopts ":c:v:o:r:e:j:d:f:s:" options; do
  case "${options}" in
    c)                                    # If the option is n,
      CAMPAIGN=${OPTARG}                  # set $CAMPAIGN to specified value.
      ;;
    v)                                    # If the option is v,
      VERSION=${OPTARG}                   # Set $VERSION to specified value.
      ;;
    o)                                    # If the option is o,
      OWNER=${OPTARG}                     # Set $OWNER to specified value.
      ;;
    r)                                    # If the option is r,
      RUN=${OPTARG}                       # Set $RUN to specified value.
      ;;
    e)                                    # If the option is e,
      EVENTS=${OPTARG}                    # Set $EVENTS to specified value.
      ;;
    j)                                    # If the option is j,
      NJOBS=${OPTARG}                      # Set $JOBS to specified value.
      ;;
    d)                                    # If the option is d,
      DESC=${OPTARG}                      # Set $DESC to specified value.
      ;;
    f)                                    # If the option is f,
      FCL=${OPTARG}                       # Set $FCL to specified value.
      ;;
    s)                                    # SimJob setup required
      SETUP=${OPTARG}
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

# Test: run a test to check the SimJob for this campaign verion exists TODO 
DIR=/cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/${CAMPAIGN}${VERSION}
if [ -d "$DIR" ];
  then
    echo "$DIR directory exists."
  else
    echo "$DIR directory does not exist."
    exit 1
fi

DSCONF=${CAMPAIGN}${VERSION}

# Run the command with the specified options
echo "Running mu2ejobdef command with the following options:"
echo "  Campaign: $CAMPAIGN"
echo "  DSCONF: $OUTCONF"
echo "  Version: $VERSION"
echo "  Owner: $OWNER"
echo "  Run number: $RUN"
echo "  Events per job: $EVENTS"
echo "  Jobs: $NJOBS"
echo "  Description: $DESC"
echo "  FCL file: $FCL"
echo "  Setup file: $SETUP"

cmd="mu2ejobdef --verbose --setup ${SETUP} --dsconf ${DSCONF} --dsowner ${OWNER} --run-number=${RUN} --events-per-job=${EVENTS} --embed ${FCL} --description=${DESC}"
echo "Running: $cmd"
$cmd

parfile=$(ls cnf.*.tar)
# Remove cnf.
index_dataset=${parfile:4}
# Remove .0.tar
index_dataset=${index_dataset::-6}

idx_format=$(printf "%07d" ${NJOBS})
echo $idx
echo "Creating index definiton with size: $idx"
samweb create-definition idx_${index_dataset} "dh.dataset etc.mu2e.index.000.txt and dh.sequencer < ${idx_format}"
echo "Created definiton: idx_${index_dataset}"
samweb describe-definition idx_${index_dataset}

ls -ltr

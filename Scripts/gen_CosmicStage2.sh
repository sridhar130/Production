#!/usr/bin/bash
#
# Script to run Stage2 (S2, resampling) S1NAME generation.  The output is Dts files ready for digitization

S1NAME=$1
CAMPAIGN=""
OWNER="mu2e"
S1_VERSION=""
OUTPUT_VERSION=""
NJOBS=0
NEVTS=0
RUNNUM=1202
LOW=""
DSSTOPS=""

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

# Function: Print a help message.
usage() {
   echo "Usage: $0
  [ --S1 Cosmic S1 name (CRY, CORSIKA, ...) ]
  [ --campaign name of the campaign]
  [ --s1ver campaign version of S1 input]
  [ --over campaign version of S2 output]
  [ --njobs  N jobs ]
  [ --nevents  N events/job ]
  [ --low Resample 'Low' S1 output ]
  [ --owner (opt) default mu2e ]
  [ --dsstops (opt) expllicit list of DS stop files ]
  e.g. gen_CosmicStage2.sh --S1 CRY --campaign MDC2020 --s1ver z --over z --njobs 100 --nevents 100000 --owner mu2e ]" 1>&2
}

# Loop: Get the next option;
while getopts ":-:" options; do
  case "${options}" in
    -)
      case "${OPTARG}" in
        campaign)
          CAMPAIGN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        S1)
          S1NAME=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        s1ver)
          S1_VERSION=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        over)
          OUTPUT_VERSION=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        nevents)
          NEVTS=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        njobs)
          NJOBS=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        owner)
          OWNER=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        low)
          LOW="Low"
          ;;
        dsstops)
          DSSTOPS=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        esac;;
    :)                                    # If expected argument omitted:
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    *)                                    # If unknown (any other) option:
      echo "Unknown option ${OPTARG}"
      exit_abnormal                       # Exit abnormally.
      ;;
    esac
done
if [[ ${NJOBS} == 0  || ${NEVTS} == 0 ]]; then
  echo "Missing arguments"
  exit_abnormal
fi

# create the fcl
rm -f ResampleS1.fcl
# create a template file, starting from the basic
echo "#include \"Production/JobConfig/cosmic/S2Resampler.fcl\"" >> ResampleS1.fcl

S2OUT="Cosmic${S1NAME}${LOW}"
echo ${S2OUT}
echo $LOW
if [[ $LOW == "Low" ]]; then
  let RUNNUM=$RUNNUM+1
  echo "Resampling Low, run number = ${RUNNUM}"
  # add epilog to use the 'Low' GenEventCount object for livetime accounting
  echo '#include "Production/JobConfig/cosmic/S2ResamplerLow.fcl"' >> ResampleS1.fcl
  echo "outputs.PrimaryOutput.fileName        : \"dts.owner.Cosmic${S1NAME}$LOW.version.sequencer.art\"" >> ResampleS1.fcl
else
  echo "outputs.PrimaryOutput.fileName        : \"dts.owner.Cosmic${S1NAME}$LOW.version.sequencer.art\"" >> ResampleS1.fcl
fi

OUTCONF=${CAMPAIGN}${OUTPUT_VERSION}
S1CONF=${CAMPAIGN}${S1_VERSION}

if [[ -n $DSSTOPS ]]; then
  echo "Using user-provided input list of DS Stops $DSSTOPS"
else
  DSSTOPS="CosmicDSStops.txt"
  samweb list-definition-files sim.mu2e.CosmicDSStops${S1NAME}${LOW}.${S1CONF}.art  > ${DSSTOPS}
fi

if [ ! -f $DSSTOPS ]; then
  echo "Can't find DSStops"
  exit_abnormal
fi

cmd="mu2ejobdef --embed ResampleS1.fcl --setup /cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/${S1CONF}/setup.sh --run-number=${RUNNUM} --events-per-job=${NEVTS} --desc ${S2OUT} --dsconf ${OUTCONF} --auxinput=1:physics.filters.CosmicResampler.fileNames:${DSSTOPS}"

echo "Running: $cmd"
$cmd

idx_format=$(printf "%07d" ${NJOBS})
echo $idx

echo "Creating index definiton with size: $idx"
samweb create-definition mu2epro_index_${S2OUT}_${OUTCONF} "dh.dataset etc.mu2e.index.000.txt and dh.sequencer < ${idx_format}"

echo "Created definiton: mu2epro_index_${S2OUT}_${OUTCONF}"
samweb describe-definition mu2epro_index_${S2OUT}_${OUTCONF}

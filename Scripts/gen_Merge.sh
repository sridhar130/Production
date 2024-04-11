#!/bin/bash

# Default values
EMBED_FILE="template.fcl"
INPUTS_FILE="inputs.txt"
MERGE_FACTOR=10
SETUP_FILE=""
DESC=""
DS_CONF=""
DS_OWNER=""

# Function: Print usage message
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --embed <file>         Path to the template FCL file (default: template.fcl)"
    echo "  --inputs <file>        Path to the inputs file (default: inputs.txt)"
    echo "  --merge-factor <num>   Merge factor (default: 10)"
    echo "  --setup <file>         Path to the setup file (default: /cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/%(release)s%(release_v_o)s/setup.sh)"
    echo "  --desc <desc>          Job description"
    echo "  --dsconf <conf>        Dataset configuration"
    echo "  --dsowner <owner>      Dataset owner"
    exit 1
}

# Parse command line options
while getopts ":-:" options; do
  case ${options} in
    -)
      case "${OPTARG}" in
          embed)
              EMBED_FILE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
          inputs)
              INPUTS_FILE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
          merge-factor)
              MERGE_FACTOR=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
          setup)
              SETUP_FILE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
          desc)
              DESC=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
          dsconf)
              DS_CONF=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
          dsowner)
              DS_OWNER=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
              ;;
      esac;;
    :)                                    # If expected argument omitted:
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    *)                                    # If unknown (any other) option:
      exit_abnormal                       # Exit abnormally.
      ;;
  esac
done


# Run the merge command with the specified options
echo "Running mu2ejobdef  command with the following options:"
echo "  Embed file: $EMBED_FILE"
echo "  Inputs file: $INPUTS_FILE"
echo "  Merge factor: $MERGE_FACTOR"
echo "  Setup file: $SETUP_FILE"
echo "  Job description: $DESC"
echo "  Dataset configuration: $DS_CONF"
echo "  Dataset owner: $DS_OWNER"

mu2ejobdef --verbose --embed "$EMBED_FILE" --inputs "$INPUTS_FILE" --merge-factor "$MERGE_FACTOR" --setup "$SETUP_FILE" --desc "$DESC" --dsconf "$DS_CONF" --dsowner "$DS_OWNER"

nInFiles=$(wc -l < "$INPUTS_FILE")
echo $nInFiles
idx=$(($nInFiles/$MERGE_FACTOR + 1))
idx_format=$(printf "%07d" $idx)
echo $idx

echo "Creating index definiton with size: $idx"
samweb create-definition mu2epro_index_${DESC}_${DS_CONF} "dh.dataset etc.mu2e.index.000.txt and dh.sequencer < ${idx_format}"

echo "Created definiton: mu2epro_index_${DESC}_${DS_CONF}"
samweb describe-definition mu2epro_index_${DESC}_${DS_CONF}

ls -ltr
echo "Embed file content:"
cat $EMBED_FILE
echo "Inputs file content:"
head $INPUTS_FILE

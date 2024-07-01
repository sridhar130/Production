#!/usr/bin/bash
usage() { echo "Usage: $0
  e.g.  bash calculateInputs.sh --cosmics filenames_CORSIKACosmic (must have complete path)
"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}
COSMICS=""
NJOBS=10
# Loop: Get the next option;
while getopts ":-:" options; do
  case "${options}" in
    -)
      case "${OPTARG}" in
        cosmics)
          COSMICS=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        *)
          echo "Unknown option " ${OPTARG}
          exit_abnormal
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

rm output.txt

echo -n "njobs : " >> output.txt
wc -l ${COSMICS} | awk '{print $1}' >> output.txt

mu2e -c ../Offline/Print/fcl/printCosmicLivetime.fcl -S ${COSMICS} | grep 'Livetime:' | awk -F: '{print $NF}' > ${COSMICS}.livetime
LIVETIME=$(awk '{sum += $1} END {print sum}' ${COSMICS}.livetime)

echo "time" ${LIVETIME}

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/calculateEvents.py --livetime ${LIVETIME} --rue 1e-13 --prc "CEMLL" >> output.txt

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/calculateEvents.py --livetime ${LIVETIME}  --dem_emin 95 --prc "DIO" >> output.txt

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/calculateEvents.py --livetime ${LIVETIME} --rue 1e-13 --dem_emin 95 --prc "CORSIKA" >> output.txt



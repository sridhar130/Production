#!/usr/bin/bash
usage() { echo "Usage: $0
  e.g.  bash ../Production/Scripts/calculateInputs.sh --cosmics filenames_CORSIKACosmic --dem_emin 95 --rmue 1e-13 --BB 1BB

"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}
COSMICS=""
NJOBS=10
LIVETIME=60 #seconds
DEM_EMIN=95
BB=1BB
RMUE=1e-13
# Loop: Get the next option;
while getopts ":-:" options; do
  case "${options}" in
    -)
      case "${OPTARG}" in
        cosmics)
          COSMICS=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        livetime)
          LIVETIME=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        dem_emin)
          DEM_EMIN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        BB)
          BB=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        rmue)
          RMUE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
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

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/calculateEvents.py --livetime ${LIVETIME} --rue ${RMUE} --prc "CEMLL" --BB ${BB} >> output.txt

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/calculateEvents.py --livetime ${LIVETIME}  --dem_emin ${DEM_EMIN} --prc "DIO" --BB ${BB} >> output.txt

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/calculateEvents.py --livetime ${LIVETIME} --prc "CORSIKA" --BB ${BB} >> output.txt



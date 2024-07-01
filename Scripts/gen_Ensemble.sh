#!/usr/bin/bash
usage() { echo "Usage: $0
  e.g.  bash ../Production/Scripts/gen_Ensemble.sh --livetime 60 --run 1201 --dem_emin 75 --tmin 450 --BB 1BB --rmue 1e-13 --verbose 1 --tagg MSC1a
"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}
CAMPAIGN=MDC2024
VERSION=a_sm4
PRC=""
TAGG="" # MDS1a
NJOBS="" #to help calculate the number of events per job
LIVETIME=60 #seconds
RUN=1201
DEM_EMIN=75
TMIN=450
SAMPLINGSEED=1
BB=1BB
RMUE=1e-13
VERBOSE=1

# Loop: Get the next option;
while getopts ":-:" options; do
  case "${options}" in
    -)
      case "${OPTARG}" in
        prc)
          PRC=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        tagg)
          TAGG=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        njobs)
          NJOBS=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        livetime)
          LIVETIME=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        run)
          RUN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        dem_emin)
          DEM_EMIN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        tmin)
          TMIN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        samplingseed)
          SAMPLINGSEED=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        BB)
          BB=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        rmue)
          RMUE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        verbose)
          VERBOSE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
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
echo ${TAGG}

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/make_template_fcl.py --stdpath=/exp/mu2e/app/users/sophie/newOffline/MDS-1/ --BB=${BB}  --tag=${TAGG} --verbose=${VERBOSE} --rue=${RMUE} --livetime=${LIVETIME} --run=${RUN} --dem_emin=${DEM_EMIN} --tmin=${TMIN} --samplingseed=${SAMPLINGSEED} --prc "CeMLL" "DIO" "CORSIKACosmic"

#echo ${TOTALEVENTS} ${NJOBS}
#EVENTS=${TOTALEVENTS}/${NJOBS}

echo "events per job" ${EVENTS}

DSCONF=${CAMPAIGN}${VERSION}
SETUP=/cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/MDC2020af/setup.sh

cmd="mu2ejobdef --desc=ensemble${TAG} --dsconf=${DSCONF} --run=${RUN} --setup ${SETUP} --sampling=1:CeMLL:filenames_CeMLL_10.txt --sampling=1:DIO:filenames_DIO_10.txt --sampling=1:CORSIKACosmic:filenames_CORSIKACosmic_10.txt --embed SamplingInput_sr0.fcl --verb "
echo "Running: $cmd"
$cmd

#--events-per-job=${EVENTS}
#mu2ejobsub --jobdef cnf.sophie.ensemble.MDC2024a_sm4.0.tar --firstjob=0 --njobs=10  --predefined=sl7 --default-protocol ifdh --default-location tape


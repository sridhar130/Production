#!/usr/bin/bash
usage() { echo "Usage: $0
  e.g.  bash ../Production/Scripts/MakeTemplateFcl.sh --livetime 60 --run 1201 --dem_emin 75 --tmin 450 --BB 1BB --rmue 1e-13 --verbose 1 --tagg MSC1a
"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}
RELEASE=MDC2024
VERSION=a_sm4
PRC=""
TAGG="" # MDS1a
NJOBS=5 #to help calculate the number of events per job
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

rm filenames_CORSIKACosmic
rm filenames_DIO
rm filenames_CeMLL

#samweb list-file-locations --defname="dts.mu2e.CosmicCORSIKASignalAll.MDC2020ae.art" > filenames_CORSIKACosmic
#samweb list-file-locations --defname="dts.mu2e.DIOtailp${DEM_EMIN}MeVc.${RELEASE}${VERSION}.art"  > filenames_DIO
#samweb list-file-locations --defname="dts.mu2e.CeMLeadingLog.${RELEASE}${VERSION}.art" >  filenames_CeMLL
ls /pnfs/mu2e/tape/phy-sim/dts/mu2e/CosmicCORSIKASignalAll/MDC2020ae/art/*/*/*.art > filenames_CORSIKACosmic
ls /pnfs/mu2e/tape/phy-sim/dts/mu2e/DIOtailp${DEM_EMIN}MeVc/${RELEASE}${VERSION}/art/*/*/*.art > filenames_DIO
ls /pnfs/mu2e/tape/phy-sim/dts/mu2e/CeMLeadingLog/${RELEASE}${VERSION}/art/*/*/*.art > filenames_CeMLL

STDPATH=$pwd # this should be the path where you are currently running

python /exp/mu2e/app/users/sophie/newOffline/Production/JobConfig/ensemble/python/make_template_fcl.py --stdpath=${STDPATH} --BB=${BB}  --tag=${TAGG} --verbose=${VERBOSE} --rue=${RMUE} --livetime=${LIVETIME} --run=${RUN} --dem_emin=${DEM_EMIN} --tmin=${TMIN} --samplingseed=${SAMPLINGSEED} --prc "CeMLL" "DIO" "CORSIKACosmic"

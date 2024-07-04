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
SETUP=/cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/MDC2020af/setup.sh


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

rm cnf.sophie.ensemble.${RELEASE}${VERSION}.0.tar
rm filenames_CORSIKACosmic_${NJOBS}.txt
rm filenames_DIO_${NJOBS}.txt
rm filenames_CeMLL_${NJOBS}.txt

samweb list-files "dh.dataset=dts.mu2e.CosmicCORSIKASignalAll.MDC2020ae.art" | head -${NJOBS} > filenames_CORSIKACosmic_${NJOBS}.txt
samweb list-files "dh.dataset=dts.mu2e.DIOtailp${DEM_EMIN}MeVc.${RELEASE}${VERSION}.art"  | head -${NJOBS} > filenames_DIO_${NJOBS}.txt
samweb list-files "dh.dataset=dts.mu2e.CeMLeadingLog.${RELEASE}${VERSION}.art"  | head -${NJOBS}  >  filenames_CeMLL_${NJOBS}.txt

DSCONF=${RELEASE}${VERSION}

cmd="mu2ejobdef --desc=ensemble${TAG} --dsconf=${DSCONF} --run=${RUN} --setup ${SETUP} --sampling=1:CeMLL:filenames_CeMLL_${NJOBS}.txt --sampling=1:DIO:filenames_DIO_${NJOBS}.txt --sampling=1:CORSIKACosmic:filenames_CORSIKACosmic_${NJOBS}.txt --embed Production/JobConfig/ensemble/fcl/SamplingInput_sr0.fcl --verb "
echo "Running: $cmd"
$cmd

parfile=$(ls cnf.*.tar)
# Remove cnf.
index_dataset=${parfile:4}
# Remove .0.tar
index_dataset=${index_dataset::-6}

idx=$(mu2ejobquery --njobs cnf.*.tar)
idx_format=$(printf "%07d" $idx)
echo $idx
echo "Creating index definiton with size: $idx"
samweb create-definition idx_${index_dataset} "dh.dataset etc.mu2e.index.000.txt and dh.sequencer < ${idx_format}"
echo "Created definiton: idx_${index_dataset}"
samweb describe-definition idx_${index_dataset}

cmd="mu2ejobsub --jobdef cnf.sophie.ensemble.${RELEASE}${VERSION}.0.tar --firstjob=0 --njobs=${NJOBS}  --predefined=sl7 --default-protocol ifdh --default-location tape"
echo "Running: $cmd"
$cmd

#!/bin/bash

usage() { echo "Usage: $0
  [ --pname = process name
    --camp = campaign with db version and purpose
    --type = file family
    --run = runnumber
    --nfiles = total number of files
  ]
  e.g.  
  
  if mcs.mu2e.CeEndpointOnSpillSignal.MDC2020z_perfect_v1_1.001210_00000XXX.art
  
  then bash retireart.sh --pname CeEndpointOnSpillSignal --camp MDC2020z_perfect_v1_1 --run 1210 --nfiles 1000 --type mcs
  
"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

PROCESSNAME=""
CAMPAIGN=""
TYPE=""
RUN=""
NFILES=""

while getopts ":-:" options; do
  case "${options}" in
    -)
      case "${OPTARG}" in
        pname)
          PROCESSNAME=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        camp)
          CAMPAIGN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        type)
          TYPE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        run)
          RUN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        nfiles)
          NFILES=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        *)
          echo "Unnown option " ${OPTARG}
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
echo ${NFILES}
if [ ${NFILES} -lt 10 ]
then
  for i in {1..9}; do samweb retire-file ${TYPE}.mu2e.${PROCESSNAME}.${CAMPAIGN}.00${RUN}_0000000$i.art; done
fi

if  [ ${NFILES} -gt 10 ] && [ ${NFILES} -lt 100 ]  || [ ${NFILES} -eq 10 ]
then
  for i in {10..99}; do samweb retire-file ${TYPE}.mu2e.${PROCESSNAME}.${CAMPAIGN}.00${RUN}_000000$i.art; done
fi

if [ ${NFILES} -gt 100 ] &&  [ ${NFILES} -lt 1000 ] || [ ${NFILES} -eq 1000 ] 
then
  for i in {100..999}; do samweb retire-file ${TYPE}.mu2e.${PROCESSNAME}.${CAMPAIGN}.00${RUN}_00000$i.art; done
fi

if [ ${NFILES} -gt 1000 ] &&  [ ${NFILES} -lt 10000 ] || [ ${NFILES} -eq 10000 ]
then
  for i in {1000..9999}; do samweb retire-file ${TYPE}.mu2e.${PROCESSNAME}.${CAMPAIGN}.00${RUN}_0000$i.art; done
fi

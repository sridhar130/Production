#!/usr/bin/bash

usage() { echo "Usage: $0 [ --primary primary physics name ] 
  [ --release primary release name ]
  [ --dcamp digi campaign name ]
  [ --rcamp reco campaign name ]
  [ --merge merge factor ]
  [ --dbpurpose purpose of db e.g. perfect, startup, best  ]
  [ --dbversion db version ]
  [ --digitype OnSpill, OffSpill etc. ]
  [ --stream Signal, Trk, Diag, Calo etc. ]
  [ --mix Mix if mixed, blank otherwise]
  [ --owner (opt) default mu2e ]
  [ --run (opt) default 1202 ]
  e.g.  bash gen_Reco.sh --primary CeEndpoint --release MDC2020 --dcamp MDC2020v --rcamp MDC2020v  --dbpurpose perfect --dbversion v1_0 --merge 10 --digitype OnSpill --stream Signal --beam 1BB --mix Mix
"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

PRIMARY="" # name of primary
RELEASE="" # e.g. MDC2020
DIGI_CAMPAIGN="" # digi (input) campaign name
RECO_CAMPAIGN="" # reco (output) campaign name
DB_PURPOSE="" # db purpose  
DB_VERSION="" # db version
DIGITYPE="" # digitype
MIX=""
MERGE=10 # merge factor
OWNER=mu2e
STREAM=Signal


# Loop: Get the next option;
while getopts ":-:" options; do
  case "${options}" in      
    -)                                   
      case "${OPTARG}" in               
        primary)                                  
          PRIMARY=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))      
          ;;
        release)                                  
          RELEASE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))      
          ;;
        dcamp)                                   
          DIGI_CAMPAIGN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                
          ;;
        rcamp)                                    
          RECO_CAMPAIGN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                  
          ;;
        dbpurpose)                                   
          DB_PURPOSE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                   
          ;;
        dbversion)                                   
          DB_VERSION=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                  
          ;;
        digitype)                                   
          DIGITYPE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                  
          ;;
        merge)                                   
          MERGE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                   
          ;;
        owner)                                   
          OWNER=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                     
          ;;  
        stream)                                   
          STREAM=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                     
          ;; 
        mix)                                   
          MIX=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))                     
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

echo "Generating reco scripts for ${PRIMARY} conf ${DIGI_CAMPAIGN}_${DB_PURPOSE}_${DB_VERSION} output ${RECO_CAMPAIGN}_${DB_PURPOSE}_${DB_VERSION}  database purpose, version ${RECO_CAMPAIGN}_${DB_PURPOSE} ${DB_VERSION}"

samweb list-file-locations --schema=root --defname="dig.${OWNER}.${PRIMARY}${DIGITYPE}${MIX}${STREAM}.${DIGI_CAMPAIGN}_${DB_PURPOSE}_${DB_VERSION}.art"  | cut -f1 > Digis.txt

echo '#include "Production/JobConfig/reco/Reco.fcl"' > template.fcl
echo 'services.DbService.purpose:' ${RELEASE}'_'${DB_PURPOSE} >> template.fcl
echo 'services.DbService.version:' ${DB_VERSION} >> template.fcl
echo 'services.DbService.verbose : 2' >> template.fcl

generate_fcl --dsowner=${OWNER} --override-outputs --auto-description --embed template.fcl --dsconf "${RECO_CAMPAIGN}_${DB_PURPOSE}_${DB_VERSION}" \
--inputs "Digis.txt" --merge-factor=${MERGE}

base=${PRIMARY}Reco_
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
   echo "found dir $dirname"
   if test -d ${base}${dirname}; then
     echo "removing ${base}${dirname}"
     rm -rf ${base}${dirname}
   fi
  echo "moving $dirname to ${base}${dirname}"
  mv $dirname ${base}${dirname}
fi
done

#!/usr/bin/bash
#
# this script requires mu2etools, mu2efiletools and dhtools be setup
# It also requires the SimEfficiencies for the beam campaign be entered in the database
#
PRIMARY="" # is the PRIMARY
CAMPAIGN="" # production version
PRIMARY_VERSION="" # version of the campaign that produced the primary
DIGI_VERSION="" # version of the digi production
TYPE="" # the kind of input stops (Muminus, Muplus, IPAMuminus, IPAMuplus, Piminus, Piplus, or Cosmic)
MERGE="" #is the number of input collections to merge (merge factor)
DIGITYPE="" #is the digitization type (OnSpill, OffSpill, NoField, Extracted)
DB_PURPOSE="" # is the database purpose
DB_VERSION="" # is the database version
# The following can be overridden if needed
OWNER=mu2e
SAMOPT="-f "
FIELD="Offline/Mu2eG4/geom/bfgeom_no_tsu_ps_v01.txt" #optional (for changing field map)


usage() { echo "Usage: $0 [ --primary primary physics name ]
  [ --campaign primary campaign name e.g. MDC2020 ]
  [ --pver primary campaign versione ]
  [ --dver digi campaign version ]
  [ --type stopped particle type e.g. Muminus, Muplus, IPAMuminus, IPAMuplus, Piminus, Piplus, or Cosmic ]
  [ --merge merge factor ]
  [ --digitype  digitization type e.g. OnSpill, OffSpill, NoField, Extracted]
  [ --dbpurpose purpose of db e.g. perfect, startup, best  ]
  [ --dbversion db version ]
  [ --owner (opt) default mu2e ]
  [ --samopt (opt) Options to samListLocation default "-f" ]
  [ --field (opt) override for special runs ]
  e.g.  bash generate_Digitization.sh --primary CeEndpoint --campaign MDC2020--pver t --dver t --njobs 1000 --events 100 --merge 10 --digitype OnSpill --dbpurpose perfect --dbversion v1_0"
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}


# Loop: Get the next option;
while getopts ":-:" options; do
  case "${options}" in
    -)
      case "${OPTARG}" in
        primary)
          PRIMARY=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        campaign)
          CAMPAIGN=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        pver)
          PRIMARY_VERSION=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        dver)
          DIGI_VERSION=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        merge)
          MERGE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        digitype)
          DIGITYPE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        dbpurpose)
          DB_PURPOSE=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        dbversion)
          DB_VERSION=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        owner)
          OWNER=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        samopt)
          SAMOPT=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        field)
          FIELD=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
          ;;
        desc)
          DESC=${!OPTIND} OPTIND=$(( $OPTIND + 1 ))
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

# basic tests: expand to all required arguments TODO
if [[ ${CAMPAIGN} == "" ]]; then
  echo "No campaign specified: exit"
  exit 1
fi

DESC=${PRIMARY}.${CAMPAIGN}${PRIMARY_VERSION} # can override if more detailed tag is needed

# Test: run a test to check the SimJob for this campaign verion exists
DIR=/cvmfs/mu2e.opensciencegrid.org/Musings/SimJob/${CAMPAIGN}${DIGI_VERSION}
if [ -d "$DIR" ];
  then
    echo "Musing $DIR exists."
  else
    echo "Musing $DIR does not exist."
    exit 1
fi


if [[ "${DIGITYPE}" == "Extracted" || "${DIGITYPE}" == "NoField" ]]; then
  if [[ "${PRIMARY}" != *"${DIGITYPE}"* ]]; then
    echo "PRIMARY ${PRIMARY} doesn't match digitization type ${DIGITYPE}; aborting"
    return 1
  else
    # no need for redundant labels
    digout=$PRIMARY
  fi
  # check BFIELD here too: it must be 'null' TODO
else
  if [[ "${PRIMARY}" == *"Extracted"* || "${PRIMARY}" == *"NoField"* ]]; then
    echo "PRIMARY ${PRIMARY} incompatible with digitization type ${DIGITYPE}; aborting"
    return 1
  fi
fi
echo "Generating digitization scripts for campaign ${CAMPAIGN} primary $PRIMARY version ${PRIMARY_VERSION} musing version ${DIGI_VERSION} digitzation type ${DIGITYPE} database purpose, version  ${DB_PURPOSE} ${DB_VERSION}"

rm -f digitize.fcl
samListLocations ${SAMOPT} --schema=root --defname="dts.mu2e.${DESC}.art" > ${DESC}.txt
echo \#include \"Production/JobConfig/digitize/Digitize.fcl\" >> digitize.fcl
echo \#include \"Production/JobConfig/digitize/${DIGITYPE}.fcl\" >> digitize.fcl
# turn off streams according to the digitization type.
if [[ "${DIGITYPE}" == "Extracted" || "${DIGITYPE}" == "NoField" ]]; then
  echo outputs.TrkOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Trk.version.sequencer.art\" >> digitize.fcl
  echo outputs.CaloOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Calo.version.sequencer.art\" >> digitize.fcl
  echo outputs.UntriggeredOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Untriggered.version.sequencer.art\" >> digitize.fcl
else
  # keep all streams
  echo outputs.SignalOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Signal.version.sequencer.art\" >> digitize.fcl
  echo outputs.DiagOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Diag.version.sequencer.art\" >> digitize.fcl
  echo outputs.TrkOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Trk.version.sequencer.art\" >> digitize.fcl
  echo outputs.CaloOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Calo.version.sequencer.art\" >> digitize.fcl
  echo outputs.UntriggeredOutput.fileName: \"dig.owner.${PRIMARY}${DIGITYPE}Untriggered.version.sequencer.art\" >> digitize.fcl
fi
# setup database access for digi parameters
echo services.DbService.purpose: ${CAMPAIGN}_${DB_PURPOSE} >> digitize.fcl
echo services.DbService.version: ${DB_VERSION} >> digitize.fcl
echo services.DbService.verbose : 2 >> digitize.fcl
echo "services.GeometryService.bFieldFile : \"${FIELD}\"" >> digitize.fcl

generate_fcl --dsconf="${CAMPAIGN}${DIGI_VERSION}_${DB_PURPOSE}_${DB_VERSION}" --dsowner=${OWNER} --description="${PRIMARY}${DIGITYPE}" --embed digitize.fcl \
  --inputs="${DESC}.txt" --merge-factor=${MERGE}
for dirname in 000 001 002 003 004 005 006 007 008 009; do
  if test -d $dirname; then
    echo "found dir $dirname"
    rm -rf "${PRIMARY}${DIGITYPE}_$dirname"
    echo "moving $dirname to ${PRIMARY}${DIGITYPE}_${dirname}"
    mv $dirname "${PRIMARY}${DIGITYPE}_$dirname"
  fi
done


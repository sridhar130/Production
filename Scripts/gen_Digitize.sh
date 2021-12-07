#!/usr/bin/bash
#
# this script requires mu2etools, mu2efiletools and dhtools be setup
# It also requires the SimEfficiencies for the beam campaign be entered in the database
# $1 is the name of the primary (ie CeEndpoint, etc).
# $2 is the dataset description
# $3 is the campaign version of the input (primary) file
# $4 is the campaign version of the output (digi) file.
# $5 is the number of input collections to merge (merge factor)
# $6 is the digitization type (OnSpill, OffSpill, NoField, Extracted)
primary=$1
name=$primary.$2$3
conf=$2$4
merge=$5
digitype=$6

rm template.fcl
samweb list-file-locations --schema=root --defname="dts.mu2e.${name}.art"  | cut -f1 > $name.txt
echo \#include \"Production/JobConfig/digitize/${digitype}.fcl\" >> template.fcl
echo outputs.TriggeredOutput.fileName: \"dig.owner.${primary}${digitype}Triggered.version.sequencer.art\" >> template.fcl
echo outputs.UntriggeredOutput.fileName: \"dig.owner.${primary}${digitype}Untriggered.version.sequencer.art\" >> template.fcl
echo outputs.TrkOutput.fileName: \"dig.owner.${primary}${digitype}Trk.version.sequencer.art\" >> template.fcl
echo outputs.CaloOutput.fileName: \"dig.owner.${primary}${digitype}Calo.version.sequencer.art\" >> template.fcl
generate_fcl --dsconf="$conf" --dsowner=mu2e --description="${primary}${digitype}" --embed template.fcl \
  --inputs="$name.txt" --merge-factor=$merge
for dirname in 000 001 002 003 004 005 006 007 008 009; do
  if test -d $dirname; then
    echo "found dir $dirname"
    rm -rf "${primary}${digitype}_$dirname"
    mv $dirname "${primary}${digitype}_$dirname"
  fi
done


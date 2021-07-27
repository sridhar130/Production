#!/usr/bin/bash
#
# this script requires mu2etools, mu2efiletools and dhtools be setup
# $1 is the name of the primary (ie CeEndpoint, etc).  $2 is the campaign version
#
# create the mixin input lists
samListLocations --defname="dts.mu2e.MuBeamFlashCat.MDC2020$2.art" > MuBeamFlashCat$2.txt
samListLocations --defname="dts.mu2e.EleBeamFlashCat.MDC2020$2.art" > EleBeamFlashCat$2.txt
samListLocations --defname="dts.mu2e.NeutralsFlashCat.MDC2020$2.art" > NeutralsFlashCat$2.txt
samListLocations --defname="dts.mu2e.MuStopPileupCat.MDC2020$2.art" > MuStopPileupCat$2.txt
#
# create the database override: this is temporary
#
source Production/JobConfig/beam/CreateSimEfficiency.sh MDC2020$2
#
# write the template fcl
#
rm template.fcl
if [ $1 == "NoPrimary" ]; then
  echo '#include "Production/JobConfig/mixing/NoPrimary.fcl"' >> template.fcl
else
  echo '#include "Production/JobConfig/mixing/Mix.fcl"' >> template.fcl 
fi
# the following should be an option (or gotten through the database)
echo '#include "Production/JobConfig/mixing/OneBB.fcl"' >> template.fcl 
echo 'services.ProditionsService.simbookkeeper.useDb: true' >> template.fcl
echo services.DbService.textFile : [\"MDC2020${2}_SimEff.txt\"] >> template.fcl
#
# run generate_fcl
#
if [ $1 == "NoPrimary" ]; then
  generate_fcl --dsconf="MDC2020$2" --dsowner=mu2e --description="$1Mix$2" --embed template.fcl \
  --run-number=1203 --events-per-job=2000 --njobs=100 \
  --auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat$2.txt \
  --auxinput=1:physics.filters.EleBeamFlashMixer.fileNames:EleBeamFlashCat$2.txt \
  --auxinput=1:physics.filters.MuBeamFlashMixer.fileNames:MuBeamFlashCat$2.txt \
  --auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat$2.txt
else
  generate_fcl --dsconf="MDC2020$2" --dsowner=mu2e --description="$1Mix$2" --embed template.fcl \
  --inputs="$1$2.txt" --merge-factor=1 \
  --auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat$2.txt \
  --auxinput=1:physics.filters.EleBeamFlashMixer.fileNames:EleBeamFlashCat$2.txt \
  --auxinput=1:physics.filters.MuBeamFlashMixer.fileNames:MuBeamFlashCat$2.txt \
  --auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat$2.txt
fi
#
# Complete the output file names for Triggered and Untriggered streams
#
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf "$1Mix$2_$dirname"
  mv $dirname "$1Mix$2_$dirname"
  for file in $1Mix$2_$dirname/*.fcl; do
    echo "editing file $file"
    sed -i "s/MixTriggered/$1MixTriggered/" $file
    sed -i "s/MixUntriggered/$1MixUntriggered/" $file
  done
 fi
done


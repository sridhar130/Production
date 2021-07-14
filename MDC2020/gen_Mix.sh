generate_fcl --dsconf="MDC2020$2" --dsowner=brownd --description="$1Mix$2" --include JobConfig/mixing/MixRun1.fcl \
--inputs="$1$2.txt" --merge-factor=1 \
--auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat$2.txt \
--auxinput=1:physics.filters.EleBeamFlashMixer.fileNames:EleBeamFlashCat$2.txt \
--auxinput=1:physics.filters.MuBeamFlashMixer.fileNames:MuBeamFlashCat$2.txt \
--auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat$2.txt 
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf "$1Mix_$dirname"
  mv $dirname "$1Mix$2_$dirname"
  for file in $1Mix$2_$dirname/*.fcl; do
    echo "editing file $file"
    sed -i "s/MixTriggered/$1MixTriggered$2/" $file
    sed -i "s/MixUntriggered/$1MixUntriggered$2/" $file
  done
 fi
done


generate_fcl --dsconf="MDC2020$2" --dsowner=brownd --description="$1Mix" --include JobConfig/mixing/MixRun1.fcl \
--inputs="$1$2.txt" --merge-factor=1 \
--auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat.txt \
--auxinput=1:physics.filters.EleBeamFlashMixer.fileNames:EleBeamFlashCat.txt \
--auxinput=1:physics.filters.MuBeamFlashMixer.fileNames:MuBeamFlashCat.txt \
--auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat.txt 
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf "$1Mix_$dirname"
  mv $dirname "$1Mix_$dirname"
  for file in $1Mix_$dirname/*.fcl; do
    echo "editing file $file"
    sed -i "s/description-/$1Mix/" $file
  done
 fi
done


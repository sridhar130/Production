generate_fcl --dsconf="MDC2020$2" --dsowner=brownd --override-outputs --auto-description=Mix --include JobConfig/mixing/MixRun1.fcl \
--inputs="$1$2.txt" --merge-factor=1 \
--auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat.txt \
--auxinput=1:physics.filters.BeamFlashMixer.fileNames:BeamFlashCat.txt \
--auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat.txt 
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf "$1Mix_$dirname"
  mv $dirname "$1Mix_$dirname"
 fi
done


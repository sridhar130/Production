generate_fcl --dsconf=MDC2020d --dsowner=brownd --override-outputs --auto-description=Mix --include JobConfig/mixing/MixPrimaryRun1.fcl \
--inputs=CeEndpoint.txt --merge-factor=1 \
--auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat.txt \
--auxinput=1:physics.filters.BeamFlashMixer.fileNames:BeamFlashCat.txt \
--auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat.txt 
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf CeEndpointMix_$dirname
  mv $dirname CeEndpointMix_$dirname
 fi
done


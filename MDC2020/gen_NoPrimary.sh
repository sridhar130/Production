generate_fcl --dsconf=MDC2020d --dsowner=brownd --run-number=1203 --description=NoPrimary --events-per-job=2000 --njobs=100 --include JobConfig/mixing/NoPrimaryRun1.fcl \
--auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat.txt \
--auxinput=1:physics.filters.BeamFlashMixer.fileNames:BeamFlashCat.txt \
--auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat.txt 
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf NoPrimary_$dirname
  mv $dirname NoPrimary_$dirname
 fi
done


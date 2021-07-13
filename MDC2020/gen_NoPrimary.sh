generate_fcl --dsconf=MDC2020$1 --dsowner=brownd --run-number=1203 --description=NoPrimary --events-per-job=2000 --njobs=100 --include JobConfig/mixing/NoPrimaryRun1.fcl \
--auxinput=1:physics.filters.MuStopPileupMixer.fileNames:MuStopPileupCat$1.txt \
--auxinput=1:physics.filters.EleBeamFlashMixer.fileNames:EleBeamFlashCat$1.txt \
--auxinput=1:physics.filters.MuBeamFlashMixer.fileNames:MuBeamFlashCat$1.txt \
--auxinput=1:physics.filters.NeutralsFlashMixer.fileNames:NeutralsFlashCat$1.txt 
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf NoPrimary$1_$dirname
  mv $dirname NoPrimary$1_$dirname
 fi
done


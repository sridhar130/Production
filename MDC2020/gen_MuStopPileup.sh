generate_fcl --dsconf=MDC2020f --dsowner=brownd --run-number=1205 --description=MuStopPileup --events-per-job=200000 --njobs=100 --include JobConfig/pileup/MuStopPileup.fcl --auxinput=1:physics.filters.TargetStopResampler.fileNames:MuminusTargetStops.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf MuStopPileup_$dirname
  mv $dirname MuStopPileup_$dirname
 fi
done


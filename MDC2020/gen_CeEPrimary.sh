generate_fcl --dsconf=MDC2020d --dsowner=brownd --run-number=1203 --description=CeEndpoint --events-per-job=2000 --njobs=10 --include JobConfig/primary/CeEndpoint.fcl --auxinput=1:physics.filters.TargetStopResampler.fileNames:TargetStops.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf CeEPrimary_$dirname
  mv $dirname CeEPrimary_$dirname
 fi
done


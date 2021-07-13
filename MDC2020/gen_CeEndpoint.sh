generate_fcl --dsconf=MDC2020$1 --dsowner=brownd --run-number=1210 --description=CeEndpoint --events-per-job=4000 --njobs=100 --include JobConfig/primary/CeEndpoint.fcl --auxinput=1:physics.filters.TargetStopResampler.fileNames:MuminusStopsCat$1.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf CeEndpoint$1_$dirname
  mv $dirname CeEndpoint$1_$dirname
 fi
done


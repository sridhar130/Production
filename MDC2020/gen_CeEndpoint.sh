generate_fcl --dsconf=MDC2020d --dsowner=brownd --run-number=1203 --description=CeEndpoint --events-per-job=4000 --njobs=100 --include JobConfig/primary/CeEndpoint.fcl --auxinput=1:physics.filters.TargetStopResampler.fileNames:TargetStopsCat.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf CeEndpoint_$dirname
  mv $dirname CeEndpoint_$dirname
 fi
done


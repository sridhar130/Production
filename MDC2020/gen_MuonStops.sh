generate_fcl --dsconf=MDC2020d --dsowner=brownd --description=MuonStopSelector --include JobConfig/beam/MuonStopSelector.fcl \
--inputs TargetStops.txt --merge-factor 1000
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf MuonStops_$dirname
  mv $dirname MuonStops_$dirname
 fi
done


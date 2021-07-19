generate_fcl --dsconf=MDC2020$1 --dsowner=brownd --run-number=1202 --description=MuBeamResampler --events-per-job=200000 --njobs=100 --include JobConfig/beam/MuBeamResampler.fcl --auxinput=1:physics.filters.beamResampler.fileNames:MuBeam$1.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf MuBeamResampleri$1_$dirname
  mv $dirname MuBeamResampler$1_$dirname
 fi
done


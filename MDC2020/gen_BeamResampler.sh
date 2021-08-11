generate_fcl --dsconf=MDC2020$1 --dsowner=brownd --run-number=1202 --description=BeamResampler --events-per-job=200000 --njobs=1000 --include JobConfig/beam/BeamResampler.fcl --auxinput=1:physics.filters.beamResampler.fileNames:Beami$1.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf BeamResampler$1_$dirname
  mv $dirname BeamResampler$1_$dirname
 fi
done


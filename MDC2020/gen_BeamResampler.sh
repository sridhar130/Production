generate_fcl --dsconf=MDC2020d --dsowner=brownd --run-number=1202 --description=BeamResampler --events-per-job=200000 --njobs=1000 --include JobConfig/beam/BeamResampler.fcl --auxinput=1:physics.filters.beamResampler.fileNames:Beam.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf BeamResampler_$dirname
  mv $dirname BeamResampler_$dirname
 fi
done


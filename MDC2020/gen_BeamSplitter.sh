generate_fcl --dsconf=MDC2020d --dsowner=brownd --description=BeamSplitter --include JobConfig/beam/BeamSplitter.fcl \
--inputs Beam.txt --merge-factor 1000
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf BeamSpliter_$dirname
  mv $dirname BeamSpliter_$dirname
 fi
done


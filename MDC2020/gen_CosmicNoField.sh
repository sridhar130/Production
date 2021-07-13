generate_fcl --dsconf=MDC2020g --dsowner=brownd --run-number=1205 --description=CosmicNoField --events-per-job=80000 --njobs=48 --include JobConfig/cosmic/S2ResamplerNoField.fcl --auxinput=1:physics.filters.cosmicResample.fileNames:CosmicS1.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf CosmicNoField_$dirname
  mv $dirname CosmicNoField_$dirname
 fi
done


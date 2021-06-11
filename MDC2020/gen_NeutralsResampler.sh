generate_fcl --dsconf=MDC2020d --dsowner=brownd --run-number=1202 --description=NeutralsResampler --events-per-job=200000 --njobs=1000 --embed NeutralsSkip.fcl --auxinput=1:physics.filters.neutralsResampler.fileNames:Neutrals.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf NeutralsResampler_$dirname
  mv $dirname NeutralsResampler_$dirname
 fi
done


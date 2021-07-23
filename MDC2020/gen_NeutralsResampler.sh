generate_fcl --dsconf=MDC2020$1 --dsowner=brownd --run-number=1203 --description=NeutralsResampler --events-per-job=200000 --njobs=1000 --include JobConfig/beam/NeutralsResampler.fcl --auxinput=1:physics.filters.neutralsResampler.fileNames:Neutrals$1.txt
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf NeutralsResampler$1_$dirname
  mv $dirname NeutralsResampler$1_$dirname
 fi
done


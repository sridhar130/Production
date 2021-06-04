generate_fcl --dsconf=MDC2020d --dsowner=brownd --run-number=1201 --events-per-job=2000 --njobs=1000 --include JobConfig/beam/POT.fcl --description=POT
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf POT_$dirname
  mv $dirname POT_$dirname
 fi
done


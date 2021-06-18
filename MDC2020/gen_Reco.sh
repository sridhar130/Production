generate_fcl --dsconf=MDC2020d --dsowner=brownd --override-outputs --auto-description=Reco --include JobConfig/reco/Reco.fcl \
--inputs $1.txt --merge-factor=1
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf $1Reco_$dirname
  mv $dirname $1Reco_$dirname
 fi
done


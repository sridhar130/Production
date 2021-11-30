# Written by Sophie Middleton 
generate_fcl --dsconf=MDC2020$1 --dsowner=sophie --description=PionStopSelector --include JobConfig/pionbeam/PionStopSelector.fcl \
--inputs PionTargetStops$1.txt --merge-factor 1000
for dirname in 000 001 002 003 004 005 006 007 008 009; do
 if test -d $dirname; then
  echo "found dir $dirname"
  rm -rf PionStops$1_$dirname
  mv $dirname PionStops$1_$dirname
 fi
done


#!/bin/bash
#
#  Summarize contents of a production dataset
# $1 = user
# $2 = production (ie MDC2020k)
#
# you must have run 'setup dhtools' before running this script
#
samweb list-definitions --user=$1 | grep $2 | grep art > Datasets.txt
#
echo " files     GB        ev      MB/file   ev/file   dataset"
echo "---------------------------------------------------------"
while read DS || [[ -n $DS ]]; do
  TMP=`mktemp`
  samweb list-files --summary "dh.dataset=$DS and availability:anylocation" > $TMP
  NN=`cat $TMP | grep File | awk '{print $3}'`
  SZ=`cat $TMP | grep Total | awk '{printf "%d",$3/1000000000.0}'`
  SZF=`cat $TMP | grep Total | awk '{printf "%d",$3/1000000.0/'$NN'}'`
  EC=`cat $TMP | grep Event | awk '{printf "%d",$3}'`
  ECF=`cat $TMP | grep Event | awk '{printf "%d",$3/'$NN'}'`
  rm -f $TMP
  printf "%5d   %5d    %9d    %5d    %6d     %s\n" $NN $SZ $EC $SZF $ECF $DS
done < Datasets.txt
#rm Datasets.txt

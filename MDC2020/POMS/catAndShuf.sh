#!/bin/bash

FILE=$1
ifile=0

for i in $(eval echo {1..$2})
do
    cat $1 | shuf > ${FILE%%.*}_shuf.txt

    generate_fcl --merge=$3 \
    --inputs=${FILE%%.*}_shuf.txt \
    --description=$4 \
    --dsconf=$5 \
    --dsowner=$6 \
    --embed $7

    FILES="[0-9]*/*.fcl"

    for f in $FILES
    do
        fields=(${f//./ })
        sequencer=${fields[4]}
        numbers=(${sequencer//_/ })
        counter_string_old=${numbers[1]}
        counter_string=$(printf "%08d" $ifile)
        sed -i "s/$counter_string_old/$counter_string/g" $f
        sed -i "s/$counter_string_old/$counter_string/g" $f.json
        mv "$f" `basename "${f/$counter_string_old/$counter_string}"`
        mv "$f.json" `basename "${f/$counter_string_old/$counter_string}.json"`
        ifile=$((ifile+1))
    done

    rm -rf [0-9]*
    rm ${FILE%%.*}_shuf.txt

done

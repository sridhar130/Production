OLDIFS=${IFS}
if [ -f parents.txt ]; then
    printJson ${1} --parents=parents.txt > ${1}.json
else
    printJson ${1} --no-parents > ${1}.json
fi
truncate -s-3 ${1}.json
echo "," >> ${1}.json
CHECKSUMS=`ifdh checksum ${1}`
IFS=','
read -a strarr <<< "$CHECKSUMS"
CHECKSUMS="    \"Checksum\": ${strarr[0]}, ${strarr[1]} ]"
echo "${CHECKSUMS}" >> ${1}.json
echo "}" >> ${1}.json
cat ${1}.json
IFS=${OLDISF}

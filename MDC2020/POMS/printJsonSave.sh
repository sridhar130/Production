OLDIFS=${IFS}
printJson ${1} --no-parents > ${1}.json
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

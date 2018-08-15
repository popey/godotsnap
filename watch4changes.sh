
function strip {
    local STRING=${1#$"$2"}
    echo ${STRING%$"$2"}
}
#Find version
REPOVER=$(strip "$(grep ersion: "$PWD/snap/snapcraft.yaml" 2>/dev/null|sed 's/^version: "//;s/"$//')" "version: ") 
CURVER=$(strip "$REPOVER" "'")
echo "Current version is: "$CURVER
# Pull content
curl -o current https://downloads.tuxfamily.org/godotengine/ &> /dev/null
# Find version number change
for i in `seq 0 2`
do
    if [ "$i" == "0" ]
    then
        let length=$i
    else
       let length=$i+$i
    fi
    if [ "$i" == "2" ]
    then
        num=$((${CURVER:$length:1}+1))
        NEXVER=${CURVER/${CURVER:$length:1}/$num}
    else
        let len=${#CURVER}-1 
        num=$((${CURVER:$length:1}+1))
        temp=${CURVER/%${CURVER:$len:1}/"0"}
        NEXVER=${temp/${CURVER:$length:1}/$num}
    fi
    while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line = *"$NEXVER"* ]]; then
    echo "Updating files to: "$NEXVER
    # grep -rl $CURVER . --exclude-dir=.git | xargs sed -i 's/$CURVER/$NEXVER/g'
    fi
    done < "$PWD/current"
done
rm -rf "$PWD/current"
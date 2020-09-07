#!/bin/bash
if [ $1x == x ]; then
    echo "Usage: slice.sh <image-file-name>"
    exit -1
fi

if [ -f $1 ]; then
    true
else
    echo "File $1 does not exist"
    exit -2
fi

filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

for ((i = 0; i < 23; i++)); do
    let xoffset=$i*300
    let index=$i+1
    if [ $index -lt 10 ]; then
        suffix="0$index"
    else
        suffix="$index"
    fi
    echo -n "."
    convert -crop 300x2300+$xoffset+90 $1 $filename-$suffix.$extension

    filesize=$(stat -c%s "$filename-$suffix.$extension")

    if [ $filesize -lt 20000 ]; then
        rm $filename-$suffix.$extension
        echo -e "  $i files generated.\n"
        break
    fi
done

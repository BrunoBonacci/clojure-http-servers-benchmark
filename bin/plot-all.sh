#!/bin/bash


if [ "$(which hdr-plot)" == "" ] ; then
    echo "please install hdr-plot tool with:"
    echo ""
    echo "    pip3 install --user --upgrade hdr-plot"
    exit 1
fi

if [ "$1" == "" ] ; then
    echo "please provide the benchmark run you wish to plot."
    echo "eg:"
    echo "    $0 ./results/2018-05-05_16-50-17"
    exit 1
fi


export BASE=$(dirname $0)/..
export TESTS=$(ls -1 $1 | grep -v txt)

for t in $TESTS ; do
    hdr-plot --output $1/$t/${t}-latency.png --title "$t" $1/$t/*.out
done

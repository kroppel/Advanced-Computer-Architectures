#!/bin/bash
DIR=`dirname $0`

nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_hd.cu -I"$DIR"/include -o reduce_hd
nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_ld.cu -I"$DIR"/include -o reduce_ld
nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_nd.cu -I"$DIR"/include -o reduce_nd

echo "--------- KERNEL HIGH DIVERGENCE ----------"
./reduce_hd
echo "--------- KERNEL LOW DIVERGENCE ----------"
./reduce_ld
echo "--------- KERNEL NO DIVERGENCE ----------"
./reduce_nd

# cleanup
rm reduce_hd
rm reduce_ld
rm reduce_nd
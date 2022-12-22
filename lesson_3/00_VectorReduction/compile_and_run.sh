#!/bin/bash
DIR=`dirname $0`

nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_hd.cu -I"$DIR"/include -o reduce_hd
nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_ld.cu -I"$DIR"/include -o reduce_ld
nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_nd1.cu -I"$DIR"/include -o reduce_nd1
nvcc -w -std=c++11 -arch=sm_62 "$DIR"/reduce_nd2.cu -I"$DIR"/include -o reduce_nd2

echo "--------- KERNEL HIGH DIVERGENCE ----------"
./reduce_hd
echo "--------- KERNEL LOW DIVERGENCE ----------"
./reduce_ld
echo "--------- KERNEL NO DIVERGENCE V1 ----------"
./reduce_nd1
echo "--------- KERNEL NO DIVERGENCE V2 ----------"
./reduce_nd2

# cleanup
rm reduce_hd
rm reduce_ld
rm reduce_nd1
rm reduce_nd2
#!/bin/sh
output="shellGccOutput.out"
gcc $1 $FLAGS -fsanitize=address -o $output
list=""
num=0
while [ $num -lt $# ]; do
    shift
    list="$list $1"
    num=$((num+1))
done
./$output $list
rm $output


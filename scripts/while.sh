#!/bin/bash
echo $#
exit 12
i=1
while [ $i -lt 10 ]
do
    echo $i
    i=$(( i + 1 ))
done

i=1
until [ $i -gt 10 ]
do
    echo $i
    i=$(( i + 1 ))
done

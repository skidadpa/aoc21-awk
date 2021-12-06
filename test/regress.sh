#!/bin/bash
set -e
cd $(dirname $0)
for d in ../day*
do
    (
        set -x
        cd $d
        ./one.awk sample.txt
        ./one.awk input.txt
        ./two.awk sample.txt
        ./two.awk input.txt
    )
done > results.txt
( set -x; diff expected_results.txt results.txt ) && echo PASSED

#!/usr/bin/env awk -f
(NR == 1 && NF == 1) { nfish = split($1, fish, ",") }
(NR != 1 || NF != 1) { print "ERROR: bad input data"; exit 1 }
END {
    for (day = 1; day <= 80; ++day) {
        count = nfish
        for (i = 1; i <= count; ++i) if (--fish[i] < 0) { fish[i] = 6; fish[++nfish] = 8 }
    }
    print nfish
}

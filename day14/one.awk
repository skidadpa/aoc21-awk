#!/usr/bin/env awk -f
BEGIN { FS = " -> " }
(NF != (NR > 2 ? 2 : 2 - NR)) { print "ERROR: bad input"; exit 1 }
(NR == 1) { poly = $1; next }
(NR > 2) {
    n = split($1, map, "")
    if (n != 2) { print "ERROR: bad input"; exit 1 }
    rules[map[1],map[2]] = $2
}
END {
    for (step = 1; step <= 10; ++step) {
        n = split(poly, elements, "")
        nxt = elements[1]
        for (i = 1; i < n; ++i) {
            nxt = nxt rules[elements[i], elements[i+1]] elements[i+1]
        }
        poly = nxt
    }
    split(poly, elements, ""); for (i in elements) ++counts[elements[i]]; min = max = elements[1]
    for (i in counts) {
        if (counts[i] > counts[max]) max = i
        if (counts[i] < counts[min]) min = i
    }
    print counts[max] - counts[min]
}

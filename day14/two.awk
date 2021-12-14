#!/usr/bin/env awk -f
BEGIN { FS = " -> " }
(NF != (NR > 2 ? 2 : 2 - NR)) { print "ERROR: bad input"; exit 1 }
(NR == 1) { poly = $1; next }
(NR > 2) {
    n = split($1, map, "")
    elements[map[1]] = elements[map[2]] = elements[$2] = 0
    if (n != 2) { print "ERROR: bad input"; exit 1 }
    rules[map[1],map[2]] = $2
}
END {
    n = split(poly, polymer, "")
    for (i in polymer) elements[polymer[i]] = 0
    if (length(elements) * length(elements) + 2 != NR) { print "ERROR: bad input"; exit 1 }

    for (i = 1; i < n; ++i) ++pairs[polymer[i],polymer[i+1]]
    ++elements[polymer[1]]
    ++elements[polymer[n]]
    min = max = polymer[1]

    for (step = 1; step <= 40; ++step) {
        split("", nxt)
        for (c in pairs) {
            split(c, map, SUBSEP)
            nxt[map[1], rules[c]] += pairs[c]
            nxt[rules[c], map[2]] += pairs[c]
        }
        split("", pairs); for (c in nxt) pairs[c] = nxt[c]
    }

    for (c in pairs) {
        split(c, map, SUBSEP)
        elements[map[1]] += pairs[c]
        elements[map[2]] += pairs[c]
    }
    for (i in elements) {
        if (elements[i] < elements[min]) min = i
        if (elements[i] > elements[max]) max = i
    }
    print elements[max] / 2 - elements[min] / 2
}


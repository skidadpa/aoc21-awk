#!/usr/bin/env awk -f
{
    len = split($1, b, "")
    if (len > maxlen) maxlen = len
    for (i = 1; i <= len; ++i) ++count[i, b[i]]
}
END {
    for (i = 1; i <= maxlen; ++i) {
        gamma *= 2
        epsilon *= 2
        if (count[i, 0] > count[i, 1]) ++epsilon
        else if (count[i, 1] > count[i, 0]) ++gamma
        else { print "ERROR: illegal result"; exit 1 }
    }
    print gamma * epsilon
}

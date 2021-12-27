#!/usr/bin/env awk -f
(!xmax) { xmax = length($0) }
(NF != 1 || xmax != length($1) || $0 !~ /^[.v>]+$/) { print "DATA ERROR"; exit _exit=1 }
{
    n = split($1, row, ""); if (n != xmax) { print "DATA ERROR"; exit _exit=1 }
    for (x = 1; x <= xmax; ++x) {
        # floor(x,NR) = row[x]
        switch (row[x]) {
            case ">": east[1][x,NR] = 1; break
            case "v": south[1][x,NR] = 1; break
        }
    }
}
function right(coord,    c) {
    split(coord, c, SUBSEP)
    return (c[1] == xmax ? 1 : c[1] + 1) SUBSEP c[2]
}
function down(coord,    c) {
    split(coord, c, SUBSEP)
    return c[1] SUBSEP (c[2] == ymax ? 1 : c[2] + 1)
}
END {
    if (_exit) exit
    ymax = NR
    print "MERRY CHRISTMAS AND HAPPY NEW YEAR"
}

#!/usr/bin/env awk -f
BEGIN { debug = 0 }
{
    n1 = split($1, p1, ",")
    n2 = split($3, p2, ",")
    if (n1 != 2 || n2 != 2) { print "ERROR: bad input"; exit 1 }
    x1 = p1[1]
    y1 = p1[2]
    x2 = p2[1]
    y2 = p2[2]
    if (x1 != x2 && y1 != y2) {
        slope = (y2 - y1) / (x2 - x1)
        if (slope != 1 && slope != -1) { print "ERROR: bad input"; exit 1 }
    }
    xinc = (x1 == x2) ? 0 : (x1 > x2) ? -1 : 1
    yinc = (y1 == y2) ? 0 : (y1 > y2) ? -1 : 1
    x = x1 - xinc
    y = y1 - yinc
    if (debug) line = $0 " :"
    do {
        x += xinc
        y += yinc
        if (debug) line = line " " x "," y
        ++map[x, y]
    } while (x != x2 || y != y2)
    if (debug) print line
}
END {
    if (debug) for (coordinate in map) print coordinate, ":", map[coordinate]
    overlaps = 0
    for (coordinate in map) if (map[coordinate] > 1) ++overlaps
    print overlaps
}

#!/usr/bin/env awk -f
( NF != 1 ) { print "ERROR: bad data"; exit 1 }
{
    n = split($1, row, "")
    if (!xmax) xmax = n; else if (xmax != n) { print "ERROR: bad data"; exit 1 }
    for (x = 1; x <= n; ++x) cavern[x,NR] = row[x]+0
}
END {
    ymax = NR
    for (y = 1; y <= ymax; ++y) {
        for (x = 1; x <= xmax; ++x) {
            val = cavern[x,y]
            if (++val > 9) val = 1
            cavern[x + xmax,y] = val
            if (++val > 9) val = 1
            cavern[x + 2 * xmax,y] = val
            if (++val > 9) val = 1
            cavern[x + 3 * xmax,y] = val
            if (++val > 9) val = 1
            cavern[x + 4 * xmax,y] = val
        }
    }
    xmax *= 5
    for (y = 1; y <= ymax; ++y) {
        for (x = 1; x <= xmax; ++x) {
            val = cavern[x,y]
            if (++val > 9) val = 1
            cavern[x,y + ymax] = val
            if (++val > 9) val = 1
            cavern[x,y + 2 *ymax] = val
            if (++val > 9) val = 1
            cavern[x,y + 3 *ymax] = val
            if (++val > 9) val = 1
            cavern[x,y + 4 *ymax] = val
        }
    }
    ymax *= 5
    end[0][++npaths[0]] = 1 SUBSEP 1
    ends[0][1,1] = 1
    reached[1,1] = 1
    paths[0][npaths[0]][1,1] = 1
    for (risk = 0; risk <= 9 * xmax * ymax; ++risk) {
        # print risk, npaths[risk]
        for (path = 1; path <= npaths[risk]; ++path) {
            from = end[risk][path]
            reached[from] = 1
            if (from == xmax SUBSEP ymax) { print risk; exit }
            split("", ways)
            split(from, coords, SUBSEP)
            if (coords[2]+0 > 1)    ways[coords[1], coords[2]-1] = 1
            if (coords[1]+0 > 1)    ways[coords[1]-1, coords[2]] = 1
            if (coords[1]+0 < xmax) ways[coords[1]+1, coords[2]] = 1
            if (coords[2]+0 < ymax) ways[coords[1], coords[2]+1] = 1
            for (w in ways) if (!(w in paths[risk][path])) {
                nxt = risk + cavern[w]
                if (!(w in reached) && (!(nxt in ends) || !(w in ends[nxt]))) {
                    np = ++npaths[nxt]
                    end[nxt][np] = w
                    ends[nxt][w] = 1
                    for (p in paths[risk][path]) paths[nxt][np][p] = 1
                    paths[nxt][np][w] = 1
                }
            }
        }
        delete npaths[risk]
        delete paths[risk]
        delete ends[risk]
        delete end[risk]
    }
    print "ERROR: bad result"; exit 1
}


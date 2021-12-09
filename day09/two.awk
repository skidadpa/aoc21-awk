#!/usr/bin/env awk -f
BEGIN { debug = 0 }
(NF != 1) { print "ERROR: bad input"; exit 1 }
{
    n = split($1, row, "")
    if (xmax && xmax != n) { print "ERROR: bad input"; exit 1 }
    xmax = n
    for (x = 1; x <= xmax; ++x) heightmap[x,NR] = row[x]
}
function fillbasin(basinmap, x, y, basin) {
    if ((x,y) in basinmap) return
    basinmap[x,y] = basin
    if (y > 1) fillbasin(basinmap, x, y-1, basin)
    if (x > 1) fillbasin(basinmap, x-1, y, basin)
    if (y < NR) fillbasin(basinmap, x, y+1, basin)
    if (x < xmax) fillbasin(basinmap, x+1, y, basin)
}
END {
    for (y = 1; y <= NR; ++y) for (x = 1; x <= xmax; ++x) {
        if (heightmap[x,y] > 8) basinmap[x,y] = 0
        if (y > 1 && heightmap[x, y-1] <= heightmap[x,y]) continue
        if (x > 1 && heightmap[x-1, y] <= heightmap[x,y]) continue
        if (y < NR && heightmap[x, y+1] <= heightmap[x,y]) continue
        if (x < xmax && heightmap[x+1, y] <= heightmap[x,y]) continue
        lowpoint[x,y] = ++nbasins
    }
    for (i in lowpoint) {
        split(i, tmp, SUBSEP); x = tmp[1]; y = tmp[2]
        fillbasin(basinmap, x, y, lowpoint[i])
    }
    if (debug) {
        for (y = 1; y <= NR; ++y) {
            for (x = 1; x <= xmax; ++x) {
                if ((x,y) in lowpoint) printf("[%s]", heightmap[x,y] < 9 ? heightmap[x,y] : "*")
                else printf(" %s ", heightmap[x,y] < 9 ? heightmap[x,y] : "*")
            }
            printf("\n")
        }
        print nbasins, "basins"
        for (y = 1; y <= NR; ++y) {
            for (x = 1; x <= xmax; ++x) printf(" %03u", basinmap[x,y])
            printf("\n")
        }
    }
    for (i in basinmap) ++basinsizes[basinmap[i]]
    delete basinsizes[0]
    if (debug) for (i in basinsizes) print "basin", i, "size", basinsizes[i]
    asort(basinsizes)
    if (nbasins < 3) { print "ERROR: illegal result"; exit 1 }
    print basinsizes[nbasins-2] * basinsizes[nbasins-1] * basinsizes[nbasins]
}

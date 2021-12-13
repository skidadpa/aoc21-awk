#!/usr/bin/env awk -f
BEGIN { FS = "," }
(NF != 0 && NF != 2) { print "ERROR: bad input\n"; exit 1 }
(NF == 0 && FS != ",") { print "ERROR: bad input\n"; exit 1 }
(NF == 0) { FS = "="; next }
(FS == ",") { paper[$1][$2] = "#" }
(FS == "=") {
    if ($1 == "fold along x") {
        for (x in paper) {
            if (x+0 > $2+0) {
                for (y in paper[x]) paper[$2 - (x - $2)][y] = paper[x][y]
                delete paper[x]
            } else if (x == $2) { print "ERROR: bad input\n"; exit 1 }
        }
    } else if ($1 == "fold along y") {
        for (x in paper) {
            for (y in paper[x]) {
                if (y+0 > $2+0) {
                    paper[x][$2 - (y - $2)] = paper[x][y]
                    delete paper[x][y]
                } else if (y == $2) { print "ERROR: bad input\n"; exit 1 }
            }
        }
    } else { print "ERROR: bad input\n"; exit 1 }
}
END {
    for (x in paper) {
        if (x+0 > xmax) xmax = x+0
        for (y in paper[x]) if (y+0 > ymax) ymax = y+0
    }
    for (y = 0; y <= ymax; ++y) {
        for (x = 0; x <= xmax; ++x)
            printf("%s", (x in paper && y in paper[x]) ? paper[x][y] : ".")
        printf("\n")
    }
}

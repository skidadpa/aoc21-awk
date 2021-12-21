#!/usr/bin/env awk -f
BEGIN { FS = "" }
(NR == 1 && NF != 512 || NR == 2 && NF != 0) { print "DATA ERROR"; exit _exit=1 }
(NR == 1) { for (i = 1; i <= NF; ++i) if ($i == "#") program[i-1] = 1 }
(NR == 2) { next }
(NR == 3) { xmax = NF }
(NR > 2 && xmax != NF) { print "DATA ERROR"; exit _exit=1 }
{ for (x = 1; x <= xmax; ++x) if ($x == "#") image[0][x, NR-2] = 1 }
END {
    if (_exit) exit
    xmin = 1
    ymin = 1
    ymax = NR - 2
    nsteps = 2
    xmin -= nsteps + 4; ymin -= nsteps + 4; xmax += nsteps + 4; ymax += nsteps + 4
    for (step = 0; step < nsteps; ++step) {
        for (y = ymin+1; y <= ymax-1; ++y) {
            for (x = xmin+1; x <= xmax-1; ++x) {
                i = 0
                for (b=y-1; b <= y+1; ++b) for (a=x-1; a <= x+1; ++a) i = i*2 + ((a,b) in image[step])
                if (program[i]) image[step+1][x,y] = 1
            }
        }
        if ((xmin+3,ymin+3) in image[step+1]) {
            for (y = ymin; y <= ymax; ++y) {
                image[step+1][xmin,y] = image[step+1][xmin+1,y] = 1
                image[step+1][xmax,y] = image[step+1][xmax-1,y] = 1
            }
            for (x = xmin; x <= xmax; ++x) {
                image[step+1][x,ymin] = image[step+1][x,ymin+1] = 1
                image[step+1][x,ymax] = image[step+1][x,ymax-1] = 1
            }
        } else {
            for (y = ymin; y <= ymax; ++y) {
                delete image[step+1][xmin,y]
                delete image[step+1][xmin+1,y]
                delete image[step+1][xmax-1,y]
                delete image[step+1][xmax,y]
            }
            for (x = xmin; x <= xmax; ++x) {
                delete image[step+1][x,ymin]
                delete image[step+1][x,ymin+1]
                delete image[step+1][x,ymax-1]
                delete image[step+1][x,ymax]
            }
        }
    }
    if (DEBUG) for (step = 0; step <= nsteps; ++step) {
        print "step", step
        for (y = ymin; y <= ymax; ++y) {
            for (x = xmin; x <= xmax; ++x) {
                printf("%c",((x,y) in image[step]) ? "#" : ".")
            }
            printf("\n")
        }
    }

    total = 0
    for (y = ymin; y <= ymax; ++y) {
        for (x = xmin; x <= xmax; ++x) if (image[nsteps][x,y]) ++total
    }
    print total
}

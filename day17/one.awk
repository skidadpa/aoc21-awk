#!/usr/bin/env awk -f
BEGIN { FS = "[,=]" }
(NF != 4) { print "DATA ERROR"; exit _exit=1 }
{
    if (split($2, xcoords, "\\.\\.") != 2 || split($4, ycoords, "\\.\\.") != 2 ||
        xcoords[1] > xcoords[2] || ycoords[1] > ycoords[2] ||
        xcoords[2] <= 0 || ycoords[2] >= 0) { print "DATA ERROR"; exit _exit=1 }
    vY = -ycoords[1] - 1
    print vY * (vY + 1) / 2
}

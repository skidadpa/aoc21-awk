#!/usr/bin/env awk -f
BEGIN { FS = "-" }
(NF != 2 || ($1 != tolower($1) && $2 != tolower($2))) { print "ERROR: bad input"; exit 1 }
{ paths[$1][$2] = paths[$2][$1] = 1 }
function findroutes(from,    taken) {
    n = split(from, tmp, ","); here = tmp[n]; for (i in tmp) taken[tmp[i]] = 1
    if (here == "end") ++routes
    else for (path in paths[here])
        if (path != tolower(path) || !(path in taken)) findroutes(from "," path)
}
END {
    findroutes("start")
    print routes
}

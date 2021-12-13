#!/usr/bin/env awk -f
BEGIN { FS = "-" }
(NF != 2 || ($1 != tolower($1) && $2 != tolower($2))) { print "ERROR: bad input"; exit 1 }
{
    if ($2 != "start") paths[$1][$2] = 1
    if ($1 != "start") paths[$2][$1] = 1
}
function findroutes(from,    taken, repeated) {
    split("", taken)
    n = split(from, tmp, ","); here = tmp[n]
    for (i in tmp) {
        if (tmp[i] in taken && tmp[i] == tolower(tmp[i])) repeated = 1
        taken[tmp[i]] = 1
    }
    if (here == "end") ++routes
    else for (path in paths[here])
        if (path != tolower(path) || !(path in taken) || !repeated)
            findroutes(from "," path)
}
END {
    findroutes("start")
    print routes
}

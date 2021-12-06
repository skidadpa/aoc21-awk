#!/usr/bin/env awk -f
BEGIN { p3 = p2 = p1 = 99999 }
{
    if ($1 + p1 + p2 > p1 + p2 + p3) ++count
    p3=p2
    p2=p1
    p1=$1
}
END { print count }

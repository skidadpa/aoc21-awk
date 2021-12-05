#!/usr/bin/env awk -f
BEGIN {prev=99999}
{ if ($1 > prev) ++count; prev = $1 }
END { print count }

#!/usr/bin/env awk -f
/^forward/      { h += $2; d += aim * $2 }
/^down/         { aim += $2 }
/^up/           { aim -= $2 }
END             { print h * d }

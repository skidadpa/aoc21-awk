#!/usr/bin/env awk -f
BEGIN { DEBUG=0 }
(DEBUG) { print }
($0 ~! /^Player [1-2] starting position: [0-9]$/) { print "DATA ERROR"; exit _exit=1 }
{ space[$2] = $5+0 }
function roll() {
    ++nrolls
    if (++current_roll > 100) current_roll = 1
    if (DEBUG) printf("%d ", current_roll)
    return current_roll
}
function min(a, b) { return a < b ? a : b }
function next_sum(result) {
    result = roll() + roll() + roll()
    if (result == 98 + 99 + 100) mult = min(int(1000 / score[1]), int(1000 / score[2]))
    return result
}
function move_player(p) {
    if (DEBUG) printf("%d: Player %d rolls ", turn, p)
    space[p] = (space[p] - 1 + next_sum()) % 10 + 1
    score[p] += space[p]
    if (DEBUG) print "and moves to space", space[p], "for a total score of", score[p]
    if (DEBUG) if (score[p]+0 >= 1000) winner = p
    if (score[p]+0 >= 1000) return 1
    loser = p
    return 0
}
END {
    while (++turn <= 1000) {
        if (move_player(1)) break
        if (move_player(2)) break
        if (mult) {
            turn *= mult; nrolls *= mult; score[1] *= mult; score[2] *= mult
            if (score[1] >= 1000) winner = 1
            if (score[2] >= 1000) winner = 2
            if (winner) { loser = 3 - winner; break }
            mult = ""
        }
    }
    if (DEBUG) {
        print "After", nrolls, "rolls:"
        print winner, "wins with", score[winner]
        print loser, "loses with", score[loser]
    }
    print score[loser] * nrolls
}

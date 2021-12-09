#!/usr/bin/env awk -f
(NR == 1) {
    if (NF != 1) { print "ERROR: bad input"; exit 1 }
    drawcount = split($0, draws, ",")
}
(NR > 1 && (NR - 2) % 6 == 0 && NF != 0) { print "ERROR: bad input"; exit 1 }
(NR > 1 && (NR - 2) % 6 > 0) {
    if (NF != 5) { print "ERROR: bad input"; exit 1 }
    board = int((NR + 3) / 6)
    row = (NR - 2) % 6
    boards[board, row, 1] = $1
    boards[board, row, 2] = $2
    boards[board, row, 3] = $3
    boards[board, row, 4] = $4
    boards[board, row, 5] = $5
    if (board > boardcount) boardcount = board
}
function find_winners(    board, row, col, allmatch) {
    for (board = 1; board <= boardcount; ++board) {
        for (row = 1; row <= 5; ++row) {
            for (col = 1; col <= 5; ++col) {
                allmatch = boards[board, row, col] in drawn
                if (!allmatch) break
            }
            if (allmatch) break
        }
        if (allmatch) {
            winners[board] = 1
            continue
        }
        for (col = 1; col <= 5; ++col) {
            for (row = 1; row <= 5; ++row) {
                allmatch = boards[board, row, col] in drawn
                if (!allmatch) break
            }
            if (allmatch) break
        }
        if (allmatch) winners[board] = 1
    }
}
function board_score(board,    row, col, score) {
    score = 0
    for (row = 1; row <= 5; ++row)
        for (col = 1; col <= 5; ++col)
            if (!(boards[board, row, col] in drawn))
                score += boards[board, row, col]
    return score
}
END {
    if (drawcount < 5) { print "ERROR: bad input"; exit 1 }
    for (draw = 1; draw <= 4; ++draw) drawn[draws[draw]] = 1
    split("", winners)
    split("", pastwinners)
    for (draw = 5; draw <= drawcount; ++draw) {
        drawn[draws[draw]] = 1
        find_winners()
        if (length(winners) >= boardcount) break
        for (winner in winners) pastwinners[winner] = 1
    }
    if (length(winners) < boardcount) { print "ERROR: illegal result"; exit 1 }
    split("", lastwinners)
    for (winner in winners) if (!(winner in pastwinners)) lastwinners[winner] = 1
    if (length(lastwinners) > 1) print "WARNING: multiple winners, reporting all scores"
    for (board in lastwinners) {
        print board_score(board) * draws[draw]
    }
}

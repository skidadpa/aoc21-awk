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
    for (draw = 5; draw <= drawcount; ++draw) {
        drawn[draws[draw]] = 1
        find_winners()
        if (length(winners) > 0) break
    }
    if (length(winners) < 1) { print "ERROR: illegal result"; exit 1 }
    if (length(winners) > 1) print "WARNING: multiple winners, choosing best score"
    for (board in winners) {
        s = board_score(board)
        if (s > score) score = s
    }
    print score * draws[draw]
}

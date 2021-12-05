#!/usr/bin/env awk -f
BEGIN {
    debug = 0
    deepdebug = 0
}
function join(array, start, end, sep,    result, i) {
    if (sep == "") sep = " "; else if (sep == SUBSEP) sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++) result = result sep array[i]
    return result
}
(NR == 1) {
    if (NF != 1) {
        print "ERROR: first record should contain only one set of comma-separated numbers"
        exit 1
    }
    drawcount = split($0, draws, ",")
    if (debug) print drawcount, "draws:", join(draws, 1, drawcount)
}
(NR > 1 && (NR - 2) % 6 == 0) {
    if (NF != 0) {
        print "ERROR: board separators should be empty lines"
        exit 1
    }
}
(NR > 1 && (NR - 2) % 6 > 0) {
    if (NF != 5) {
        print "ERROR: board row should contain exactly five numbers"
        exit 1
    }
    board = int((NR + 3) / 6)
    row = (NR - 2) % 6
    boards[board][row][1] = $1
    boards[board][row][2] = $2
    boards[board][row][3] = $3
    boards[board][row][4] = $4
    boards[board][row][5] = $5
    if (board > boardcount) boardcount = board
    if (debug) print "board", board,"row", row, ":", $0
}
function find_winners(    board, row, col, allmatch) {
    for (board = 1; board <= boardcount; ++board) {
        if (deepdebug) print "checking board", board, "rows"
        for (row = 1; row <= 5; ++row) {
            if (deepdebug) {
                disp = ""
                for (col = 1; col <= 5; ++col) disp = disp " " boards[board][row][col]
                print "row", row, "-" disp
            }

            for (col = 1; col <= 5; ++col) {
                allmatch = boards[board][row][col] in drawn
                if (!allmatch) break
            }
            if (allmatch) break
        }
        if (allmatch) {
            winners[board] = 1
            continue
        }
        if (deepdebug) print "checking board", board, "columns"
        for (col = 1; col <= 5; ++col) {
            if (deepdebug) {
                disp = ""
                for (row = 1; row <= 5; ++row) disp = disp " " boards[board][row][col]
                print "column", col, "-" disp
            }

            for (row = 1; row <= 5; ++row) {
                allmatch = boards[board][row][col] in drawn
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
            if (!(boards[board][row][col] in drawn))
                score += boards[board][row][col]
    return score
}
END {
    if (debug) print "boardcount:", boardcount
    if (drawcount < 5) {
        print "ERROR: need at least 5 draws to win, there were only", drawcount
        exit 1
    }
    for (draw = 1; draw <= 4; ++draw) drawn[draws[draw]] = 1
    split("", winners)
    for (draw = 5; draw <= drawcount; ++draw) {
        drawn[draws[draw]] = 1
        find_winners()
        if (length(winners) > 0) break
    }
    if (length(winners) < 1) {
        print "ERROR: no winners found after", drawcount, "draws"
        exit 1
    }
    if (length(winners) > 1) print "WARNING: multiple winners, choosing best score"
    for (board in winners) {
        s = board_score(board)
        if (s > score) score = s
    }
    print score * draws[draw]
}

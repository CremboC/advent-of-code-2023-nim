import day09Input as day09
import util
import times

import strutils
import strformat
import sequtils
import deques

type NewRow = tuple
  row: seq[int]
  allZeroes: bool

func createIncrRow(s: seq[int]): NewRow =
  result.allZeroes = true
  for pair in s.slidingWindow(2):
    let diff = pair[1] - pair[0]
    if diff != 0: result.allZeroes = false
    result.row.add(diff)

func part1(): int =
  let lines = day09.input.splitLines.mapIt(it.splitWhitespace.map(parseInt))
  for line in lines:
    var rows = @[line].toDeque
    var originRow = line
    while true:
      var (row, allZeroes) = createIncrRow(originRow)
      rows.addFirst(row)
      if allZeroes: break
      swap(originRow, row)

    var prevElem: int = rows.popFirst[^1]
    while rows.len > 0: prevElem += rows.popFirst[^1]
    result += prevElem
  result

func part2(): int =
  let lines = day09.input.splitLines.mapIt(it.splitWhitespace.map(parseInt))
  for line in lines:
    var rows = @[line].toDeque
    var originRow = line
    while true:
      var (row, allZeroes) = createIncrRow(originRow)
      rows.addFirst(row)
      if allZeroes: break
      swap(originRow, row)

    var prevElemMin: int = rows.popFirst[0]
    while rows.len > 0:
      prevElemMin = rows.popFirst[0] - prevElemMin
    result += prevElemMin
  result

block:
  let start = cpuTime()
  let result = part1()
  let finish = cpuTime()
  echo fmt"Part 1 [t={(finish - start):.5f}s]: {result}"

block:
  let start = cpuTime()
  let result = part2()
  let finish = cpuTime()
  echo fmt"Part 2 [t={(finish - start):.5f}s]: {result}"

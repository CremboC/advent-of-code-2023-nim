import day14Input as input
import util

import strutils
import strformat
import sequtils
import arraymancer
import times
import options

proc part1(): int =
  var t = input.input.splitLines.mapIt(it.toSeq).toTensor
  for x, col in t.enumerateAxis(1):
    var y = 0
    while y < col.shape[0]:
      if t[y, x] == 'O' or t[y, x] == '#':
        inc(y)
        continue
      # otherwise we got an empty spot, we can move a O into it
      # find next O
      var nextO: int = -1
      var nextHash: int = -1
      for coord, yy in t[y.._, x]:
        if yy == '#':
          nextHash = coord[0]
          break
        if yy == 'O':
          nextO = coord[0]
          break
      if nextHash != -1:
        # skip rows to the next hash if we found it
        y += nextHash
        continue
      if nextO != -1:
        # we found the next circle, move it here
        # and remove it from where we found it
        t[y, x] = 'O'
        t[y + nextO, x] = '.'
      inc(y)

  func rowCost(idx: int): int =
    t.shape[0] - idx

  for y, row in t.enumerateAxis(0):
    for el in row:
      if el == 'O':
        result += y.rowCost

proc part2(): int =
  var t = input.example.splitLines.mapIt(it.toSeq).toTensor

block:
  let start = cpuTime()
  let result = part1()
  let finish = cpuTime()
  echo fmt"Part 1 [t={((finish - start) * 1000):.2f}ms]: {result}"

block:
  let start = cpuTime()
  let result = part2()
  let finish = cpuTime()
  echo fmt"Part 2 [t={((finish - start) * 1000):.2f}ms]: {result}"

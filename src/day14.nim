import day14Input as input

import strutils
import strformat
import sequtils
import arraymancer
import times
import tables

proc part1(): int =
  var t = input.input.splitLines.mapIt(it.toSeq).toTensor
  let yMax = t.shape[0]
  for x, col in t.enumerateAxis(1):
    var wallIdx = -1
    var y, rockCount, emptyCount = 0
    proc updateCol() =
      if rockCount > 0:
        t[(wallIdx+1)..<wallIdx+1+rockCount, x] = 'O'
      if emptyCount > 0:
        t[(wallIdx+1+rockCount)..<wallIdx+1+rockCount+emptyCount, x] = '.'
      rockCount = 0
      emptyCount = 0
      wallIdx = y
    while y < yMax:
      if t[y, x] == '#':
        updateCol()
        inc(y)
        continue
      elif t[y, x] == 'O': inc(rockCount)
      elif t[y, x] == '.': inc(emptyCount)

      if y == yMax - 1:
        updateCol()
      inc(y)

  for y, row in t.enumerateAxis(0):
    for el in row:
      if el == 'O':
        result += yMax - y

proc part2(): int =
  var t = input.input.splitLines.mapIt(it.toSeq).toTensor
  let
    yMax = t.shape[0]
    xMax = t.shape[1]

  proc tiltNorth() =
    for x, col in t.enumerateAxis(1):
      var wallIdx = -1
      var y, rockCount, emptyCount = 0
      proc updateCol() =
        if rockCount > 0:
          t[(wallIdx+1)..<wallIdx+1+rockCount, x] = 'O'
        if emptyCount > 0:
          t[(wallIdx+1+rockCount)..<wallIdx+1+rockCount+emptyCount, x] = '.'
        rockCount = 0
        emptyCount = 0
        wallIdx = y
      while y < yMax:
        if t[y, x] == '#':
          updateCol()
          inc(y)
          continue
        elif t[y, x] == 'O': inc(rockCount)
        elif t[y, x] == '.': inc(emptyCount)

        if y == yMax - 1:
          updateCol()
        inc(y)

  proc tiltSouth() =
    t = t[_|-1]
    tiltNorth()
    t = t[_|-1]

  proc tiltWest() =
    for y, row in t.enumerateAxis(0):
      var wallIdx = -1
      var x, rockCount, emptyCount = 0
      proc updateRow() =
        if rockCount > 0:
          t[y, (wallIdx+1)..<wallIdx+1+rockCount] = 'O'
        if emptyCount > 0:
          t[y, (wallIdx+1+rockCount)..<wallIdx+1+rockCount+emptyCount] = '.'
        rockCount = 0
        emptyCount = 0
        wallIdx = x
      while x < xMax:
        if t[y, x] == '#':
          updateRow()
          inc(x)
          continue
        elif t[y, x] == 'O': inc(rockCount)
        elif t[y, x] == '.': inc(emptyCount)

        if x == xMax - 1:
          updateRow()
        inc(x)

  proc tiltEast() =
    t = t[_, _|-1]
    tiltWest()
    t = t[_, _|-1]

  proc cycle() =
    tiltNorth()
    tiltWest()
    tiltSouth()
    tiltEast()

  var hash = initTable[seq[char], int](256)
  hash[t.toFlatSeq] = 0
  var i: int
  var sameAs: int
  while true:
    cycle()
    if hash.hasKeyOrPut(t.toFlatSeq, i):
      sameAs = hash[t.toFlatSeq]
      break
    inc(i)

  let totalSteps = 1_000_000_000
  let cycleStart = sameAs
  let cycleLength = i - sameAs
  # good old off-by-one error :)
  let stepInCycle = (((totalSteps - cycleStart) mod cycleLength) + cycleStart) - 1

  for k, v in hash:
    if v == stepInCycle:
      t = k.toTensor.reshape(yMax, xMax)
      break

  for y, row in t.enumerateAxis(0):
    for el in row:
      if el == 'O':
        result += yMax - y

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

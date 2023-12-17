import day15Input as input
import util

import strutils
import strformat
import sequtils
import times

proc part1(): int =
  const strings = input.input.split(',')
  for s in strings:
    result += s.foldl(((a + int(b)) * 17).mod(256), 0)

proc part2(): int =
  1

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

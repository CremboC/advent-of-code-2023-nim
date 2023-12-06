import day04Input as day04
import times

import strutils
import math
import strformat
import sequtils
import sets
import tables

import pkg/strides

func part1*(): int =
  for line in day04.input.splitLines():
    let
      split = line.split({ ':', '|' })
      winners = split[1].splitWhitespace().mapIt(parseInt(it)).toHashSet()
      my = split[2].splitWhitespace().mapIt(parseInt(it))
      matches = foldl(my, if winners.contains(b): a + 1 else: a, -1)

    if matches >= 0:
      result += 2^matches

  result

func part2*(): int =
  const lines = day04.input.splitLines()
  var sizes: Table[int, int]
  for idx in (lines.high)..0 @: -1:
    let
      split = lines[idx].split({ ':', '|' })
      cardNumber = split[0].splitWhitespace()[1].parseInt()
      winners = split[1].splitWhitespace().mapIt(parseInt(it)).toHashSet()
      my = split[2].splitWhitespace().mapIt(parseInt(it))
      matches = foldl(my, if winners.contains(b): a + 1 else: a, 0)
      size = foldl((cardNumber + 1)..(cardNumber + matches), sizes.getOrDefault(b, 0) + a, matches)

    sizes[cardNumber] = size
    result += 1 + size
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

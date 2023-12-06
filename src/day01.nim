import day01Input as day01

import strformat
import strutils
import sequtils
import sugar
import tables
import algorithm

func part1(): int =
  const
    digits = { '0'..'9' }
    lines = day01.input.splitLines()
  foldl(lines, a + parseInt(b[b.find(digits)] & b[b.rfind(digits)]), 0)

type Digit = tuple
  idx: int
  ch: char

func part2(): int =
  var
    lines = day01.input.splitLines()
    digits = { '0'..'9' }
    map = {
      "one": '1',
      "two": '2',
      "three": '3',
      "four": '4',
      "five": '5',
      "six": '6',
      "seven": '7',
      "eight": '8',
      "nine": '9',
    }.toTable

  for l in lines:
    var checks: seq[Digit]
    let
      firstIdx = l.find(digits)
      secondIdx = l.rfind(digits)
    checks.add((firstIdx, l[firstIdx]))
    checks.add((secondIdx, l[secondIdx]))

    for (word, digit) in map.mpairs:
      let idx = l.find(word)
      if idx >= 0: checks.add((idx, digit))
      let idxEnd = l.rfind(word)
      if idxEnd >= 0: checks.add((idxEnd, digit))

    checks.sort((x, y) => cmp(x.idx, y.idx))
    result += parseInt(checks[0].ch & checks[^1].ch)
  result

import times

block:
  let start = cpuTime()
  let result = part1()
  let finish = cpuTime()
  echo fmt"Part 1: {result} in {finish - start} seconds"

block:
  let start = cpuTime()
  let result = part2()
  let finish = cpuTime()
  echo fmt"Part 2: {result} in {finish - start} seconds"

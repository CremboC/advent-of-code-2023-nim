import day03Input as day03
import times
import util

import strformat
import strutils
import sequtils
import tables
import std/enumerate

func part1(): int =
  var input = day03.input.splitLines().mapIt(fmt".{it}.")
  input[0] = ".".repeat(input[1].len())
  input[^1] = ".".repeat(input[1].len())

  for (y, line) in enumerate(input):
    if y == input.low or y == input.high: continue
    var digits: seq[char]
    for (x, c) in enumerate(line):
      var doCheck = false
      if isDigit(c):
        digits.add(c)
      else:
        doCheck = digits.len() > 0

      if doCheck:
        var touchesSymbol = false
        block check:
          for yd in (y - 1)..(y + 1):
            for xd in (x - digits.len() - 1)..(x):
              if input[yd][xd] == '.' or isDigit(input[yd][xd]): continue
              touchesSymbol = true
              break check

        if touchesSymbol:
          result += parseInt(digits.toString())

        digits = @[]
  result

func part2(): int =
  var
    input = day03.input.splitLines().mapIt(fmt".{it}.")
    map = initTable[(int, int), (int, int)]()
  input[0] = ".".repeat(input[1].len())
  input[^1] = ".".repeat(input[1].len())

  for (y, line) in enumerate(input):
    if y == input.low or y == input.high: continue
    var digits: seq[char]
    for (x, c) in enumerate(line):
      var doCheck = false
      if isDigit(c):
        digits.add(c)
      else:
        doCheck = digits.len() > 0

      if doCheck:
        block check:
          for yd in (y - 1)..(y + 1):
            for xd in (x - digits.len() - 1)..(x):
              if input[yd][xd] == '.' or isDigit(input[yd][xd]) or input[yd][xd] != '*': continue
              let
                key = (yd, xd)
                num = parseInt(digits.toString())
              if map.hasKey(key):
                map[key] = (map[key][0], num)
              else:
                map[key] = (num, 0)
              break check
        digits = @[]
  for (k, v) in map.pairs:
    if v[1] != 0:
      result += v[0] * v[1]
  result

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

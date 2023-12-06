import day02Input as day02

import strformat
import strutils
import sequtils
import tables

func part1(): int =
  const lines = day02.input.splitLines()
  const t = {"red": 12, "green": 13, "blue": 14}.toTable

  func isValidLine(split: seq[string]): bool =
    for s in split[1..^1]:
      let parsed = s.split(',').mapIt(it.splitWhitespace()).mapIt((parseInt(it[0]), it[1]))
      for (value, colour) in parsed:
        if value > t[colour]:
          return false
    true

  for l in lines:
    let split = l.split({':', ';'})
    if isValidLine(split):
      result += parseInt(split[0].splitWhitespace()[1])
  result

func part2(): int =
  const lines = day02.input.splitLines()

  func getMins(split: seq[string]): Table[string, int] =
    var mins = {"red": 0, "green": 0, "blue": 0}.toTable
    for s in split[1..^1]:
      let parsed = s.split(',').mapIt(it.splitWhitespace()).mapIt((parseInt(it[0]), it[1]))
      for (value, colour) in parsed:
        if mins[colour] < value:
          mins[colour] = value
    mins

  for l in lines:
    var mins = getMins(l.split({':', ';'}))
    result += (mins["red"] * mins["green"] * mins["blue"])
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

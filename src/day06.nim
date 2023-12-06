import day06Input as day06

import std/[strformat, strutils, sequtils]

func part1*(): int =
  const
    lines = day06.input.splitLines()
    times = map(lines[0].splitWhitespace()[1..^1], parseInt)
    distances = map(lines[1].splitWhitespace()[1..^1], parseInt)

  var answer = 1
  for idx in 0 ..< times.len:
    answer *= foldl(1..<times[idx], if b * (times[idx] - b) > distances[idx]: a + 1 else: a, 0)

  return answer

func part2*(): int =
  const
    lines = day06.input.splitLines()
    time = parseInt(lines[0][5..^1].replace(" ", ""))
    distance = parseInt(lines[1][9..^1].replace(" ", ""))
  return foldl(1..<time, if b * (time - b) > distance: a + 1 else: a, 0)

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

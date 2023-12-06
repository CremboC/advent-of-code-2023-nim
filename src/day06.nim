import day06Input as day06

import std/[strformat, strutils]

func part1*(): int =
  const
    lines = day06.input.splitLines()
    times = lines[0].splitWhitespace()
    distances = lines[1].splitWhitespace()

  var answer = 1
  for idx in 1 ..< times.len:
    let
      time = parseInt(times[idx])
      distance = parseInt(distances[idx])
    var winners = 0

    for heldTime in 1..<time:
      let d = heldTime * (time - heldTime)
      if d > distance:
        inc(winners)

    answer *= winners
  return answer

func part2*(): int =
  const
    lines = day06.input.splitLines()
    time = parseInt(lines[0][5..^1].replace(" ", ""))
    distance = parseInt(lines[1][9..^1].replace(" ", ""))

  var winners = 0
  for heldTime in 1..<time:
    let d = heldTime * (time - heldTime)
    if d > distance:
      inc(winners)

  return winners

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

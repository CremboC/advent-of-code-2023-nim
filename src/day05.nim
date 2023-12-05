import day05Input as day05
import util

import std/[sugar, sets, strscans, strformat, deques]
import strutils

import pkg/strides

func part1*(): int =
  var
    lines = day05.input.splitLines()
    ws = lines[0].splitWhitespace()

  let seeds = collect(initOrderedSet):
    for w in ws[1 ..< ws.len]:
      { parseInt(w) }

  var
    lookups = newSeq[seq[(Slice[int], Slice[int])]](7)
    isReadingMap = true
    idx = 0

  for l in lines[3 ..< lines.len]:
    if l.isEmptyOrWhitespace():
      inc(idx)
      isReadingMap = false
    elif l.contains("map"):
      isReadingMap = true
    elif isReadingMap:
      var dest, src, len: int
      discard scanf(l, "$i $i $i", dest, src, len)
      lookups[idx].add((src..(src + len), dest..(dest + len)))

  var min: int = high(int)
  for s in seeds:
    var currentDest: int = s
    for lookup in lookups:
      for (src, dest) in lookup:
        if src.contains(currentDest):
          currentDest = dest[currentDest - src.a]
          break
    if currentDest < min:
      min = currentDest
  return min

func part2*(): int =
  var
    lines = day05.input.splitLines()
    ws = lines[0].splitWhitespace()

  var seeds = newSeq[HSlice[int, int]]()
  for idx in 1 ..< ws.len @: 2:
    let
      start = parseInt(ws[idx])
      len = parseInt(ws[min(idx + 1, ws.len - 1)])
    seeds.add(start..(start + len - 1))

  var
    steps = newSeq[seq[(Slice[int], Slice[int])]](7)
    isReadingMap = true
    idx = 0

  for l in lines[3 ..< lines.len]:
    if l.isEmptyOrWhitespace():
      inc(idx)
      isReadingMap = false
    elif l.contains("map"):
      isReadingMap = true
    elif isReadingMap:
      var dest, src, len: int
      discard scanf(l, "$i $i $i", dest, src, len)
      steps[idx].add((src..(src + len - 1), dest..(dest + len - 1)))

  var
    currentDests = seeds.toDeque
    nextDests: Deque[Slice[int]]

  for step in steps:
    while currentDests.len() > 0:
      let currentDest = currentDests.popFirst()
      var foundLookup = false
      block stepLookup:
        for (src, dest) in step:
          let intersection = currentDest.intersect(src)
          if intersection.len() > 0:
            let mappedDest = dest[intersection[0].a - src.a]..dest[intersection[0].b - src.a]
            nextDests.addLast(mappedDest)
            for i in intersection[1..^1]: currentDests.addLast(i)

            foundLookup = true
            break stepLookup
      if not foundLookup: nextDests.addLast(currentDest)
    swap(currentDests, nextDests)

  var min = high(int)
  for i in currentDests:
    if i.a < min:
      min = i.a

  return min

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

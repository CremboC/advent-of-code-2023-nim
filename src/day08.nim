import day08Input as day08
import times

import strutils
import strformat
import sequtils
import sets
import tables
import sugar
import std/enumerate
import algorithm
import strscans
import lists
import deques

import pkg/strides

func part1(): int =
  const lines = day08.input.splitLines()
  let instr = block:
    var ring = initSinglyLinkedRing[char]()
    for s in lines[0]:
      ring.add(newSinglyLinkedNode[char](s))
    ring
  let locs = lines[2..^1].mapIt((block:
      var f, l, r: string
      discard scanf(it, "$+ = ($+, $+)", f, l, r)
      (f, (l, r))
    )).toTable

  var current = "AAA"
  var currentInstr = instr.head
  while current != "ZZZ":
    if currentInstr.value == 'L':
      current = locs[current][0]
    else:
      current = locs[current][1]

    currentInstr = currentInstr.next
    result += 1

  result


proc part2(): int =
  const lines = day08.input.splitLines()
  let instr = block:
    var ring = initSinglyLinkedRing[char]()
    for s in lines[0]:
      ring.add(newSinglyLinkedNode[char](s))
    ring
  let locLookup = lines[2..^1].mapIt((block:
      var f, l, r: string
      discard scanf(it, "$+ = ($+, $+)", f, l, r)
      (f, (l, r))
    )).toTable


  # all locations ending with A
  var currentLocs = block:
    var deque = initDeque[string](10)
    for l in locLookup.keys:
      if l[^1] == 'A':
        deque.addLast(l)
    deque
  var currentInstr = instr.head

  # do one step at at time
  # var reachedEnd = false
  while true:
    if result.mod(100000) == 0:
      echo result
      # echo currentLocs

    var nextLocs = initDeque[string](10)
    var locsEndingZ = 0
    var totalNextLocs = 0
    while currentLocs.len() > 0:
      let loc = currentLocs.popFirst
      let nextLoc: string = block:
        if currentInstr.value == 'L': locLookup[loc][0]
        else: locLookup[loc][1]
      if nextLoc[^1] == 'Z': inc(locsEndingZ)
      nextLocs.addLast(nextLoc)
      inc(totalNextLocs)

      # 6.103.600.000

    result += 1

    let diffToTarget = totalNextLocs - locsEndingZ

    if diffToTarget < 4:
      echo diffToTarget
      echo nextLocs

    if diffToTarget == 0:
      break

    swap(currentLocs, nextLocs)
    currentInstr = currentInstr.next

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

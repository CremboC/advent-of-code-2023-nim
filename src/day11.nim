import day11Input as day
import times

import strutils
import strformat
import sequtils
import heapqueue
import tables
import sugar
import sets
import arraymancer
import deques
import std/enumerate
import std/monotimes

type Loc = tuple
  y: int
  x: int

type LocP = object
  loc: Loc
  priority: int

proc `<`(a, b: LocP): bool =
  a.priority < b.priority

iterator neighbors(loc: Loc): Loc =
  yield (loc.y - 1, loc.x)
  yield (loc.y, loc.x - 1)
  yield (loc.y, loc.x + 1)
  yield (loc.y + 1, loc.x)

func rebuildPath(cameFrom: Table[Loc, Loc], current: Loc): Deque[Loc] =
  var curr = current
  while cameFrom.contains(curr):
    result.addLast(curr)
    curr = cameFrom[curr]

proc cost(x, y: Loc): int =
  abs(y.y - x.y) + abs(y.x - x.x)

func astar(start, goal: Loc, h: ((Loc, Loc) {.noSideEffect.} -> int)): Deque[Loc] =
  var
    openSet = @[LocP(loc: start, priority: h(start, goal))].toHeapQueue
    cameFrom: Table[Loc, Loc]
    gScore = { start: 0 }.toTable
    fScore = { start: h(start, goal) }.toTable

  while openSet.len > 0:
    let current = openSet.pop
    if current.loc == goal:
      return rebuildPath(cameFrom, current.loc)

    for neighbor in neighbors(current.loc):
      if neighbor != current.loc:
        let tentativeScore = gScore[current.loc] + 0
        if tentativeScore < gScore.getOrDefault(neighbor, high(int)):
          cameFrom[neighbor] = current.loc
          gScore[neighbor] = tentativeScore
          fScore[neighbor] = tentativeScore + h(neighbor, goal)
          openSet.push(LocP(loc: neighbor, priority: fScore[neighbor]))

proc solveForInput(input: string, multi: int): int =
  let
    matrix = input.splitLines.mapIt(it.toSeq).toTensor
    emptyY = collect:
      for idx, l in matrix.enumerateAxis(0):
        if l.allIt(it == '.'):
          { idx }
    emptyX = collect:
      for idx, l in matrix.enumerateAxis(1):
        if l.allIt(it == '.'):
          { idx }

  let galaxyLocs = collect:
    for loc, n in matrix:
      if n == '#':
        (loc[0], loc[1])

  let pairs = block:
    var pairs = initHashSet[(Loc, Loc)]()
    for i in galaxyLocs:
      for j in galaxyLocs:
        if i != j and not pairs.contains((j, i)):
          pairs.incl((i, j))
    pairs

  for idx, (f, t) in enumerate(pairs):
    let path = astar(f, t, cost)
    var dist: int
    for el in path:
      var incr = 1
      if el.y in emptyY:
        incr *= multi
      if el.x in emptyX:
        incr *= multi
      dist += incr
    result += dist

proc part1(): int =
  solveForInput(day.input, 2)

proc part2(): int =
  solveForInput(day.input, 1_000_000)

assert(solveForInput(day.example1, 1) == 3, "m=1")
assert(solveForInput(day.example1, 2) == 4, "m=2")
assert(solveForInput(day.example1, 3) == 5, "m=3")

assert(solveForInput(day.example2, 1) == 4, "m=1")
assert(solveForInput(day.example2, 2) == 6, "m=2")
assert(solveForInput(day.example2, 3) == 8, "m=3")

assert(solveForInput(day.example, 2) == 374, "m=2")
assert(solveForInput(day.example, 10) == 1030, "m=10")
assert(solveForInput(day.example, 100) == 8410, "m=100")

block:
  let start = getMonoTime()
  let result = part1()
  let finish = getMonoTime()
  echo fmt"Part 1 [t={(finish - start).inMilliseconds}ms]: {result}"

block:
  let start = getMonoTime()
  let result = part2()
  let finish = getMonoTime()
  echo fmt"Part 2 [t={(finish - start).inMilliseconds}ms]: {result}"

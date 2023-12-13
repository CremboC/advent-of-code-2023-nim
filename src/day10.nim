import day10Input as input
import util
import times

import strutils
import strformat
import sequtils
import deques
import tables
import sugar
import sets
import unicode
import arraymancer

import strides

func convertToUtf8(s: char): string =
  case s:
    of '-': Rune(0x2500).toUTF8
    of '|': Rune(0x2502).toUTF8
    of 'F': Rune(0x250C).toUTF8
    of '7': Rune(0x2510).toUTF8
    of 'L': Rune(0x2514).toUTF8
    of 'J': Rune(0x2518).toUTF8
    else: @[s].toString

proc prettyPrintTensor(t: Tensor[char]) =
  for y in 0..<t.shape[0]:
    for x in 0..<t.shape[1]:
      stdout.write(t[y, x].convertToUtf8)
    echo ""
  echo ""

type Coord = tuple
  y: int
  x: int

func west(v: Coord): Coord = (v.y, v.x - 1)
func north(v: Coord): Coord = (v.y - 1, v.x)
func east(v: Coord): Coord = (v.y, v.x + 1)
func south(v: Coord): Coord = (v.y + 1, v.x)

func at(matrix: seq[string], coord: Coord): char =
  matrix[coord.y][coord.x]

func findStart(matrix: seq[string], maxY, maxX: int): Coord =
  for y in 1..<maxY:
    for x in 1..<maxX:
      if matrix[y][x] == 'S':
        return (y, x)

func contractSubGrid(t: Tensor[char]): char =
  if t[1, 0] == '#' and t[2, 1] == '#': '7'
  elif t[1, 0] == '#' and t[0, 1] == '#': 'J'
  elif t[1, 0] == '#' and t[1, 2] == '#': 'L'
  elif t[1, 2] == '#' and t[2, 1] == '#': 'F'
  elif t[1, 0] == '#': '-'
  elif t[1, 1] == '#': '|'
  elif t[1, 1] == 'O': 'O'
  elif t[1, 1] == 'I': 'I'
  else: '.'

proc contractMatrix(t: Tensor[char]): Tensor[char] =
  var grid: seq[seq[char]]
  for y in 0..<t.shape[0] @: 3:
    var line: seq[char]
    for x in 0..<t.shape[1] @: 3:
      let ch = contractSubGrid(t[y..(y+2), x..(x+2)])
      line.add(ch)
    grid.add(line)
  grid.toTensor

func part1(): int =
  let matrix = block:
    var inp = input.input.splitLines.mapIt(fmt".{it}.")
    inp[0] = ".".repeat(inp[1].len)
    inp[^1] = ".".repeat(inp[1].len)
    inp

  let maxY = matrix.len
  let maxX = matrix[0].len

  # find starting point
  let startCoord = findStart(matrix, maxY, maxX)
  var
    distanceMap = { startCoord: 0 }.toTable
    queue: Deque[(Coord, int)] = @[(startCoord, 0)].toDeque

  while queue.len() > 0:
    let
      (v, dist) = queue.popFirst()
      w = west(v)
      e = east(v)
      n = north(v)
      s = south(v)

    # check possible moves
    let possibleMoves = case matrix.at(v):
      of '|': @[n, s]
      of '-': @[e, w]
      of 'L': @[n, e]
      of 'J': @[n, w]
      of '7': @[s, w]
      of 'F': @[s, e]
      of 'S':
        var outs: seq[Coord]
        if matrix.at(n) == '|' or matrix.at(n) == 'F' or matrix.at(s) == '7':
          outs.add(n)
        if matrix.at(s) == '|' or matrix.at(s) == 'J' or matrix.at(s) == 'L':
          outs.add(s)
        if matrix.at(e) == '-' or matrix.at(e) == 'J' or matrix.at(e) == '7':
          outs.add(e)
        if matrix.at(w) == '-' or matrix.at(w) == 'L' or matrix.at(w) == 'F':
          outs.add(w)
        outs
      else: @[]

    for mv in possibleMoves:
      if not distanceMap.hasKeyOrPut(mv, dist + 1):
        queue.addLast((mv, dist + 1))

  distanceMap.values.toSeq.max

proc part2(): int =
  var matrix = block:
    var inp = input.input.splitLines.mapIt(fmt".{it}.".toSeq)
    inp[0] = ".".repeat(inp[1].len).toSeq
    inp[^1] = ".".repeat(inp[1].len).toSeq
    inp.toTensor

  let maxY = matrix.shape[0]
  let maxX = matrix.shape[1]

  # find starting point
  let startCoord = block:
    var l: Coord
    for loc, c in matrix:
      if c == 'S':
        l = (loc[0], loc[1])
        break
    l
  var
    distanceMap = { startCoord: 0 }.toTable
    queue: Deque[(Coord, int)] = @[(startCoord, 0)].toDeque

  while queue.len() > 0:
    let
      (v, dist) = queue.popFirst()
      w = west(v)
      e = east(v)
      n = north(v)
      s = south(v)

    # check possible moves
    let possibleMoves = case matrix[v.y, v.x]:
      of '|': @[n, s]
      of '-': @[e, w]
      of 'L': @[n, e]
      of 'J': @[n, w]
      of '7': @[s, w]
      of 'F': @[s, e]
      of 'S':
        var outs: seq[Coord]
        if matrix[n.y, n.x] == '|' or matrix[n.y, n.x] == 'F' or matrix[n.y, n.x] == '7':
          outs.add(n)
        if matrix[s.y, s.x] == '|' or matrix[s.y, s.x] == 'J' or matrix[s.y, s.x] == 'L':
          outs.add(s)
        if matrix[e.y, e.x] == '-' or matrix[e.y, e.x] == 'J' or matrix[e.y, e.x] == '7':
          outs.add(e)
        if matrix[w.y, w.x] == '-' or matrix[w.y, w.x] == 'L' or matrix[w.y, w.x] == 'F':
          outs.add(w)
        outs
      else: @[]

    for mv in possibleMoves:
      if not distanceMap.hasKeyOrPut(mv, dist + 1):
        queue.addLast((mv, dist + 1))

  for coord, c in matrix:
    let d = distanceMap.getOrDefault((coord[0], coord[1]), -1)
    if d == -1:
      matrix[coord[0], coord[1]] = '.'

  let NS = @[
      @['.', '#', '.'],
      @['.', '#', '.'],
      @['.', '#', '.'],
    ].toTensor

  let EW = @[
      @['.', '.', '.'],
      @['#', '#', '#'],
      @['.', '.', '.'],
    ].toTensor

  let NW = @[
      @['.', '#', '.'],
      @['.', '#', '#'],
      @['.', '.', '.'],
    ].toTensor

  let NE = @[
      @['.', '#', '.'],
      @['#', '#', '.'],
      @['.', '.', '.'],
    ].toTensor

  let SW = @[
      @['.', '.', '.'],
      @['#', '#', '.'],
      @['.', '#', '.'],
    ].toTensor

  let SE = @[
      @['.', '.', '.'],
      @['.', '#', '#'],
      @['.', '#', '.'],
    ].toTensor

  let dot = @[
      @['.', '.', '.'],
      @['.', '.', '.'],
      @['.', '.', '.'],
    ].toTensor

  let S = @[
      @['.', '#', '.'],
      @['.', '#', '#'],
      @['.', '.', '.'],
    ].toTensor

  let expansionMap = {
    '|': NS, #
    '-': EW, #
    'L': NW, #
    'J': NE, #
    '7': SW, #
    'F': SE, #
    'S': S,
    '.': dot, #
  }.toTable

  var expandedMatrix: seq[Tensor[char]]
  for y in 0..<maxY:
    var expandedLine: Tensor[char] = expansionMap[matrix[y, 0]]
    for x in 1..<maxX:
      let output = expansionMap[matrix[y, x]]
      expandedLine = concat(expandedLine, output, axis = 1)
    expandedMatrix.add(expandedLine)

  matrix = expandedMatrix.foldl(concat(a, b, axis = 0))
  let exMaxY = matrix.shape[0]
  let exMaxX = matrix.shape[1]

  # bfs all dots
  let outerDots = block:
    var
      queue = @[(0, 0).Coord].toDeque
      visited = @[(0, 0).Coord].toHashSet

    while queue.len() > 0:
      let v = queue.popFirst

      let possibleMoves = collect:
        for y in v.y-1..v.y+1:
          for x in v.x-1..v.x+1:
            if y > -1 and y < exMaxY and x > -1 and x < exMaxX and matrix[y, x] == '.':
              (y, x).Coord

      for mv in possibleMoves:
        if not visited.containsOrIncl(mv):
          queue.addLast((mv.y, mv.x))
    visited

  let innerDots = collect:
    for coord, c in matrix:
      let loc = (coord[0], coord[1]).Coord
      if not outerDots.contains(loc) and matrix[loc.y, loc.x] == '.':
         { loc }

  for dot in innerDots:
    matrix[dot.y, dot.x] = 'I'

  for dot in outerDots:
    matrix[dot.y, dot.x] = 'O'

  contractMatrix(matrix).countIt(it == 'I')

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

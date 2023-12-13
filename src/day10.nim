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

func convertToUtf8(s: char): string =
  case s:
    of '-': Rune(0x2500).toUTF8
    of '|': Rune(0x2502).toUTF8
    of 'F': Rune(0x250C).toUTF8
    of '7': Rune(0x2510).toUTF8
    of 'L': Rune(0x2514).toUTF8
    of 'J': Rune(0x2518).toUTF8
    else: @[s].toString

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
    var inp = input.example5.splitLines.mapIt(fmt".{it}.")
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

    # for every move
    #  check move in distanceMap, if it's
    for mv in possibleMoves:
      if not distanceMap.hasKeyOrPut(mv, dist + 1):
        queue.addLast((mv, dist + 1))

  proc printMatrix(m: seq[string]) =
    for y in 0..<m.len:
      echo m[y]


  for y in 0..<maxY:
    for x in 0..<maxX:
      let d = distanceMap.getOrDefault((y, x), -1)
      if d == -1:
        matrix[y][x] = '.'

  # bfs all dots
  let outerDotLocations = block:
    var
      queue = @[(0, 0).Coord].toDeque
      visited = @[(0, 0).Coord].toHashSet
      maxY = matrix.len

    while queue.len() > 0:
      let v = queue.popFirst

      let possibleMoves = collect:
        for y in v.y-1..v.y+1:
          for x in v.x-1..v.x+1:
            if y > -1 and y < maxY and x > -1 and x < maxX and matrix[y][x] == '.':
              (y, x).Coord

      for mv in possibleMoves:
        if not visited.containsOrIncl(mv):
          queue.addLast((mv.y, mv.x))
    visited

  for idx in outerDotLocations:
    matrix[idx.y][idx.x] = ' '

  # printMatrix(matrix)

  # const symbols = "|-LJ7FS".toHashSet
  const symbols = "|-LJ7FS".toHashSet

  var dots: int
  for y in 0..<maxY:
    var inside = false
    var prevSymbol: char = '.'
    var crosses: int
    for x in 0..<maxX:
      var thisSymbol = matrix[y][x]

      # if symbols.contains(prevSymbol) and thisSymbol == '.':
      #   inside = not inside
      #   if inside:
      #     matrix[y][x] = 'o'
      #     inc(dots)
      # elif prevSymbol == '.' and symbols.contains(thisSymbol):
      #   inside = not inside

      let isNotCross =
        (prevSymbol == 'L' and thisSymbol == '-') or
        (prevSymbol == 'F' and thisSymbol == '-') or
        (prevSymbol == '-' and thisSymbol == '-')


      if symbols.contains(thisSymbol):
        # let crossPolygon =
        #   (prevSymbol == 'L' and thisSymbol != '-') or
        #   (prevSymbol == 'F' and thisSymbol != '-') or
        #   (prevSymbol == '-' and thisSymbol != 'J') or
        #   (prevSymbol == '-' and thisSymbol != '7')



        if isNotCross:
          discard
        else: # is cross
          inc(crosses)

      elif matrix[y][x] == '.' and crosses.mod(2) != 0:
        matrix[y][x] = 'I'
        inc(dots)
      elif matrix[y][x] == '.' and crosses.mod(2) == 0:
        matrix[y][x] = 'O'

      if y == 5:
        echo fmt"{thisSymbol.convertToUtf8} <- inside:{inside}, insideViaCrosses={crosses.mod(2) == 0}, isCross={not isNotCross}"

      prevSymbol = matrix[y][x]

  # echo dots

  let newMatrix = block:
    var newMatrix: seq[string]
    for y in 0..<maxY:

      var thisLine: string
      for x in 0..<maxX:
        thisLine.add(matrix[y][x].convertToUtf8)

      newMatrix.add(thisLine)
    newMatrix

  printMatrix(newMatrix)

  dots

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

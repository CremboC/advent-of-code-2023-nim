import day16Input as input
import util

import strutils
import strformat
import sequtils
import deques
import options
import sets
import malebolgia

type Dir = enum
  N, E, S, W

type Beam = tuple
  loc: Vec2
  dir: Dir

const matrix = input.input.splitLines.mapIt(it.toSeq)
let
  rangeY = 0..<matrix.len
  rangeX = 0..<matrix[0].len

proc isValidLoc(v: Vec2): bool =
  v.y in rangeY and v.x in rangeX

proc nextLoc(b: Beam): Option[Vec2] =
  let n = case b.dir:
    of Dir.E: b.loc.east
    of Dir.S: b.loc.south
    of Dir.W: b.loc.west
    of Dir.N: b.loc.north

  if n.isValidLoc: some(n)
  else: none(Vec2)

proc solve(start: Beam): int =
  var energized = initOrderedSet[Vec2]()
  var beams = [start].toDeque
  proc addBeam(b: Beam, dir: Dir) =
    let nextNext = case dir:
      of Dir.N: b.loc.north
      of Dir.S: b.loc.south
      of Dir.E: b.loc.east
      of Dir.W: b.loc.west
    if nextNext.isValidLoc:
      beams.addLast((b.loc, dir))

  const maxIterations = 50_000_000
  var iter: int
  while beams.len > 0:
    let beam = beams.popFirst
    let next = beam.nextLoc
    if beam.loc.isValidLoc:
      energized.incl(beam.loc)
    if next.isSome:
      let n = next.get
      let nextBeam = (n, beam.dir).Beam
      case matrix[n.y][n.x]:
        of '|':
          if beam.dir == Dir.E or beam.dir == Dir.W:
            addBeam(nextBeam, Dir.N)
            addBeam(nextBeam, Dir.S)
          else:
            beams.addLast(nextBeam)
        of '\\':
          case beam.dir:
            of Dir.N: addBeam(nextBeam, Dir.W)
            of Dir.S: addBeam(nextBeam, Dir.E)
            of Dir.E: addBeam(nextBeam, Dir.S)
            of Dir.W: addBeam(nextBeam, Dir.N)
        of '/':
          case beam.dir:
            of Dir.N: addBeam(nextBeam, Dir.E)
            of Dir.S: addBeam(nextBeam, Dir.W)
            of Dir.E: addBeam(nextBeam, Dir.N)
            of Dir.W: addBeam(nextBeam, Dir.S)
        of '-':
          if beam.dir == Dir.S or beam.dir == Dir.N:
            addBeam(nextBeam, Dir.E)
            addBeam(nextBeam, Dir.W)
          else:
            beams.addLast(nextBeam)
        else:
          beams.addLast(nextBeam)
    inc(iter)
    if maxIterations == iter:
      break

  energized.len


proc part1(): int =
  solve(((0, -1), Dir.E).Beam)

proc part2(): int =
  let beams = block:
    let topRow = rangeX.mapIt(((0, it), Dir.S).Beam)
    let bottomRow = rangeX.mapIt(((rangeY.b, it), Dir.N).Beam)
    let leftCol = rangeY.mapIt(((it, 0), Dir.E).Beam)
    let rightCol = rangeY.mapIt(((it, rangeX.b), Dir.W).Beam)
    concat(topRow, bottomRow, leftCol, rightCol)

  var solutions = newSeq[int](beams.len)
  var m = createMaster()
  m.awaitAll:
    for i in 0..<beams.len:
      m.spawn solve(beams[i]) -> solutions[i]

  solutions.max

measure(1, part1)
measureMono(2, part2)

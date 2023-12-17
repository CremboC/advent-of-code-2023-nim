import day16Input as input
import util

import strutils
import strformat
import sequtils
# import times
import arraymancer
import deques
import options
import sets
import lists
# import sugar

type Dir = enum
  N, E, S, W

type Beam = tuple
  loc: Vec2
  dir: Dir

proc part1(): int =
  var
    t = input.input.splitLines.mapIt(it.toSeq).toTensor
  let
    rangeY = 0..<t.shape[0]
    rangeX = 0..<t.shape[1]

  func isValidLoc(v: Vec2): bool =
    v.y in rangeY and v.x in rangeX

  func nextLoc(b: Beam): Option[Vec2] =
    let n = case b.dir:
      of Dir.E: b.loc.east
      of Dir.S: b.loc.south
      of Dir.W: b.loc.west
      of Dir.N: b.loc.north

    if n.isValidLoc: some(n)
    else: none(Vec2)

  var energized = initOrderedSet[Vec2]()

  var beams = [((0, -1), Dir.E).Beam].toDeque

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
    # echo beam, " other: ", beams
    # echo next
    if next.isSome:
      let n = next.get
      let nextBeam = (n, beam.dir).Beam
      case t[n.y, n.x]:
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
  # t.pp
  # echo ""

  for loc, c in t:
    if (loc[0], loc[1]) in energized:
      t[loc[0], loc[1]] = '#'
    else:
      t[loc[0], loc[1]] = '.'



  # for idx, loc in energized:
  #   echo idx
  #   if idx == energized.len - 1:
  #     t[loc.y, loc.x] = 'O'

  # t.pp

  energized.len

proc part2(): int =
  1

measure("1", part1)
measure("2", part2)

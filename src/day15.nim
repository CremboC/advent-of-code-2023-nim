import day15Input as input
import util

import strutils
import sequtils
import tables
import sugar

func hash(s: string): int =
  s.foldl(((a + int(b)) * 17).mod(256), 0)

func part1(): int =
  input.input.split(',').foldl(a + b.hash, 0)

func part2(): int =
  const strings = input.input.split(',')
  var hashmap = collect:
    for box in 0..255:
      { box: newOrderedTable[string, int]() }
  for idx, s in strings.pairs:
    let
      split = s.split({ '=', '-' })
      label = split[0]
      arg = split[1]
      focalLength = if arg.len > 0: arg.parseInt else: -1
      boxId = label.hash

    if focalLength != -1: # = op
      hashmap[boxId][label] = focalLength
    else: # - op
      hashmap[boxId].del(label)

  for k, v in hashmap:
    if v.len > 0:
      var idx: int = 1
      for label, f in v:
        result += (k + 1) * idx * f
        inc(idx)

measure(1, part1)
measure(2, part2)

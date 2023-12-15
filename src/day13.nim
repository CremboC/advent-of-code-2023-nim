import day13Input as input
import util

import strutils
import strformat
import sequtils
import arraymancer
import times
import options

# if there's one diff = get that index, otherwise none
func singleDiffIndex[T](a: Tensor[T], b: Tensor[T]): Option[int] =
  if a.shape != b.shape: return none(int)
  for idx, l, r in enumerateZip(a, b):
    if l != r:
      if result.isNone:
        result = some(idx)
      else:
        return none(int)

proc part1(): int =
  let patterns = block:
    let lines = input.input.splitLines
    var patterns: seq[Tensor[char]]
    var currentPattern: seq[seq[char]]
    for l in lines:
      if l.isEmptyOrWhitespace:
        patterns.add(currentPattern.toTensor)
        currentPattern = @[]
      else:
        currentPattern.add(l.toSeq)
    patterns.add(currentPattern.toTensor)
    patterns

  for p in patterns:
    var prev: Tensor[char]
    var mirrorIdy: seq[int]
    for y in 0..<p.shape[0]:
      let l = p[y, _]
      if l == prev:
        mirrorIdy.add(y)
      prev = l

    for y in mirrorIdy:
      var up = p[(y-1)..0|-1, _]
      var down = p[y.._, _]
      if up.shape[0] < down.shape[0]:
        down = down[0..<up.shape[0], _]
      else:
        up = up[0..<down.shape[0], _]

      var validReflection: bool = true
      for (l, r) in zipAxis(up, down, 0):
        if l != r:
          validReflection = false
          break

      if validReflection:
        result += y * 100
        break

    var mirrorIdx: seq[int]
    prev = default(Tensor[char])
    for x in 0..<p.shape[1]:
      let l = p[_, x]
      if l == prev:
        mirrorIdx.add(x)
      prev = l

    for x in mirrorIdx:
      var left = p[_, (x-1)..0|-1]
      var right = p[_, x.._]
      if left.shape[1] < right.shape[1]:
        right = right[_, 0..<left.shape[1]]
      else:
        left = left[_, 0..<right.shape[1]]

      var validReflection: bool = true
      for (l, r) in zipAxis(left, right, 1):
        if l != r:
          validReflection = false
          break

      if validReflection:
        result += x
        break

proc part2(): int =
  let patterns = block:
    let lines = input.input.splitLines
    var patterns: seq[Tensor[char]]
    var currentPattern: seq[seq[char]]
    for l in lines:
      if l.isEmptyOrWhitespace:
        patterns.add(currentPattern.toTensor)
        currentPattern = @[]
      else:
        currentPattern.add(l.toSeq)
    patterns.add(currentPattern.toTensor)
    patterns

  for p in patterns:
    var prev: Tensor[char]
    var mirrorIdy: seq[int]
    for y in 0..<p.shape[0]:
      let l = p[y, _]
      if l == prev or singleDiffIndex(l, prev).isSome:
        mirrorIdy.add(y)
      prev = l

    for y in mirrorIdy:
      var up = p[(y-1)..0|-1, _]
      var down = p[y.._, _]
      if up.shape[0] < down.shape[0]:
        down = down[0..<up.shape[0], _]
      else:
        up = up[0..<down.shape[0], _]

      var fixedSmudge: bool = false
      var validReflection: bool = true
      for (l, r) in zipAxis(up, down, 0):
        let diff = singleDiffIndex(up, down)
        validReflection = validReflection and (l == r or diff.isSome)
        fixedSmudge = diff.isSome

      if validReflection and fixedSmudge:
        result += y * 100

    var mirrorIdx: seq[int]
    prev = default(Tensor[char])
    for x in 0..<p.shape[1]:
      let l = p[_, x]
      if l == prev or singleDiffIndex(l, prev).isSome:
        mirrorIdx.add(x)
      prev = l

    for x in mirrorIdx:
      var left = p[_, (x-1)..0|-1]
      var right = p[_, x.._]
      if left.shape[1] < right.shape[1]:
        right = right[_, 0..<left.shape[1]]
      else:
        left = left[_, 0..<right.shape[1]]

      var fixedSmudge: bool = false
      var validReflection: bool = true
      for (l, r) in zipAxis(left, right, 1):
        let diff = singleDiffIndex(left, right)
        validReflection = validReflection and (l == r or diff.isSome)
        fixedSmudge = diff.isSome

      if validReflection and fixedSmudge:
        result += x

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

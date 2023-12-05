import strutils
import std/[sets, math]
import day04Input as day04

proc part1*(): void =
  var answer = 0
  for line in day04.input.splitLines():
    var
      split = line.split({ ':', '|' })
      winners = split[1].splitWhitespace()
      my = split[2].splitWhitespace()

    var winnerSet = initHashSet[int](16)

    for w in winners:
      winnerSet.incl(w.parseInt())

    var matches = -1
    for m in my:
      if winnerSet.contains(m.parseInt()):
        matches += 1

    if matches >= 0:
      answer += 2^matches

  echo answer

import day07Input as day07
import times

import strutils
import strformat
import sequtils
import sets
import tables
import sugar
import std/enumerate
import algorithm

import pkg/strides

type Card = tuple
  card: char
  cnt: int

type Hand = tuple
  hand: string
  table: CountTable[char]
  sortedCardsByCount: seq[Card]
  bid: int

# for sorting entries of CountTable
func `<`[T](a: (T, int), b: (T, int)): bool =
  a[1] < b[1]

func newHand(it: string): Hand =
  let hand = it[0..4]
  let table = hand.toCountTable
  (hand, table, table.pairs.toSeq.sorted, parseInt(it[6..^1]))

func compareSameKind(index: Table[char, int], left: string, right: string): int =
  for (l, r) in zip(left, right):
    if l != r:
      return cmp(index[l], index[r])

func compareHands(index: Table[char, int], left: Hand, right: Hand): int =
    compareSameKind(index, left.hand, right.hand)

func part1(): int =
  let index = {'2': 1, '3': 2, '4': 3, '5': 4, '6': 5, '7': 6, '8': 7, '9': 8, 'T': 9, 'J': 10, 'Q': 11, 'K': 12, 'A': 13 }.toTable
  let checks = [
    # five of a kind
    (hand: Hand) => hand.sortedCardsByCount[^1].cnt == 5,
    # four of a kind
    (hand: Hand) => hand.sortedCardsByCount[^1].cnt == 4,
    # full house
    (hand: Hand) => hand.sortedCardsByCount[^1].cnt == 3 and hand.sortedCardsByCount[^2].cnt == 2,
    # three of a kind
    (hand: Hand) => hand.sortedCardsByCount[^1].cnt == 3,
    # two pair
    (hand: Hand) => hand.sortedCardsByCount[^2..^1].allIt(it.cnt == 2),
    # one pair
    (hand: Hand) => hand.sortedCardsByCount[^1].cnt == 2,
  ]
  let rankCount = checks.len

  let hands: seq[Hand] = day07.input.splitLines().mapIt(newHand(it))
  var handGroups: Table[int, seq[Hand]]
  for hand in hands:
    var rank: int = 0
    for (idx, chk) in enumerate(checks):
      if chk(hand):
        rank = rankCount - idx
        break

    if handGroups.hasKey(rank):
      handGroups[rank].add(hand)
    else:
      handGroups[rank] = @[hand]

  var ordered: seq[Hand]
  for rank in 0..rankCount:
    for h in sorted(handGroups[rank], (x, y) => compareHands(index, x, y)):
      ordered.add(h)

  for (idx, h) in enumerate(ordered):
    result += h.bid * (idx + 1)

  result

func part2(): int =
  let index = {'J': 0, '2': 1, '3': 2, '4': 3, '5': 4, '6': 5, '7': 6, '8': 7, '9': 8, 'T': 9, 'Q': 10, 'K': 11, 'A': 12 }.toTable
  let checks = [
    # five of a kind
    (hand: Hand) => (block:
      let max = hand.sortedCardsByCount[^1]
      if max.cnt == 5: true
      elif max.card == 'J': (hand.sortedCardsByCount[^2].cnt + max.cnt) == 5
      else: (hand.table.getOrDefault('J', 0) + max.cnt) == 5
    ),
    # four of a kind
    (hand: Hand) => (block:
      let max = hand.sortedCardsByCount[^1]
      if max.cnt == 4: true
      elif max.card == 'J': (hand.sortedCardsByCount[^2].cnt + max.cnt) == 4
      else: (hand.table.getOrDefault('J', 0) + max.cnt) == 4
    ),
    # full house
    (hand: Hand) => (block:
      let
        jokerCount = hand.table.getOrDefault('J', 0)
        sorted = hand.sortedCardsByCount

      if jokerCount == 1: sorted[^1].cnt == 2 and sorted[^2].cnt == 2
      else: sorted[^1].cnt == 3 and sorted[^2].cnt == 2
    ),
    # three of a kind
    (hand: Hand) => (block:
      let
        sorted = hand.sortedCardsByCount
        jokerCount = hand.table.getOrDefault('J', 0)

      if sorted[^1].cnt == 3:
        return true
      elif sorted[^1].card == 'J':
        return (jokerCount + sorted[^2].cnt) == 3
      else:
        return (jokerCount + sorted[^1].cnt) == 3
    ),
    # two pair
    (hand: Hand) => (block:
      let sorted = hand.sortedCardsByCount
      sorted[^1].cnt == 2 and sorted[^2].cnt == 2
    ),
    # one pair
    (hand: Hand) => (block:
      let jokerCount = hand.table.getOrDefault('J', 0)
      if jokerCount == 1: return true
      hand.sortedCardsByCount[^1].cnt == 2
    ),
  ]

  let rankCount = checks.len
  let hands: seq[Hand] = day07.input.splitLines().mapIt(newHand(it))
  var handGroups: Table[int, seq[Hand]]

  for hand in hands:
    var rank: int = 0
    for (idx, chk) in enumerate(checks):
      if chk(hand):
        rank = rankCount - idx
        break

    if handGroups.hasKey(rank):
      handGroups[rank].add(hand)
    else:
      handGroups[rank] = @[hand]

  var ordered: seq[Hand]
  for rank in handGroups.keys.toSeq.sorted:
    for h in sorted(handGroups[rank], (x, y) => compareHands(index, x, y)):
      ordered.add(h)

  for (idx, h) in enumerate(ordered):
    result += h.bid * (idx + 1)

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

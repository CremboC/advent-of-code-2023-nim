
func `[]`*[T, U](slice: HSlice[T, U], needle: int): int =
  slice.a + needle

func intersect*[T, U](this: HSlice[T, U], other: HSlice[T, U]): seq[HSlice[T, U]] =
  if this.a > other.b or this.b < other.a: return
  else:
    let inter = max(this.a, other.a)..min(this.b, other.b)
    result.add(inter)
    if inter.a > this.a:
      result.add(this.a..inter.a - 1)
    if inter.b < this.b:
      result.add(inter.b + 1..this.b)
    return result

func toString*(bytes: seq[char]): string =
  result = newString(bytes.len)
  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

iterator slidingWindow*[T](s: seq[T], windowSize: int): seq[T] =
  for i in 0..<(s.len - windowSize + 1):
    yield s[i..<(i + windowSize)]

type Vec2* = tuple
  y: int
  x: int

iterator neighbors*(loc: Vec2): Vec2 =
  yield (loc.y - 1, loc.x)
  yield (loc.y, loc.x - 1)
  yield (loc.y, loc.x + 1)
  yield (loc.y + 1, loc.x)

func addX*(v: Vec2, x: int): Vec2 =
  (v.y, v.x + x)

func addY*(v: Vec2, y: int): Vec2 =
  (v.y + y, v.x)

func north*(v: Vec2): Vec2 =
  v.addY(-1)

func south*(v: Vec2): Vec2 =
  v.addY(1)

func east*(v: Vec2): Vec2 =
  v.addX(1)

func west*(v: Vec2): Vec2 =
  v.addX(-1)

import arraymancer

proc pp*(t: Tensor[char]) =
  for y in 0..<t.shape[0]:
    for x in 0..<t.shape[1]:
      stdout.write(t[y, x])
    echo ""

iterator slidingWindow*[T](s: Tensor[T], windowSize: int): Tensor[T] =
  for i in 0..<(s.len - windowSize + 1):
    yield s[i..<(i + windowSize)]

import times
import sugar
import strformat

proc measure*(s: string, f: () -> int) =
  let start = cpuTime()
  let result = f()
  let finish = cpuTime()
  echo fmt"Part {s} [t={((finish - start) * 1000):.2f}ms]: {result}"

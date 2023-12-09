
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

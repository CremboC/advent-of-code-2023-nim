
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

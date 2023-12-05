import strformat
import times

import day04 as day04
import day05 as day05

echo "Day 04, Part 1"
day04.part1()

let start = cpuTime()
echo "Day 05, Part 1" & fmt". Answer = {day05.part1()}"
let finish = cpuTime()
echo fmt"in {finish - start} seconds"

echo "Day 05, Part 2" & fmt". Answer = {day05.part2()}"


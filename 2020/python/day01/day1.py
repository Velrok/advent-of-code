import sys
from utils import read_numbers_from

test_input = """1721
979
366
299
675
1456"""


def part1(numbers):
    return next((n * nn for n in numbers for nn in numbers if n + nn == 2020))


def part2(numbers):
    return next((n * nn * nnn for n in numbers for nn in numbers for nnn in numbers if n + nn +nnn == 2020))


if __name__ == '__main__':
    try:
        numbers = list(read_numbers_from("day1.input"))
        print("part1 -> %s" % part1(numbers))
        print("part2 -> %s" % part2(numbers))
        sys.exit(0)
    except Exception as e:
        print('Error [%s]: %s' % (type(e),  e), file=sys.stderr)
        sys.exit(1)

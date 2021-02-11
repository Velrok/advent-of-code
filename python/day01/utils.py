def read_numbers_from(filename):
    return [int(l) for l in open(filename, 'r').readlines()]

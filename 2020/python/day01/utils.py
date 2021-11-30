def read_from(filename, line_fn=str):
    return [line_fn(l) for l in open(filename, 'r').readlines()]


def read_numbers_from(filename):
    return read_from(filename, int)

def has_adjacent_digits(test_object: list[int]) -> bool:
    for i in range(1,len(test_object)):
        if test_object[i] == test_object[i-1]:
            return True
    return False

def no_decreases(test_object: list[int]) -> bool:
    for i in range(1,len(test_object)):
        if test_object[i] < test_object[i-1]:
            return False
    return True

def test(i:int) -> bool:
    test_object = [int(char) for char in list(str(i))]
    return has_adjacent_digits(test_object) and no_decreases(test_object)

def part01() -> int:
    input = range(284639, 748759 + 1)
    filtered = list(filter(test, input))
    return len(filtered)

def has_adjacent_digits2(test_object: list[int]) -> bool:
    for i in range(1,len(test_object)):
        at_i = test_object[i]
        before = test_object[i-1]

        before_before = None if i == 1 else test_object[i-2]
        after = None if i+1 >= len(test_object) else test_object[i+1]

        if at_i == before and at_i != before_before and at_i != after:
            return True
    return False

def test2(i:int) -> bool:
    test_object = [int(char) for char in str(i)]
    return has_adjacent_digits2(test_object) and no_decreases(test_object)

def part02() -> int:
    input = range(284639, 748759 + 1)
    filtered = list(filter(test2, input))
    return len(filtered)


# print(part01())
print(part02())

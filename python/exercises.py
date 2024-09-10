from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


def first_then_lower_case(strings: list[str], condition: Callable[[str], bool]):
    for s in strings:
        if condition(s):
            return s.lower()
    return None

def powers_generator(*, base: int, limit: int):
    power = 1
    while power <= limit:
        yield power
        power *= base

# Write your say function here


# Write your line count function here


# Write your Quaternion class here

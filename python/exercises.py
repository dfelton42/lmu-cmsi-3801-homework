from dataclasses import dataclass
from collections.abc import Callable
from typing import *


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

def say(word=None):
    if word is None:
        return ""
    memory = [word]

    def inner(next_word=None):
        if next_word is not None:
            memory.append(next_word)
            return inner
        return ' '.join(memory)
    return inner


def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            count = 0
            for line in file:
                stripped_line = line.strip()
                if stripped_line and not stripped_line.startswith('#'):
                    count += 1
        return count
    except FileNotFoundError:
        raise FileNotFoundError("No such file or directory: '{filename}'")

@dataclass(frozen=True)
class Quaternion:
    w: float
    x: float
    y: float
    z: float

    def __add__(self, other: 'Quaternion') -> 'Quaternion':
        if not isinstance(other, Quaternion):
            return NotImplemented
        return Quaternion(
            self.w + other.w,
            self.x + other.x,
            self.y + other.y,
            self.z + other.z
        )

    def __mul__(self, other: 'Quaternion') -> 'Quaternion':
        if not isinstance(other, Quaternion):
            return NotImplemented
        return Quaternion(
            self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z,
            self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y,
            self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x,
            self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w
        )

    def __eq__(self, other: 'Quaternion') -> bool:
        if not isinstance(other, Quaternion):
            return NotImplemented
        return (self.w, self.x, self.y, self.z) == (other.w, other.x, other.y, other.z)

    @property
    def coefficients(self) -> Tuple[float, float, float, float]:
        return (self.w, self.x, self.y, self.z)

    @property
    def conjugate(self) -> 'Quaternion':
        return Quaternion(self.w, -self.x, -self.y, -self.z)
    
    def __str__(self) -> str:
        parts = []

        # Handle real part
        if self.w != 0 or (self.x == 0 and self.y == 0 and self.z == 0):
            real_part = f"{self.w:.2f}".rstrip('0').rstrip('.')
            parts.append(real_part)

        # Handle imaginary parts with proper sign management
        if self.x != 0:
            imag_part = f"{abs(self.x):.2f}".rstrip('0').rstrip('.')
            if self.x > 0 and parts:
                parts.append(f"+{imag_part}i")
            elif self.x < 0:
                parts.append(f"-{imag_part}i")
            else:
                parts.append(f"{imag_part}i")

        if self.y != 0:
            imag_part = f"{abs(self.y):.2f}".rstrip('0').rstrip('.')
            if self.y > 0 and parts:
                parts.append(f"+{imag_part}j")
            elif self.y < 0:
                parts.append(f"-{imag_part}j")
            else:
                parts.append(f"{imag_part}j")

        if self.z != 0:
            imag_part = f"{abs(self.z):.2f}".rstrip('0').rstrip('.')
            if self.z > 0 and parts:
                parts.append(f"+{imag_part}k")
            elif self.z < 0:
                parts.append(f"-{imag_part}k")
            else:
                parts.append(f"{imag_part}k")

        # Handle case when all parts are zero
        if not parts:
            return "0"

        # Join parts into final result
        result = ''.join(parts)

        return result

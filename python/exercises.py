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
    # Iterate over strings, then check condition
    for s in strings:
        if condition(s):
            return s.lower()
    return None

def powers_generator(*, base: int, limit: int):
    # Generate powers under limit
    power = 1
    while power <= limit:
        yield power
        power *= base

def say(word=None):
    if word is None:
        return ""
    memory = [word] # Initialize with first word

    def inner(next_word=None):
        if next_word is not None:
            memory.append(next_word) # Append next word to memory
            return inner
        return ' '.join(memory) # Join words 
    return inner


def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            count = 0
            # Iterate over lines in file
            for line in file:
                stripped_line = line.strip() # Remove blank spaces
                if stripped_line and not stripped_line.startswith('#'):
                    count += 1  # Increase number for meaningful lines
        return count
    except FileNotFoundError:
        # Raise error if no file found
        raise FileNotFoundError("No such file or directory: '{filename}'")


@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __add__(self, other: 'Quaternion') -> 'Quaternion':
        if not isinstance(other, Quaternion):
            return NotImplemented
        # Returns Quaternion with final sum
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d
        )

    def __mul__(self, other: 'Quaternion') -> 'Quaternion':
        if not isinstance(other, Quaternion):
            return NotImplemented
        # Quaternion multiplication
        return Quaternion(
            self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,
            self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,
            self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,
            self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        )
    
    @property
    def coefficients(self) -> Tuple[float, float, float, float]:
        return (self.a, self.b, self.c, self.d)

    @property
    def conjugate(self) -> 'Quaternion':
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Quaternion):
            return NotImplemented
        # Compare Quaternions
        return (self.a, self.b, self.c, self.d) == (other.a, other.b, other.c, other.d)

    def __str__(self) -> str:
        parts = []
        
        # Append the real part if it's non-zero or if all imaginary parts are zero
        if self.a != 0 or (self.b == 0 and self.c == 0 and self.d == 0):
            # Handle the sign for the real part
            if self.a == 0:
                pass
            else:
                parts.append(f"{self.a}")

        # Append the imaginary parts with correct signs and handling coefficients
        if self.b != 0:
            if self.b == 1:
                parts.append(f"{'+' if parts else ''}i")
            elif self.b == -1:
                parts.append(f"{'-'}i")
            else:
                parts.append(f"{'+' if self.b > 0 and parts else ''}{self.b}i")

        if self.c != 0:
            if self.c == 1:
                parts.append(f"{'+' if parts else ''}j")
            elif self.c == -1:
                parts.append(f"{'-'}j")
            else:
                parts.append(f"{'+' if self.c > 0 and parts else ''}{self.c}j")

        if self.d != 0:
            if self.d == 1:
                parts.append(f"{'+' if parts else ''}k")
            elif self.d == -1:
                parts.append(f"{'-'}k")
            else:
                parts.append(f"{'+' if self.d > 0 and parts else ''}{self.d}k")
        
        # Handle the case where all parts are zero
        if not parts:
            return "0"
        
        # Join parts and handle sign replacements
        result = ''.join(parts).replace('+-', '-')
        
        # Remove leading '+' if necessary
        if result.startswith('+'):
            result = result[1:]
        
        return result
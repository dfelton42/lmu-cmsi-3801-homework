from exercises import (
    first_then_lower_case,
    say,
    powers_generator,
    meaningful_line_count,
    Quaternion,
    change)

################################################################################
counts = {True: 0, False: 0}
def suite(name):
    print(f"\nTesting {name}", end="")
def expect(condition):
    counts[condition] += 1
    print(" ." if condition else " F", end="")
def expect_error(error_type, text, fun, *args):
    try:
        fun(*args)
        expect(False)
    except Exception as e:
        expect(isinstance(e, error_type))
        if text is not None:
            expect(text in str(e))
################################################################################

suite("change")
expect_error(TypeError, "Amount must be an integer", change, 33.375)
expect_error(ValueError, "Amount cannot be negative", change, -50)
expect(change(0) == {25: 0, 10: 0, 5: 0, 1: 0})
expect(change(1) == {25: 0, 10: 0, 5: 0, 1: 1})
expect(change(8) == {25: 0, 10: 0, 5: 1, 1: 3})
expect(change(42) == {25: 1, 10: 1, 5: 1, 1: 2})
expect(change(99) == {25: 3, 10: 2, 5: 0, 1: 4})
expect(change(144) == {25: 5, 10: 1, 5: 1, 1: 4})
expect(change(250) == {25: 10, 10: 0, 5: 0, 1: 0})
expect(change(100000000037) == {25: 4000000001, 10: 1, 5: 0, 1: 2})
expect(change(10000000000005) == {25: 400000000000, 10: 0, 5: 1, 1: 0})

# Uncomment the following tests as you complete the exercises

suite("first_then_lower_case")
def nonempty(s): return s != ""
def length_greater_than_3(s): return len(s) > 3
expect(first_then_lower_case([], nonempty) is None)
expect(first_then_lower_case(["", "A", "B"], nonempty) == "a")
expect(first_then_lower_case(["", "A", "ABC"], length_greater_than_3) is None)
expect(first_then_lower_case(["ABC", "ABCD", "ABCDE"], length_greater_than_3) == "abcd")

suite("say")
expect(say() == "")
expect(say("hi")() == "hi")
expect(say("hi")("there")() == "hi there")
expect(say("hello")("my")("name")("is")("Colette")() == "hello my name is Colette")
expect(say("h i")() == "h i")
expect(say("hi ")("   there")() == "hi     there")
expect(say("")("")("dog")("")("go")() == "  dog  go")
expect(say("😄🤗")("💀👊🏾")() == "😄🤗 💀👊🏾")

suite("powers_generator")
g1 = powers_generator(base=2, limit=1)
expect(next(g1) == 1)
expect_error(StopIteration, None, next, g1)
g2 = powers_generator(base=3, limit=100)
expect(next(g2) == 1)
expect(next(g2) == 3)
expect(next(g2) == 9)
expect(next(g2) == 27)
expect(next(g2) == 81)
expect_error(StopIteration, None, next, g2)
expect(list(powers_generator(base=3, limit=27)) == [1, 3, 9, 27])

suite("meaningful_line_count")
expect_error(FileNotFoundError, 'No such file', meaningful_line_count, "no-such-file.txt")
expect(meaningful_line_count("../test-for-line-count.txt") == 5)

suite("Quaternion")
q = Quaternion(3.5, 2.25, -100.0, -1.25)
expect(q.a == 3.5)
expect(q.b == 2.25)
expect(q.c == -100.0)
expect(q.d == -1.25)

q1 = Quaternion(1.0, 3.0, 5.0, 2.0)
q2 = Quaternion(-2.0, 2.0, 8.0, -1.0)
q3 = Quaternion(-1.0, 5.0, 13.0, 1.0)
q4 = Quaternion(-46.0, -25.0, 5.0, 9.0)

zero = Quaternion(0, 0, 0, 0)
i = Quaternion(0, 1, 0, 0)
j = Quaternion(0, 0, 1, 0)
k = Quaternion(0, 0, 0, 1)

expect(zero.coefficients == (0.0, 0.0, 0.0, 0.0))
expect(k.coefficients == (0.0, 0.0, 0.0, 1.0))
expect(q2.coefficients == (-2.0, 2.0, 8.0, -1.0))
expect(q4.conjugate == Quaternion(-46.0, 25.0, -5.0, -9.0))

expect(q1 + q2 == q3)
expect(q1 * q2 == q4)
expect(q1 + zero == q1)
expect(q1 * zero == zero)
expect(i * j == k)
expect(j * k == i)
expect(j + i == Quaternion(0.0, 1.0, 1.0, 0.0))

expect(f"{zero}" == "0")
expect(f"{j}" == "j")
expect(f"{k.conjugate}" == "-k")
expect(f"{j.conjugate * Quaternion(2.0, 0.0, 0.0, 0.0)}" == "-2.0j")
expect(f"{j + k}" == "j+k")
expect(f"{Quaternion(0.0, -1.0, 0.0, 2.25)}" == "-i+2.25k")
expect(f"{Quaternion(-20.0, -1.75, 13.0, -2.25)}" == "-20.0-1.75i+13.0j-2.25k")
expect(f"{Quaternion(-1.0, -2.0, 0.0, 0.0)}" == "-1.0-2.0i")
expect(f"{Quaternion(1.0, 0.0, -2.0, 5.0)}" == "1.0-2.0j+5.0k")

print(f"\n{counts[True]} passed, {counts[False]} failed")

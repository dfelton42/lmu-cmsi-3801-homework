import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// Write your first then lower case function here
fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String? {
    for (string in strings) {
        if (predicate(string)) {
            return string.lowercase()
             }
    }
    return null
}


// Write your say function here
class Say(private val words: List<String> = listOf()) {
    fun and(word: String): Say {
        return Say(words + word)
    }
    val phrase: String
        get() = words.joinToString(" ")
}
fun say(word: String = ""): Say {
    return Say(listOf(word))
}


// Write your meaningfulLineCount function here
fun meaningfulLineCount(filename: String): Long {
    BufferedReader(FileReader(filename)).use { reader ->
        return reader.lines()
            .filter { line -> 
                line.isNotBlank() && !line.trimStart().startsWith("#")
            }
            .count() 
    }
}

// Write your Quaternion data class here
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
    fun coefficients(): List<Double> = listOf(a, b, c, d)
    fun conjugate(): Quaternion {
        return Quaternion(a, -b, -c, -d)
    }
    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(
        a + other.a,
            b + other.b,
            c + other.c,
            d + other.d
        )
    }
    operator fun times(other: Quaternion): Quaternion {
        val valA = a * other.a - b * other.b - c * other.c - d * other.d
        val valB = a * other.b + b * other.a + c * other.d - d * other.c
        val valC = a * other.c - b * other.d + c * other.a + d * other.b
        val valD = a * other.d + b * other.c - c * other.b + d * other.a
        return Quaternion(valA, valB, valC, valD)
    }

    override fun toString(): String {
        val result = StringBuilder()

        if (a != 0.0) result.append(a)

        if (b != 0.0) {
            if (b > 0 && result.isNotEmpty()) result.append("+")
            result.append(formatting(b, "i"))
        }

        if (c != 0.0) {
            if (c > 0 && result.isNotEmpty()) result.append("+")
            result.append(formatting(c, "j"))
        }

        if (d != 0.0) {
            if (d > 0 && result.isNotEmpty()) result.append("+")
            result.append(formatting(d, "k"))
        }

        return if (result.isEmpty()) "0" else result.toString()
    }
    private fun formatting(value: Double, symbol: String): String {
        return when (value) {
            1.0 -> symbol
            -1.0 -> "-$symbol"
            else -> "$value$symbol"
        }
    }
}
// Write your Binary Search Tree interface and implementing classes here
sealed interface BinarySearchTree {
    fun insert(value: String): BinarySearchTree
    fun contains(value: String): Boolean
    fun size(): Int
    override fun toString(): String
    object Empty : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree {
            return Node(value, Empty, Empty)
        }
        override fun contains(value: String): Boolean = false
        override fun size(): Int = 0
        override fun toString(): String = "()"
    }

    data class Node(
        val nodeValue: String,
        val leftChild: BinarySearchTree = Empty,
        val rightChild: BinarySearchTree = Empty
    ) : BinarySearchTree {
        override fun insert(newValue: String): BinarySearchTree {
            return if (newValue < nodeValue) {
                Node(nodeValue, leftChild.insert(newValue), rightChild)
            } else {
                Node(nodeValue, leftChild, rightChild.insert(newValue))
            }
        }
        override fun contains(searchValue: String): Boolean {
            return when {
                searchValue == nodeValue -> true
                searchValue < nodeValue -> leftChild.contains(searchValue)
                else -> rightChild.contains(searchValue)
            }
        }
        override fun size(): Int = 1 + leftChild.size() + rightChild.size()

        override fun toString(): String {
            val leftString = if (leftChild is Empty) "" else "$leftChild"
            val rightString = if (rightChild is Empty) "" else "$rightChild"
            return "($leftString$nodeValue$rightString)"
        }
    }
}


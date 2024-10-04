import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

// Write your first then lower case function here
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}
// Write your say function here
struct Say {
    private var words: [String]
    
    init(_ word: String = "") {
        self.words = word.isEmpty ? [] : [word]
    }
    
    var phrase: String {
        return words.joined(separator: " ")
    }
    
    func and(_ word: String) -> Say {
        var newWords = words
        newWords.append(word)
        return Say(words: newWords)
    }
    
    private init(words: [String]) {
        self.words = words
    }
}

func say(_ word: String = "") -> Say {
    return Say(word)
}
// Write your meaningfulLineCount function here
func meaningfulLineCount(_ filename: String) async -> Result<Int, Error> {
    do {
        guard let fileHandle = FileHandle(forReadingAtPath: filename) else {
            return .failure(NoSuchFileError())
        }
        defer { fileHandle.closeFile() }
        
        var count = 0
        for try await line in fileHandle.bytes.lines {
            if !line.isEmpty {
                count += 1
            }
        }
        return .success(count)
    } catch {
        return .failure(error)
    }
}
// Write your Quaternion struct here

// Write your Binary Search Tree enum here
enum BinarySearchTree: CustomStringConvertible, Equatable {
    case empty
    indirect case node(BinarySearchTree, String, BinarySearchTree)
    
    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return 1 + left.size + right.size
        }
    }
    
    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, element, right):
            if value == element {
                return true
            } else if value < element {
                return left.contains(value)
            } else {
                return right.contains(value)
            }
        }
    }
    
    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, value, .empty)
        case let .node(left, v, right):
            if value < v {
                return .node(left.insert(value), v, right)
            } else if value > v {
                return .node(left, v, right.insert(value))
            } else {
                return self
            }
        }
    }
    
    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(left, value, right):
            return "(\(left)\(value)\(right))"
        }
    }
    
    static func == (lhs: BinarySearchTree, rhs: BinarySearchTree) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.node(left1, value1, right1), .node(left2, value2, right2)):
            return value1 == value2 && left1 == left2 && right1 == right2
        default:
            return false
        }
    }
}

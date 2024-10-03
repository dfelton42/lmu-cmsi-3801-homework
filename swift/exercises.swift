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

// Write your Quaternion struct here

// Write your Binary Search Tree enum here

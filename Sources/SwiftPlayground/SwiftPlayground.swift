// Map, Filter, Reduce

@main
struct SwiftPlayground {
    static func main() {
        // Basic constants
        let passingScore = 50
        let scoreCurve = 5

        // Inputs for the different tasks
        let numbers: [Int] = [1, 2, 3, 4, 5]
        let otherNumbers: [Int] = [7, 14, 21, 28, 35]
        let words: [String] = ["apple", "banana", "grape", "strawberry", "kiwi"]
        let scores: [Int] = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]

        // Numbers

        // Cube the numbers in the list
        let cubedNumbers: [Int] = numbers.map { $0 * $0 * $0 }

        // Filter for even numbers
        let evenNumbers: [Int] = cubedNumbers.filter { $0 % 2 == 0 }

        // Add up the numbers to get the sum
        let numbersSum: Int = evenNumbers.reduce(0) { $0 + $1 }

        // Calculate the product of otherNumbers.
        let product: Int = otherNumbers.reduce(1) { $0 * $1 }

        // Strings

        // Reduce the list to the shortest word.
        let longestWord: String = words.reduce("") { $1.count > $0.count ? $1 : $0 }

        // Scores

        // Curve the scores by adding 5
        let curvedScores = scores.map { $0 + scoreCurve }

        // Filter for passing scores
        let passingScores = curvedScores.filter { $0 >= passingScore }

        // Get the sum of passing scores and divide them by the amount to get the average
        let averageScore = passingScores.reduce(0, +) / passingScores.count

        // Output values for each step of each thing
        // In class numbers thing
        print("Numbers: \(numbers)")
        print("Cubed numbers: \(cubedNumbers)")
        print("Even cubed numbers: \(evenNumbers)")
        print("Sum of the above: \(numbersSum)")

        // Formatting newline
        print()

        // Numbers task on the website
        print("Other numbers: \(otherNumbers)")
        print("Product of other numbers: \(product)")

        print()

        // Longest word
        print("Words: \(words)")
        print("Longest word: \(longestWord)")

        print()

        // Scores task
        print("Scores: \(scores)")
        print("Curved scores:\(curvedScores)")
        print("Passing scores:\(passingScores)")
        print("Average passing score:\(averageScore)")
    }
}

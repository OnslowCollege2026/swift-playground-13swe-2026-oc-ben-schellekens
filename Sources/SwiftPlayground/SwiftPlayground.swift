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

        // Cube the numbers in the list
        let cubedNumbers: [Int] = numbers.map { $0 * $0 * $0 }

        // Filter for even numbers
        let evenNumbers: [Int] = cubedNumbers.filter { $0 % 2 == 0 }

        // Add up the numbers to get the sum
        let numbersSum: Int = evenNumbers.reduce(0) { $0 + $1 }

        // Calculate the product of otherNumbers.
        let product: Int = otherNumbers.reduce(1) { $0 * $1 }

        // Set words list

        // Reduce the list to the shortest word.
        let longestWord: String = words.reduce("") { $1.count > $0.count ? $1 : $0 }

        // Print the longest word
        print(longestWord)

        // Curve the scores by adding 5
        let curvedScores = scores.map { $0 + scoreCurve }

        // Filter for passing scores
        let passingScores = curvedScores.filter { $0 >= passingScore }

        // Get the sum of passing scores and divide them by the amount to get the average
        let averageScore = passingScores.reduce(0, +) / passingScores.count

        print(curvedScores)
        print(passingScores)
        print(averageScore)
    }
}
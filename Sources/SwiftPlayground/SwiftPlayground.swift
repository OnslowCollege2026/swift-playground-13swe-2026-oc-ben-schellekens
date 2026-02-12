// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        // Task inputs
        let mixed: Array<String> = ["cat", "7", "owl", "15", "dog", "3"]
        let archive: Array<Array<Array<Array<String>>>> /* now thats what i call typing */ = [
            [
                [["candle", "dust"], ["mirror", "ash"]],
                [["whisper", "shadow"], ["clock", "veil"]],
            ],
            [
                [["stone", "key"], ["relic", "name"]],
                [["cipher", "bone"], ["ember", "seal"]],
            ],
        ]
        let sightings: Array<(name: String, score: Int)> = [
            (name: "moth", score: 3),
            (name: "wolf", score: 9),
            (name: "raven", score: 4),
            (name: "mist", score: 7),
            (name: "wisp", score: 2),
        ]
        let testString: String = "moonlight"

        // Remove non-numbers from mixed
        let numbers: [Int] = mixed.compactMap {Int($0)}

        // Get the first item of the last item of the last item of the archive
        let firstItemOfTheLastItemOfTheLastItemOfTheLastItemOfTheArchive: String? = archive.last?.last?.last?.first

        // Filter sightings for to give back the scores of entries where the name starts with m or w
        let filteredSightings: Array<(name: String, score: Int)> = sightings.filter({
            // This cant be the best way to do it we ball
            let nameLetter: String = String($0.name.split(separator: "")[0])
            return nameLetter == "m" || nameLetter == "w"
        })

        // Make an array of only the scores from the sightings
        let sightingScores: [Int] = filteredSightings.map {$0.score}

        // Get the total score of all of the filtered sightings
        let totalSightingScore: Int = sightingScores.reduce(0, +)

        // Get the highest and lowest scores from the sighting scores 
        let highestScore: Int? = sightingScores.max {$0 < $1}
        let lowestScore: Int? = sightingScores.min {$0 < $1}

        // Check if the test string is valid (more than 8 characters)
        let testStringAccepted: Bool = accepts(testString, isValid: { $0.count > 8})

        // Print out answers
        print("Numbers in mixed \(numbers)")

        print("The first item of the last item of the last item of the last item of the archive is \(firstItemOfTheLastItemOfTheLastItemOfTheLastItemOfTheArchive ?? "Genuninley how did this fail what")")
        
        // Im not writing out messages for all of these
        print(filteredSightings)
        print(sightingScores)
        print(totalSightingScore)
        print(highestScore ?? 0)
        print(lowestScore ?? 0)
        
        print(testStringAccepted ? "The string is valid" : "Nope change it")
    }
}

func accepts(_ input: String, isValid: (String) -> Bool) -> Bool {
    return isValid(input)
}


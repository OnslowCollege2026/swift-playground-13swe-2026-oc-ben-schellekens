// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        // Task inputs
        let mixed: [String] = ["cat", "7", "owl", "15", "dog", "3"]
        let archive: [[[[String]]]] = [
            [
                [["candle", "dust"], ["mirror", "ash"]],
                [["whisper", "shadow"], ["clock", "veil"]],
            ],
            [
                [["stone", "key"], ["relic", "name"]],
                [["cipher", "bone"], ["ember", "seal"]],
            ],
            [
                [["feather", "ink"], ["glow", "eclipse"]],
                [["riddle", "echo"], ["ember", "glyph"]],
            ],
        ]
        let sightings: [(name: String, score: Int)] = [
            (name: "moth", score: 3),
            (name: "wolf", score: 9),
            (name: "raven", score: 4),
            (name: "mist", score: 7),
            (name: "wisp", score: 2),
        ]
        let testString: String = "moonlight"
        // --- TASK A ---
        // Remove non-numbers from mixed
        let numbers: [Int] = mixed.compactMap { Int($0) }

        // Filter sightings for to give back the scores of entries where the name starts with m or w
        let filteredSightings: [(name: String, score: Int)] = sightings.filter({
            // This cant be the best way to do it we ball
            $0.name.hasPrefix("m") || $0.name.hasPrefix("w")
        })

        // Make an array of only the scores from the sightings
        let sightingScores: [Int] = filteredSightings.map { $0.score }

        // Get the total score of all of the filtered sightings
        let totalSightingScore: Int = sightingScores.reduce(0, +)

        // Get the highest and lowest scores from the sighting scores
        let highestScore: Int = sightingScores.max { $0 < $1 } ?? 0
        let lowestScore: Int = sightingScores.min { $0 < $1 } ?? 0

        // --- TASK C ---

        // Check if the test string is valid (more than 8 characters)
        let sampleIsLowercase: Bool = accepts(testString, isValid: { $0.allSatisfy( {$0.isLowercase} ) })
        let sampleLessThan8Chars: Bool = accepts(testString, isValid: { $0.count > 8 })

        // TODO: archive task
        let wing = archive.last { wing in 
            wing.contains { room in 
                room.contains { shelf in
                    shelf.contains { $0.hasPrefix("e") }
                }
            }
        }!

        let room = wing.last { room in
            room.contains { shelf in
                shelf.contains { $0.count == 4 }
            }
        }!

        let shelf = room.last { shelf in
            shelf.contains { $0.contains("e") }
        }!

        let word = shelf.first { $0.hasPrefix("e") }!
        // Print out answers
        print("Numbers in mixed \(numbers)")

        // Im not writing out messages for all of these
        print(filteredSightings)
        print(sightingScores)
        print(totalSightingScore)
        print(highestScore)
        print(lowestScore)

        print(sampleIsLowercase ? "The string is lowercase" : "Nope change it")
        print(sampleLessThan8Chars ? "The string is less than 8 char" : "Nope change it")

        print(wing)
        print(room)
        print(shelf)
        print(word)
        
    }
}

func accepts(_ input: String, isValid: (String) -> Bool) -> Bool {
    return isValid(input)
}
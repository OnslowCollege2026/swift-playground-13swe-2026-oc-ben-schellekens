// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
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

        let numbers: [Int] = mixed.compactMap {Int($0)}

        let firstItemOfTheLastItemOfTheLastItemOfTheLastItemOfTheArchive = archive.last?.last?.last?.first

        let filteredSightings: Array<(name: String, score: Int)> = sightings.filter({
            let nameLetter: String = String($0.name.split(separator: "")[0])
            return nameLetter == "m" || nameLetter == "w"
        })

        let sightingScores: [Int] = filteredSightings.map {$0.score}

        print(filteredSightings)
        

        print(numbers)

        print("The first item of the last item of the last item of the last item of the archive is \(firstItemOfTheLastItemOfTheLastItemOfTheLastItemOfTheArchive ?? "Genuninley how did this fail what")")
        
        print("")
        
    }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct SwiftPlayground {
    static func main() {

        let theZook: Book = Book(title: "The Zook", author: "Prof. Z. Zook", pages: .max)
        let theBook: Book = Book(title: "The Book", author: "Prof. B. Book", pages: .min)

        print(theZook.summary())
        print(theBook.summary())
        print("The method method is cleaner because all of the calling is way easier towrite as you dont have to access every individual peice of data.")

        print("22ºF to ºC: \(Temperature.toCelsius(farenheit: 22))")
        print("2147483647ºF to ºC: \(Temperature.toCelsius(farenheit: 2147483647))")
        print("99ºC to ºF: \(Temperature.toFarenheit(celsius: 99))")

        print("The static method is better because it can be used with any number and doesn't require a class to made for one conversion.")


    }
}

struct Book {
    var title: String
    var author: String
    var pages: Int

    func summary() -> String {
        return "\"\(title)\" by \(author) has \(pages) pages"
    }
}

func bookSummary(_ title: String, by author: String, pages: Int) -> String {
    return "\"\(title)\" by \(author) has \(pages) pages"
}

struct Temperature {
    static func toFarenheit(celsius: Double) -> Double {
        return (celsius * 1.8) + 32 
    }

    static func toCelsius(farenheit: Double) -> Double {
        return (farenheit - 32) * (5 / 9)
    }
}

struct Timer {
    var seconds: Int 
    var isRunning: Bool

    mutating func start() {

    }

    mutating func tick() {

    }

    mutating func reset() {
        
    }
}
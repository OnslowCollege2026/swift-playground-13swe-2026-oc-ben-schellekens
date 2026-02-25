// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct SwiftPlayground {
    static func main() {

        let theZook: Book = Book(title: "The Zook", author: "Prof. Z. Zook", pages: .max)
        let theBook: Book = Book(title: "The Book", author: "Prof. B. Book", pages: .min)

        // The method method is cleaner because all of the calling is way easier towrite as you dont have to access every individual peice of data.
        print(theZook.summary())
        print(theBook.summary())

        // The static method is better because it can be used with any number and doesn't require a class to made for one conversion.
        print("22ºF to ºC: \(Temperature.toCelsius(farenheit: 22))")
        print("2147483647ºF to ºC: \(Temperature.toCelsius(farenheit: 2147483647))")
        print("99ºC to ºF: \(Temperature.toFarenheit(celsius: 99))")

        var timer: Timer = Timer(seconds: 0, isRunning: false)

        print(timer.info)

        timer.start()
        print(timer.info)
        

        while timer.seconds < 10 {
            timer.tick()
            print(timer.info)
        }

        timer.reset()
        print(timer.info)

        timer.tick()
        print(timer.info)

        var shoppingCart: Cart = Cart()

        while shoppingCart.itemsCount <= 5 {
            shoppingCart.addItem()
            print("Items: \(shoppingCart.itemsCount), \(shoppingCart.shippingMessage)")
        }
        

        let badge: Badge = Badge(name: "Ranger", level: 4)

        // It was the same. Source: trust me bro
        print(badge.label)
        
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

    var info: String {"Timer \(isRunning ? "running" : "stopped"), at \(seconds)s"}

    mutating func start() {
        isRunning = true
    }

    mutating func tick() {
        if isRunning { seconds += 1 }
    }

    mutating func reset() {
        seconds = 0
        isRunning = false
    }
}

//TODO: Task D comments part
struct Cart {
    // These should be the same between all different instances of cart, and also unmodifiable.
    static let freeShippingThreshold: Int = 5
    static func qualifiesForFreeShipping(_ count: Int) -> Bool { return count >= freeShippingThreshold }


    var itemsCount: Int = 0

    /* 
    Because addItem() and shippingMessage() interact directly with the data in the struct, they are instance level to be able to use that data
    */
    mutating func addItem() {
        itemsCount += 1
    }

    var shippingMessage :String {
        Cart.qualifiesForFreeShipping(itemsCount) ? "Free shipping" : "Shipping applies"
    }
}

struct Badge {
    var name: String
    var level: Int

    var label: String {
        "\(name) - Level \(level)"
    }
}
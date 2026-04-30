// School library book borrowing system
// Program entrypoint and other stuff

import Foundation

let yearInSeconds: Double = 3.154e+7

@main
struct SwiftPlayground {
    static func main() {
        var isRunning: Bool = true

        var books: Set<Book> = [
            Book(id: 123, title: "abci", author: "abc"),
            Book(id: 9_780435_124090, title: "The Handmaid's Tale", author: "Margaret Atwood"),
            Book(id: 9_781775_542483, title: "Budget like a legend", author: "Cameron Wislang"),
            Book(
                id: 9_718856_694414, title: "Colour: how to user colour in art and design",
                author: "Edith Anderson Feisner"),
        ]

        var borrowers: Set<Borrower> = [
            Borrower(
                id: UUID(), firstName: "Greg", lastName: "test", age: 20)
        ]

        let loans: Set<Loan> = [
            Loan(
                book: books[books.startIndex], borrower: borrowers.first!,
                returnDate: Date(timeIntervalSinceNow: 1 * 60 * 60)),

            Loan(
                book: books[books.index(books.startIndex, offsetBy: 1)], borrower: borrowers.first!,
                returnDate: Date(timeIntervalSinceNow: -1 * 60 * 60)),
        ]

        print(books.first!)

        UI.showOverdueLoans(loans: loans)

        print(UI.findBook(books: books, bookName: getStringFromUser("Test")) ?? "Fuck you")

        _ = readLine()

        while /*program*/ isRunning {
            print(
                """
                \u{001b}[2J\u{001b}[H---Available options---
                [l]: Manage loans
                [b]: Manage books
                [u]: Manage borrowers

                [?]: Help
                [q]: Quit
                -----------------------
                """)

            switch getStringFromUser("Enter an option", length: 1...1).lowercased() {
            case "l":
                print("loans")
            case "b":
                UI.manageBooks(books: &books)
            case "u":
                print("borrowers")
                UI.addBorrower(borrowers: &borrowers)

            case "?":
                print("Help")
            case "q":
                isRunning = false
            default:
                print("not an option")

            }
        }

        print(loans)
        print(borrowers)
        print(books)
    }
}

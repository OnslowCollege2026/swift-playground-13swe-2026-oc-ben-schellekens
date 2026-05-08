// School library book borrowing system
// Program entrypoint and other stuff

import Foundation

let yearInSeconds: Double = 3.154e+7

@main
struct SwiftPlayground {
    static func main() {
        var isRunning: Bool = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "NZ")

        /// Books available in the library
        var books: Set<Book> = [
            Book(id: 123, title: "Test2", author: "John2", genre: "Test2")
            // Book(id: 9_923782_123784, title: "abci", author: "abc", genre: "abc"),
            // Book(
            //     id: 9_780435_124090, title: "The Handmaid's Tale", author: "Margaret Atwood",
            //     genre: "Speculative Fiction"),
            // Book(
            //     id: 9_781775_542483, title: "Budget like a legend", author: "Cameron Wislang",
            //     genre: "Educational"),
            // Book(
            //     id: 9_718856_694414, title: "Colour: how to user colour in art and design",
            //     author: "Edith Anderson Feisner", genre: "Non-fiction"),
            // Book(id: 9_781784_878979, title: "1984", author: "George orwell", genre: "Dystopia"),
        ]

        /// Borrowers registered in the library
        var borrowers: Set<Borrower> = [
            Borrower(id: UUID(), firstName: "Greg", lastName: "Test", age: 30)
            // Borrower(id: UUID(), firstName: "Greg", lastName: "test", age: 20),
            // Borrower(id: UUID(), firstName: "Greg", lastName: "test2", age: 40),
            // Borrower(id: UUID(), firstName: "OtherPerson", lastName: "InTheCall", age: 20),
        ]

        /// Book loans (both historic and not)
        var loans: Set<Loan> = [
            Loan(
                book: books[books.startIndex],
                borrower: borrowers[borrowers.startIndex],
                returnDate: dateFormatter.date(from: "11/11/2026") ?? Date.now)
        ]

        while /*program*/ isRunning {
            print(
                """
                \u{001b}[2J\u{001b}[H---Available options---
                [b]: Manage books
                [u]: Manage borrowers
                [l]: Manage loans

                [?]: Help
                [q]: Quit
                -----------------------
                """)

            switch getStringFromUser("Enter an option", length: 1...1).lowercased() {
            case "l":
                UI.manageLoans(loans: &loans, borrowers: borrowers, books: books)
            case "b":
                UI.manageBooks(books: &books)
            case "u":
                UI.manageBorrowers(borrowers: &borrowers)
            case "?":
                print("Help")
            case "q":
                isRunning = false
            default:
                print("not an option")

            }
        }

        UI.listBooks(books: books)
        UI.listBorrowers(borrowers: borrowers)
        UI.listLoans(loans: loans)

    }
}

// School library book borrowing system
import Foundation

let yearInSeconds: Double = 3.154e+7

@main
struct SwiftPlayground {
    static func main() {
        var isRunning: Bool = true

        let books: Set<Book> = [
            Book(id: 9_780435_124090, title: "The Handmaid's Tale", author: "Margaret Atwood"),
            Book(id: 9_781775_542483, title: "Budget like a legend", author: "Cameron Wislang"),
            Book(
                id: 9_718856_694414, title: "Colour: how to user colour in art and design",
                author: "Edith Anderson Feisner"),
        ]

        let borrowers: Set<Borrower> = [
            Borrower(
                id: UUID(), firstName: "Greg", lastName: "test",
                dateOfBirth: Date.distantPast)
        ]

        let loans: Set<Loan> = [
            Loan(
                book: books[books.startIndex], borrower: borrowers.first!,
                returnDate: Date(timeIntervalSinceNow: 1 * 60 * 60)),

            Loan(
                book: books[books.index(books.startIndex, offsetBy: 1)], borrower: borrowers.first!,
                returnDate: Date(timeIntervalSinceNow: -1 * 60 * 60)),
        ]

        print(borrowers.first!)

        UI.showOverdueLoans(loans: loans)

        while /*program*/ isRunning {
            _ = getStringFromUser("Test input", from: 5, to: 10)

            print("\u{001b}[92;1;3mInput valid!\u{001b}[0m")
        }
    }
}

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
            print("""
            Available options:
            [l]: Manage loans
            [b]: Manage books
            [u]: Manage borrowers

            [?]: Help
            [q]: Quit
            """)


            switch getStringFromUser("Enter an option", length: 1...1).lowercased() {
                case "l":
                print("loans")
                case "b":
                print("books")
                case "u":
                print("borrowers")

                case "?":
                print("Help")
                case "q":
                isRunning = false
                default:
                print("not an option")
                

            }
        }
    }
}

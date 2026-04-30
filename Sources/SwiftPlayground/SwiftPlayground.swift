// School library book borrowing system
import Foundation

let yearInSeconds: Double = 3.154e+7

@main
struct SwiftPlayground {
    static func main() {
        let isRunning: Bool = true
        let books: [Book] = [
            Book(id: 50003, title: "Test Book", author: "Greg v. haloumen")
        ]

        let borrowers: [Borrower] = [
            Borrower(
                id: UUID(), firstName: "Greg", lastName: "test",
                dateOfBirth: Date(timeIntervalSinceNow: -1.261e+8))
        ]

        let loans: [Loan] = [
            Loan(
                book: books[0], borrower: borrowers[0],
                returnDate: Date(timeIntervalSinceNow: 1 * 60 * 60))
        ]

        print(borrowers[0].age)

        loans.forEach {
            print($0)
            print($0.isOverdue)
            print()
        }

        while /*program*/ isRunning {
            _ = getStringFromUser("Test input", from: 5, to: 10)

            print("\u{001b}[92;1;3mInput valid!\u{001b}[0m")
        }
    }
}

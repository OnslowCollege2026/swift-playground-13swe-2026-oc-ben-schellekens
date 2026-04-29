// School library book borrowing system
import Foundation

let yearInSeconds: Double = 3.154e+7

let errorPrefix: String = "\u{001b}[1;31mError:\u{001b}[0m"
let warnPrefix: String = "\u{001b}[1;31mWarning:\u{001b}[0m"
let infoPrefix: String = "\u{001b}[1;31mInfo:\u{001b}[0m"

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()

    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeZone = TimeZone(abbreviation: "NZDT")

    return formatter.string(from: date)
}

/// Struct to represent a book
struct Book: CustomStringConvertible, Identifiable, Codable, Hashable {
    /// The book's ISBN
    let id: Int

    /// The title of the book
    var title: String

    /// The author of the book
    var author: String

    var description: String {
        "ISBN: \(id) | \(title) by \(author)"
    }
}

/// Struct to represent a borrower
struct Borrower: CustomStringConvertible, Identifiable, Codable, Hashable {
    /// Borrower ID.
    let id: UUID

    /// The name of the borrower.
    var firstName: String

    // Last name of the borrower
    var lastName: String

    /// Borrower's date of birth
    var dateOfBirth: Date

    var age: Int {
        Int(floor((dateOfBirth.timeIntervalSinceNow * -1) / 3.154e+7))
    }

    var description: String {
        "Borrower \(firstName) \(lastName) is \(age) year(s) old (Born \(dateOfBirth))"
    }
}

/// Struct to represent a Book loan
struct Loan: CustomStringConvertible {
    /// ID of the book that is being loaned
    let book: Book

    /// ID of the borrower that is loaning out the book
    let borrower: Borrower

    /// The date the book needs to be returned by
    var returnDate: Date

    var isOverdue: Bool {
        returnDate.timeIntervalSinceNow <= 0
    }

    var description: String {
        "\(borrower.name)'s issued book \(book.title) (ISBN \(book.id)) is due back \(returnDate)"
    }
}

@main
struct SwiftPlayground {
    static func main() {
        var books: [Book] = [
            Book(id: 50003, title: "Test Book", author: "Greg v. haloumen")
        ]

        var borrowers: [Borrower] = [
            Borrower(id: UUID(), name: "Greg test", dateOfBirth: Date(timeIntervalSinceNow: -1.261e+8))
        ]

        var loans: [Loan] = [
            Loan(
                book: books[0], borrower: borrowers[0],
                returnDate: Date.now)
        ]

        print(borrowers[0].age)

        loans.forEach {
            print($0)
            print($0.isOverdue)
            print()
        }
    }
}

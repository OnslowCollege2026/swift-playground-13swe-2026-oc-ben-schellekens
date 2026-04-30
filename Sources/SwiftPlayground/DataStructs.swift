// Structs to store data from the user.
import Foundation

/// Struct to represent a book
struct Book: CustomStringConvertible, Identifiable, Codable, Hashable {
    /// The book's ISBN13
    let id: Int

    /// The title of the book
    var title: String

    /// The author of the book
    var author: String

    var description: String {
        "ISBN: \(id) | \(title) by \(author)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Struct to represent a borrower
struct Borrower: CustomStringConvertible, Identifiable, Codable, Hashable {
    /// Borrower ID.
    let id: UUID

    /// The name of the borrower.
    var firstName: String

    /// Last name of the borrower
    var lastName: String

    /// Borrower's date of birth
    var age: Int

    var description: String {
        "Borrower \(firstName) \(lastName) is \(age) year(s) old"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Struct to represent a Book loan
struct Loan: CustomStringConvertible, Hashable {
    /// The book that is being loaned
    let book: Book

    /// ID of the borrower that is loaning out the book
    let borrower: Borrower

    /// The date the book needs to be returned by
    var returnDate: Date

    var returned: Bool = false

    var isOverdue: Bool {
        returnDate.timeIntervalSinceNow <= 0 && returned == false
    }

    var description: String {
        let isWas = isOverdue ? "was" : "is"
        return "\(borrower.firstName)'s issued book \(book.title) (ISBN \(book.id)) \(isWas) due back \(UI.formatDate(returnDate))"
    }

    // Hash the book ID, borrower ID and return date together.
    func hash(into hasher: inout Hasher) {
        hasher.combine(book.id) 
        hasher.combine(borrower.id)
        hasher.combine(returnDate)
    }
}

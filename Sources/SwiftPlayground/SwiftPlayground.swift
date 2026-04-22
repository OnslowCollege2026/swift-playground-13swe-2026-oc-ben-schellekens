// School library book borrowing system
// No database (not confident enough)
//

import Foundation

/// Struct to represent a book
struct Book: CustomStringConvertible {
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
struct Borrower {
    /// Borrower ID.
    let id: UUID

    /// The name of the borrower.
    var name: String
}

// Struct to represent a Book loan
struct Loan {
    let bookID: Int
    let borrowerID: UUID

}

@main
struct SwiftPlayground {
    static func main() {
        print(Book(id: 2, title: "Test Book", author: "Greg test"))
    }
}

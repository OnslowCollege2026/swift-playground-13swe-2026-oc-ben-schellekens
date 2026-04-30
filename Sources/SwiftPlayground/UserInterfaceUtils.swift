// Utilities for user interface creation
import Foundation

/// Gets Input from the user and validates it against some critera
/// - Parameters:
///   - prompt: The Prompt to show the user.
///   - min: the minimum length of the string, 0 allows for empty strings. (default: 1)
///   - max: the maximum length of the string. (default: 9223372036854775807)
///   - terminator: What to end the prompt with (default: ": ")
///
/// - Returns: A string with a length between min and max
func getStringFromUser(
    _ prompt: String, length: ClosedRange<Int> = 1...Int.max, terminator: String = ": "
) -> String {
    while true {
        print(prompt, terminator: terminator)
        if let input = readLine() {
            if input.isEmpty && length.lowerBound > 0 {
                UI.warnPrint("Input invalid (empty string submitted), please try again")
                continue
            } else if input.count < length.lowerBound {
                UI.warnPrint(
                    "Input length is less than the minimum (\(length.lowerBound) character(s))")
                continue
            } else if input.count > length.upperBound {
                UI.warnPrint(
                    "Input length is more than the maximum (\(length.upperBound) character(s))")
                continue
            }

            return input
        }

    }
}

/// Gets an integer from the user and makes sure it is in a specific range
/// - Parameters:
///   - prompt: The Prompt to show the user.
///   - range: The range in which the number should be in
///   - terminator: What to end the prompt with (default: ": ")
///
/// - Returns: A string with a length between min and max
func getIntFromUser(
    _ prompt: String, range: ClosedRange<Int> = 1...Int.max, terminator: String = ": "
) -> Int {
    while true {
        let input = getStringFromUser(prompt, terminator: terminator)

        guard let integer: Int = Int(input) else {
            UI.errorPrint("Not a valid integer.")
            continue
        }

        switch integer {
        case range:
            return integer
        case ...range.lowerBound:
            UI.warnPrint("Number too small, please try again (Minimum: \(range.lowerBound))")
            continue
        case range.upperBound...:
            UI.warnPrint("Number too large, please try again (Maximum: \(range.upperBound))")
            continue
        default:
            print("test")
        }
    }
    return 0
}

/// Struct to help with the creation of user interfaces
struct UI {

    // Printing prefixes
    /// Prefix for printing error messages
    static let errorPrefix: String = "\u{001b}[1;31mError:\u{001b}[0m"
    /// Prefix for printing warning messages
    static let warnPrefix: String = "\u{001b}[1;31mWarning:\u{001b}[0m"
    /// Prefix for printing info messages
    static let infoPrefix: String = "\u{001b}[1;31mInfo:\u{001b}[0m"

    static func formatDate(_ date: Date) -> String { "asd" }

    /// Prints message as an error
    /// - Parameter message: The message to output
    static func errorPrint(_ message: String) { print("\(errorPrefix) \(message)") }
    /// Prints message as an warning
    /// - Parameter message: The message to output
    static func warnPrint(_ message: String) { print("\(warnPrefix) \(message)") }
    /// Prints message as an info message
    /// - Parameter message: The message to output
    static func infoPrint(_ message: String) { print("\(infoPrefix) \(message)") }

    static func showOverdueLoans(loans: Set<Loan>) {
        let overdueLoans = loans.filter { loan in
            loan.isOverdue
        }

        if overdueLoans.count < 1 {
            UI.infoPrint("No overdue loans!")
            return
        }

        overdueLoans.forEach({ loan in
            print(loan)
        })

        infoPrint("\(overdueLoans.count) overdue loan(s)")
    }

    static func manageBooks(books: inout Set<Book>) {
        print(
            """
            \u{001b}[2J\u{001b}[H---Available options---
            [a]: Add a book
            [e]: Edit the info of a book
            [d]: Delete a book

            [B]: go back
            -----------------------
            """)

        switch getStringFromUser("Select an option", length: 0...1) {
        case "b", "":
            return
        case "a":
            addBook(books: &books)
        case "e":
            if let wantedBook = findBook(
                books: books, bookName: getStringFromUser("Search for a book")),
                let index = books.firstIndex(of: wantedBook)
            {
                editBook(books: &books, index: index)
            } else {
                print("fuck you")
            }
        default:
            print("Not an option")
            print("Press enter to continue ...", terminator: "")
            _ = readLine()
        }
    }

    static func addBook(books: inout Set<Book>) {
        let ISBN: Int = getIntFromUser(
            "Enter the ISBN-13 of the book", range: 1...9_999_999_999_999)
        let title: String = getStringFromUser("Enter the author of the book", length: 1...50)
        let author: String = getStringFromUser("Enter the title of the book", length: 1...50)

        print("Do you want to add the book \(title) by \(author) (ISBN \(ISBN))?")
        if getStringFromUser("[y]es/[N]o", length: 0...1).lowercased != "y" {
            UI.infoPrint("Cancelled adding book")
            return
        }

        let bookToAdd: Book = Book(id: ISBN, title: title, author: author)

        if books.contains(bookToAdd) {
            UI.warnPrint("Book already exists!")
            print("Press enter to continue ...", terminator: "")
            _ = readLine()
        } else {
            books.formUnion([bookToAdd])
        }

    }

    static func findBook(books: Set<Book>, bookName: String) -> Book? {
        let filteredBooks = books.filter { book in
            book.title.contains(bookName)
        }

        if filteredBooks.count < 1 { return nil }
        if filteredBooks.count == 1 { return filteredBooks[filteredBooks.startIndex] }

        filteredBooks.enumerated().forEach({ offset, book in
            print("[\(offset + 1)]: \(book)")
        })

        let sel = getIntFromUser("Select a book", range: 1...filteredBooks.count) - 1

        return filteredBooks[filteredBooks.index(filteredBooks.startIndex, offsetBy: sel)]

    }

    static func editBook(books: inout Set<Book>, index: Set<Book>.Index) {

    }

    static func addBorrower(borrowers: inout Set<Borrower>) {
        let id: UUID = UUID()
        let firstName: String = getStringFromUser("Enter the person's first name", length: 1...50)
        let lastName: String = getStringFromUser("Enter the person's last name", length: 1...50)
        let age: Int = getIntFromUser("Enter the user's age", range: 0...150)

        print("Do you want to add the borrower \(firstName) \(lastName) (age \(age))?")
        if getStringFromUser("[y]es/[N]o", length: 0...1).lowercased != "y" {
            UI.infoPrint("Cancelled adding person")
            return
        }

        let newBorrower: Borrower = Borrower(
            id: id, firstName: firstName, lastName: lastName, age: age)

        borrowers.formUnion([newBorrower])
    }

}

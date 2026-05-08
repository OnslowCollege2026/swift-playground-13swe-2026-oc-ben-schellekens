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

/// Gets a date as input from the user
/// - Parameters:
///   - prompt: The prompt to show the user
///   - terminator: What to end the prompt with (default: ": ")
///
/// - Returns: A swift date object wih the year month and day seleted by the user
func getDateFromUser(_ prompt: String, terminator: String = ": ") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/M/yyyy"
    while 3 != 7 {
        let input: String = getStringFromUser(prompt, length: 8...10)

        guard let date = dateFormatter.date(from: input) else {
            UI.errorPrint("Not a valid date!")
            continue
        }

        return date
    }
}

/// Struct to help with the creation of user interfaces
struct UI {

    // Printing prefixes
    /// Prefix for printing error messages
    static let errorPrefix: String = "\u{001b}[1;31mError:\u{001b}[0m"
    /// Prefix for printing warning messages
    static let warnPrefix: String = "\u{001b}[1;33mWarning:\u{001b}[0m"
    /// Prefix for printing info messages
    static let infoPrefix: String = "\u{001b}[1;34mInfo:\u{001b}[0m"

    /// Formats a date to a string
    /// - Parameter date: the date to format
    /// - Returns: Date formatted as hh:mm dd/mm/yyyy in NZT
    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm d/M/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "NZ")

        return dateFormatter.string(from: date)
    }

    /// Pauses the program for until the user presses enter.
    static func pause() {
        print("Press enter to continue...", terminator: "")
        _ = readLine()
    }

    /// Prints message as an error
    /// - Parameter message: The message to output
    static func errorPrint(_ message: String) { print("\(errorPrefix) \(message)") }
    /// Prints message as an warning
    /// - Parameter message: The message to output
    static func warnPrint(_ message: String) { print("\(warnPrefix) \(message)") }
    /// Prints message as an info message
    /// - Parameter message: The message to output
    static func infoPrint(_ message: String) { print("\(infoPrefix) \(message)") }

    /// Lists loans in a human-readable way
    /// - Parameter loans: The set of loans to list
    static func listLoans(loans: Set<Loan>) {
        guard loans.count > 0 else {
            UI.infoPrint("No loans in set!")
            return
        }

        var mappedLoans: [Borrower: [Loan]] = [:]

        loans.forEach { loan in
            if let borrowerIndex = mappedLoans.index(forKey: loan.borrower) {
                var currentLoans: [Loan] = mappedLoans[borrowerIndex].value
                currentLoans.append(loan)

                mappedLoans.updateValue(currentLoans, forKey: loan.borrower)

            } else {
                mappedLoans.updateValue([loan], forKey: loan.borrower)
            }
        }

        mappedLoans.forEach({ element in
            print(
                """
                ┌ Loans for \(element.key.fullName):
                """)

            element.value.forEach({ loan in
                // let isWas = loan.isOverdue ? "was" : "is"
                print(
                    """
                    │
                    ├┬ \(loan.book.title) by \(loan.book.author) (ISBN: \(loan.book.id)) \(loan.returned ? "[Returned]" : "")
                    │└ Due back \(UI.formatDate(loan.returnDate)) \(loan.isOverdue && !loan.returned ? "(Overdue)" : "")
                    """)
            })
            print("└")

        })

        let activeLoans: Int = loans.reduce(0) { partialResult, loan in
            partialResult + (!loan.returned ? 1 : 0)
        }

        let overdueLoans: Int = loans.reduce(0) { partialResult, loan in
            partialResult + (loan.isOverdue ? 1 : 0)
        }

        infoPrint("\(loans.count) loans total, \(activeLoans) active, \(overdueLoans) overdue")
    }

    /// Lists books in a human-readable way
    /// - Parameter books: The set of books to list
    static func listBooks(books: Set<Book>) {
        guard books.count > 0 else {
            UI.infoPrint("No books found!")
            return
        }
        books.sorted(by: { lhs, rhs in lhs.id < rhs.id }).forEach {
            print($0)
        }

        infoPrint("Total books: \(books.count)")
    }

    /// Lists borrowers in a human readable way
    /// - Parameter borrowers: The set of borrowers to list
    static func listBorrowers(borrowers: Set<Borrower>) {
        guard borrowers.count > 0 else {
            UI.infoPrint("No borrowers found!")
            return
        }
        borrowers.sorted(by: { lhs, rhs in lhs.id < rhs.id }).forEach { print($0) }

        infoPrint("Total borrowers: \(borrowers.count)")
    }

    // Book managment

    /// Gets the users choice for book managment
    /// - Parameter books: The set of books to act upon/manage
    static func manageBooks(books: inout Set<Book>) {
        print(
            """
            \u{001b}[2J\u{001b}[H---Available options---
            [a]: Add a book
            [e]: Edit the info of a book
            [d]: Delete a book

            [s]: Search for books
            [l]: List books

            [B]: go back
            -----------------------
            """)

        switch getStringFromUser("Select an option", length: 0...1).lowercased {
        case "a":
            addBook(books: &books)
        case "e":
            listBooks(books: books)
            let bookName = getStringFromUser("Search for a book", length: 1...50)
            if let wantedBook = findBook(
                books: books, bookName: bookName),
                let index = books.firstIndex(of: wantedBook)
            {
                editBook(books: &books, index: index)
            } else {
                errorPrint("No books with \(bookName) in the name found!")
                UI.pause()
            }
        case "d":
            listBooks(books: books)
            let bookName = getStringFromUser("Search for a book", length: 1...50)
            if let wantedBook = findBook(books: books, bookName: bookName),
                let index = books.firstIndex(of: wantedBook)
            {
                removeBook(books: &books, index: index)
            } else {
                errorPrint("No books with \(bookName) in the name found!")
                UI.pause()
            }
        case "l":
            listBooks(books: books)
            UI.pause()
        case "s":
            print(
                """
                [n]: Search by name
                [i]: Search by ID

                [B]: go back
                """)
            switch getStringFromUser("Select an option", length: 0...1).lowercased() {
            case "i":
                let id = getStringFromUser("Search for a book's ID", length: 1...50)
                listBooks(books: books.filter({ String($0.id).contains(id) }))
            case "n":
                let bookName = getStringFromUser("Search for a book's name", length: 1...50)
                listBooks(books: books.filter({ $0.title.contains(bookName) }))
            default:
                return
            }
            UI.pause()
        default:
            print("Not an option")
            UI.pause()
        }
    }

    /// Adds a book to the set of books, Using user input to fill out the fields
    /// - Parameter books: The set of books to add the book to
    static func addBook(books: inout Set<Book>) {
        let ISBN: Int = getIntFromUser(
            "Enter the ISBN-13 of the book", range: 1...9_999_999_999_999)
        let title: String = getStringFromUser("Enter the title of the book", length: 1...50)
        let author: String = getStringFromUser("Enter the author of the book", length: 1...50)
        let genre: String = getStringFromUser("Enter the genre of the book", length: 1...50)

        print(
            """
            Do you want to add the book:
            \(title) by \(author) ?
            Genre: \(genre)
            ISBN: \(ISBN)
            """)
        if getStringFromUser("[y]es/[N]o", length: 0...1).lowercased != "y" {
            UI.infoPrint("Cancelled adding book")
            return
        }

        let bookToAdd: Book = Book(id: ISBN, title: title, author: author, genre: genre)

        if books.filter({ $0.id == ISBN }).count > 0 {
            UI.warnPrint("Book already exists!")
            UI.pause()
        } else {
            books.formUnion([bookToAdd])
        }
    }

    /// Finds a book in a set of books, using user input to find a specific book
    /// - Parameters:
    ///   - books: The set of books to search for
    ///   - bookName: The name of the book to search for
    ///
    /// - Returns: The book with the name bookName, if there is multiple books, whichever one the user chooses
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

    /// Edits the information of a book in a set
    /// - Parameters:
    ///   - books: The set of books containing the index to be edited
    ///   - index: The index of the book to be edited
    ///
    static func editBook(books: inout Set<Book>, index: Set<Book>.Index) {

        var newBook: Book = books[index]

        print(
            """
            What do you want to change?

            [t]: Title
            [a]: Author
            [g]: Genre

            [B]: back
            """)

        switch getStringFromUser("Select and option", length: 0...1).lowercased {
        case "b", "":
            UI.infoPrint("Bring up")
            return
        case "t":
            newBook.title = getStringFromUser("Please enter the new title", length: 1...50)
        case "a":
            newBook.author = getStringFromUser("Please enter the new author", length: 1...50)
        case "g":
            newBook.genre = getStringFromUser("Please enter the new genre", length: 1...50)
        default:
            UI.infoPrint("going back")
            return
        }

        if let oldBookIndex = books.firstIndex(where: { book in book.hashValue == newBook.hashValue
        }) {
            books.remove(at: oldBookIndex)
            books.formUnion([newBook])
        } else {
            UI.errorPrint("Could not find book to edit!")
        }
    }

    /// Removes a book from a set of books, with confirmation from the user
    /// - Parameters:
    ///   - books: The set to remove the book from
    ///   - index: The index of the book to remove
    ///
    static func removeBook(books: inout Set<Book>, index: Set<Book>.Index) {
        if getStringFromUser(
            "Do you want to remove the book \(books[index])? ([y]es/[N]o)", length: 0...1
        ).lowercased != "y" {
            UI.infoPrint("Cancelled adding book")
            return
        }

        books.remove(at: index)
    }

    // Borrower managment

    /// Option picker for managing the borrowers
    /// - Parameter borrowers: The set of borrowers to use
    static func manageBorrowers(borrowers: inout Set<Borrower>) {
        print(
            """
            \u{001b}[2J\u{001b}[H---Available options---
            [a]: Add a borrower
            [e]: Edit the info of a borrower
            [d]: Delete a borrower

            [l]: List borrowers
            [s]: Search for borrowers

            [B]: go back
            -----------------------
            """)

        switch getStringFromUser("Select an option", length: 0...1).lowercased {
        case "a":
            addBorrower(borrowers: &borrowers)
        case "e":
            let borrowerName = getStringFromUser("Search for a borrower's name", length: 1...50)
            if let wantedBorrower = findBorrower(
                borrower: borrowers, borrowerName: borrowerName),
                let index = borrowers.firstIndex(of: wantedBorrower)
            {
                editBorrower(borrowers: &borrowers, index: index)
            } else {
                errorPrint("No books with \(borrowerName) in the name found!")
                UI.pause()
            }
        case "d":
            let borrowerName = getStringFromUser("Search for a borrower's name", length: 1...50)
            if let wantedBorrower = findBorrower(
                borrower: borrowers, borrowerName: borrowerName),
                let index = borrowers.firstIndex(of: wantedBorrower)
            {
                removeBorrower(borrowers: &borrowers, index: index)
            } else {
                errorPrint("No borrowers with \(borrowerName) in the name found!")
                UI.pause()
            }
        case "l":
            listBorrowers(borrowers: borrowers)
            UI.pause()
        case "s":
            let borrowerName = getStringFromUser("Search for a borrower's name", length: 1...50)
            listBorrowers(borrowers: borrowers.filter({ $0.fullName.contains(borrowerName) }))
            UI.pause()
        default:
            return
        }
    }

    /// Add a borrower to a set of borrowers, using user input for all of the information
    /// - Parameter borrowers: The set of borrowers to add to
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

    /// Finds a book in a set of books, using user input to find a specific book
    /// - Parameters:
    ///   - borrowers: The set of books to search for
    ///   - borrowerName: The name of the book to search for
    ///
    /// - Returns: The borrower with the name borrowerName, if there is multiple borrowers, whichever one the user chooses
    static func findBorrower(borrower: Set<Borrower>, borrowerName: String) -> Borrower? {

        let filteredBorrowers: Set<Borrower> = borrower.filter {
            $0.fullName.contains(borrowerName)
        }

        if filteredBorrowers.count < 1 { return nil }
        if filteredBorrowers.count == 1 { return filteredBorrowers[filteredBorrowers.startIndex] }

        filteredBorrowers.enumerated().forEach({ offset, book in
            print("[\(offset + 1)]: \(book)")
        })

        let sel = getIntFromUser("Select a borrower", range: 1...filteredBorrowers.count) - 1

        return filteredBorrowers[
            filteredBorrowers.index(filteredBorrowers.startIndex, offsetBy: sel)]
    }

    /// Edits a specific borrower in a list of borrowers
    /// - Parameters:
    ///   - borrowers: The set of borrowers to edit the borrower in
    ///   - index: The index of the borrower to be edited
    ///
    static func editBorrower(borrowers: inout Set<Borrower>, index: Set<Borrower>.Index) {

        var newBorrower: Borrower = borrowers[index]

        print(
            """
            Current borrower: \(borrowers[index])
            What do you want to change?

            [f]: First name
            [l]: Last name
            [a]: Age

            [B]: back
            """)

        switch getStringFromUser("Select and option", length: 0...1).lowercased {
        case "f":
            newBorrower.firstName = getStringFromUser(
                "Please enter the new first name", length: 1...50)
        case "l":
            newBorrower.lastName = getStringFromUser(
                "Please enter the new last name", length: 1...50)
        case "a":
            newBorrower.age = getIntFromUser("Please enter the new age", range: 1...150)
        default:
            UI.infoPrint("going back")
            return
        }

        if let oldBorrowerIndex = borrowers.firstIndex(where: { borrower in
            borrower.hashValue == newBorrower.hashValue
        }) {
            borrowers.remove(at: oldBorrowerIndex)
            borrowers.formUnion([newBorrower])
        } else {
            UI.errorPrint("Could not find book to edit!")
        }
    }

    /// Removes a borrower from a set, with confirmation from the user
    /// - Parameters:
    ///   - borrowers: the set to remove the borrower from
    ///   - index: the index of the borrower that should be removed
    ///
    static func removeBorrower(borrowers: inout Set<Borrower>, index: Set<Borrower>.Index) {
        if getStringFromUser(
            "Do you want to remove the \(borrowers[index])? ([y]es/[N]o)", length: 0...1
        ).lowercased != "y" {
            UI.infoPrint("Cancelled removing borrower")
            return
        }

        borrowers.remove(at: index)
    }

    static func manageLoans(loans: inout Set<Loan>, borrowers: Set<Borrower>, books: Set<Book>) {
        print(
            """
            \u{001b}[2J\u{001b}[H---Available options---
            [a]: Loan a book out
            [r]: Mark a loan as returned
            [d]: Delete a borrower

            [l]: List out all loans

            [B]: go back
            -----------------------
            """)

        switch getStringFromUser("Select an option", length: 0...1).lowercased {
        case "a":
            let borrowerName = getStringFromUser("Search for a borrower's name", length: 1...50)
            guard
                let borrower: Borrower = findBorrower(
                    borrower: borrowers, borrowerName: borrowerName)
            else {
                UI.errorPrint("No borrower found!")
                return
            }
            let bookName = getStringFromUser("Search for a book", length: 1...50)
            guard let book: Book = findBook(books: books, bookName: bookName) else {
                UI.errorPrint("No book found!")
                return
            }

            addLoan(loans: &loans, borrower: borrower, book: book)
        case "r":
            let borrowerName = getStringFromUser("Search for a borrower's name", length: 1...50)
            guard
                let borrower: Borrower = findBorrower(
                    borrower: borrowers, borrowerName: borrowerName)
            else {
                UI.errorPrint("No borrower found!")
                UI.pause()
                return
            }
            let bookName = getStringFromUser("Search for a book", length: 1...50)
            guard let book: Book = findBook(books: books, bookName: bookName) else {
                UI.errorPrint("No book found!")
                UI.pause()
                return
            }
            guard
                let loan = findLoan(
                    loans: loans.filter({ !$0.returned }), borrower: borrower, book: book),
                let index = loans.firstIndex(of: loan)
            else {
                UI.errorPrint("No active loan with that borrower and book foud!")
                UI.pause()
                return
            }

            returnLoan(loans: &loans, index: index)
        case "d":
            let borrowerName = getStringFromUser("Search for a borrower's name", length: 1...50)
            guard
                let borrower: Borrower = findBorrower(
                    borrower: borrowers, borrowerName: borrowerName)
            else {
                UI.errorPrint("No borrower found!")
                return
            }
            let bookName = getStringFromUser("Search for a book", length: 1...50)
            guard let book: Book = findBook(books: books, bookName: bookName) else {
                UI.errorPrint("No book found!")
                return
            }
            guard
                let loan = findLoan(
                    loans: loans, borrower: borrower, book: book),
                let index = loans.firstIndex(where: { setLoan in loan.hashValue == setLoan.hashValue
                })
            else {
                UI.errorPrint("No active loan with that borrower and book foud!")
                return
            }

            deleteLoan(loans: &loans, index: index)
        case "l":
            listLoans(loans: loans)
            UI.pause()
        default:
            UI.infoPrint("Going back")
            return
        }

    }

    static func addLoan(loans: inout Set<Loan>, borrower: Borrower, book: Book) {
        if loans.contains(where: { loan in
            loan.book.hashValue == book.hashValue && !loan.returned
        }) {
            warnPrint("The book \"\(book.title)\" is already loaned out!")
            UI.pause()
            return
        }

        let returnDate: Date = getDateFromUser("When should the book be returned by? (dd/mm/yyyy)")

        print("Loaning out \(book.title) by \(book.author) to \(borrower.fullName)")

        guard getStringFromUser("[y]es/[N]o", length: 0...1).lowercased == "y" else {
            UI.infoPrint("Cancelled adding book")
            return
        }

        loans.formUnion([Loan(book: book, borrower: borrower, returnDate: returnDate)])
    }

    static func findLoan(loans: Set<Loan>, borrower: Borrower, book: Book) -> Loan? {
        let filteredLoans: Set<Loan> = loans.filter({ loan in
            loan.borrower == borrower && loan.book == book
        })

        guard filteredLoans.count > 0 else { return nil }
        if filteredLoans.count == 1 { return filteredLoans[filteredLoans.startIndex] }

        let sel: Int = getIntFromUser("Select a loan", range: 1...filteredLoans.count) - 1
        return filteredLoans[filteredLoans.index(filteredLoans.startIndex, offsetBy: sel)]
    }

    static func returnLoan(loans: inout Set<Loan>, index: Set<Loan>.Index) {

        var returnedLoan: Loan = loans[index]
        returnedLoan.returned = true

        guard
            getStringFromUser(
                "Has \(loans[index].book.title) been returned? [y]es/[N]o", length: 0...1
            ).lowercased == "y"
        else {
            UI.infoPrint("Cancelled returning loan")
            return
        }

        loans.remove(at: index)
        loans.formUnion([returnedLoan])

        // if let oldBorrowerIndex = borrowers.firstIndex(where: { borrower in
        //     borrower.hashValue == newBorrower.hashValue
        // }) {
        //     borrowers.remove(at: oldBorrowerIndex)
        //     borrowers.formUnion([newBorrower])
        // } else {
        //     UI.errorPrint("Could not find book to edit!")
        // }

    }

    static func deleteLoan(loans: inout Set<Loan>, index: Set<Loan>.Index) {
        let loan: Loan = loans[index]
        let book: Book = loans[index].book
        let borrower: Borrower = loans[index].borrower

        print(
            """
            \(book.title) by \(book.author) (ISBN: \(book.id))
            \(loan.returned ? "Currently" : "Previously") loaned to \(borrower)
            """)
        guard
            getStringFromUser(
                "Really delete this loan? [y]es/[N]o", length: 0...1
            ).lowercased == "y"
        else {
            UI.infoPrint("Cancelled deleting loan")
            return
        }

        loans.remove(at: index)
    }
}

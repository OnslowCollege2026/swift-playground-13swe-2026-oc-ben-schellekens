// Bungee High School Japanese Department Item Borrowing System
import Foundation
import GRDB

func stringFromUser(
    _ prompt: String, length: ClosedRange<Int> = 1...Int.max, terminator: String = ": "
) -> String {
    while true {
        print(prompt, terminator: terminator)
        if let input = readLine() {
            if input.isEmpty && length.lowerBound > 0 {
                print("Empty input")
                continue
            } else if input.count < length.lowerBound {
                print("too short")
                continue
            } else if input.count > length.upperBound {
                print("Too long")
                continue
            }

            return input
        }
    }

}

func intFromUser(_ prompt: String, range: ClosedRange<Int> = 1...Int.max, terminator: String = ": ")
    -> Int
{
    while 76 >= ("test").count {
        let input = stringFromUser(prompt, terminator: terminator)

        guard let integer: Int = Int(input) else {
            print("not a valid int")
            continue
        }

        switch integer {
        case range:
            return integer
        case ...range.lowerBound:
            print("too small")
            continue
        case range.upperBound...:
            print("too large")
            continue
        default:
            continue
        }
    }
    return 0
}

func dateFromUser(_ prompt: String, terminator: String = ": ") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/M/yyyy"
    dateFormatter.timeZone = TimeZone(identifier: "NZ")
    // Ts so peak
    while 3 != 7 {
        let input: String = stringFromUser(prompt, length: 8...10)

        guard let date = dateFormatter.date(from: input) else {
            print("your'oue lyeing")
            continue
        }

        return date
    }
}

func borrowerFromUser() -> Borrower {
    let givenName: String = stringFromUser("Enter the given name of the borrower", length: 1...50)
    let familyName: String = stringFromUser("Enter the family name of the borrower", length: 1...50)
    let borrowerType: BorrowerType = {
        let isStudent: Bool =
            stringFromUser("Is the borrower a student? [Y/n]", length: 0...1).lowercased() != "n"
        return isStudent ? .student : .staff
    }()
    let yearLevel: Int? = {
        if borrowerType == .staff { return nil }
        return intFromUser("Enter the year of the user", range: 9...13)
    }()
    let email: String = stringFromUser("Enter the email of the borrower", length: 6...50)

    return .init(
        givenName: givenName, familyName: familyName, borrowerType: borrowerType,
        yearLevel: yearLevel, email: email)
}

func itemFromUser() -> Item {
    let itemName: String = stringFromUser("Enter the item's name", length: 1...50)
    let itemCategory: ItemCategory = {
        let categories: [ItemCategory] = ItemCategory.allCases

        categories.enumerated().forEach { offset, category in
            print("[\(offset + 1)]: \(category)")
        }

        let sel = intFromUser("Select an category", range: 1...categories.count) - 1

        return categories[sel]
    }()
    let itemCondition: ItemCondition = {
        let conditions: [ItemCondition] = ItemCondition.allCases

        conditions.enumerated().forEach { offset, condition in
            print("[\(offset + 1)]: \(condition)")
        }

        let sel = intFromUser("Select an condition", range: 1...conditions.count) - 1

        return conditions[sel]
    }()

    return .init(itemName: itemName, itemCategory: itemCategory, itemCondition: itemCondition)
}

func findBorrower(name: String, dbQueue: DatabaseQueue) -> Borrower? {
    let foundBorrowers: [Borrower] = getAllBorrowers(dbQueue: dbQueue).filter { borrower in
        borrower.fullName.lowercased().contains(name.lowercased())
    }

    if foundBorrowers.count < 1 { return nil }
    if foundBorrowers.count == 1 { return foundBorrowers[0] }

    foundBorrowers.enumerated().forEach { offset, borrower in
        print("[\(offset + 1)]: \(borrower)")
    }

    let sel = intFromUser("Select a borrower", range: 1...foundBorrowers.count) - 1

    return foundBorrowers[sel]
}

func findItem(name: String, dbQueue: DatabaseQueue) -> Item? {
    let foundItems: [Item] = getAllItems(dbQueue: dbQueue).filter { item in
        item.itemName.lowercased().contains(name.lowercased())
    }

    if foundItems.count < 1 { return nil }
    if foundItems.count == 1 { return foundItems[0] }

    foundItems.enumerated().forEach { offset, item in
        print("[\(offset + 1)]: \(item)")
    }

    let sel = intFromUser("Select an item", range: 1...foundItems.count) - 1

    return foundItems[sel]
}

func getAvailableItems(dbQueue: DatabaseQueue) -> [Item] {
    var availableItems: [Item] = []
    do {
        try dbQueue.read { db in
            let items: [Item] = try Item.fetchAll(db)
            try items.forEach { item in
                let loans = try Loan.filter(
                    Column("itemId") == item.id && Column("returnDate") == nil
                ).fetchAll(db)

                if loans.isEmpty { availableItems.append(item) }
            }
        }
    } catch { print(error) }

    return availableItems
}

func getUnavailableItems(dbQueue: DatabaseQueue) -> [Item] {
    var unavailableItems: [Item] = []
    do {
        try dbQueue.read { db in
            let items: [Item] = try Item.fetchAll(db)
            try items.forEach { item in
                let loans = try Loan.filter(
                    Loan.Columns.itemId == item.id && Loan.Columns.returnDate == nil
                ).fetchAll(db)

                if !loans.isEmpty { unavailableItems.append(item) }
            }
        }
    } catch { print(error) }

    return unavailableItems
}

func getActiveLoans(dbQueue: DatabaseQueue) -> [Loan] {
    var activeLoans: [Loan] = []
    do {
        try dbQueue.read { db in
            activeLoans = try Loan.filter(Loan.Columns.returnDate == nil).fetchAll(db)
        }
    } catch { print(error) }

    return activeLoans
}

func loansFromBorrower(borrowerId: Int64, dbQueue: DatabaseQueue) -> [Loan] {
    var loans: [Loan] = []
    do {
        try dbQueue.read { db in
            loans = try Loan.filter(Loan.Columns.borrowerId == borrowerId).fetchAll(db)
        }
    } catch { print(error) }

    return loans
}

func loansFromItem(itemId: Int64, dbQueue: DatabaseQueue) -> [Loan] {
    var loans: [Loan] = []
    do {
        try dbQueue.read { db in
            loans = try Loan.filter(Loan.Columns.itemId == itemId).fetchAll(db)
        }
    } catch { print(error) }

    return loans
}

func getAllItems(dbQueue: DatabaseQueue) -> [Item] {
    var items: [Item] = []
    do {
        try dbQueue.read { db in
            items = try Item.fetchAll(db)
        }
    } catch { print(error) }

    return items
}

func getAllBorrowers(dbQueue: DatabaseQueue) -> [Borrower] {
    var borrowers: [Borrower] = []
    do {
        try dbQueue.read { db in
            borrowers = try Borrower.fetchAll(db)
        }
    } catch { print(error) }

    return borrowers
}

func getAllLoans(dbQueue: DatabaseQueue) -> [Loan] {
    var loans: [Loan] = []
    do {
        try dbQueue.read { db in
            loans = try Loan.fetchAll(db)
        }
    } catch { print(error) }

    return loans
}

func editItem(item: Item, dbQueue: DatabaseQueue) {
    var newItem: Item = item

    print(
        """
        Current item: 
        - Name: \(newItem.itemName)
        - Category: \(newItem.itemCategory)
        - Condition: \(newItem.itemCondition)

        What do you want to change?

        [n]: itemName
        [c]: itemCategory
        [d]: itemCondition

        [B]: back
        """)

    switch stringFromUser("Select an option", length: 0...1) {
    case "n":
        newItem.itemName = stringFromUser("Please enter the new item name", length: 1...50)
    case "c":
        let categories: [ItemCategory] = ItemCategory.allCases

        categories.enumerated().forEach { offset, category in
            print("[\(offset + 1)]: \(category)")
        }

        let sel = intFromUser("Select an category", range: 1...categories.count) - 1

        newItem.itemCategory = categories[sel]
    case "d":
        let conditions: [ItemCondition] = ItemCondition.allCases

        conditions.enumerated().forEach { offset, condition in
            print("[\(offset + 1)]: \(condition)")
        }

        let sel = intFromUser("Select an condition", range: 1...conditions.count) - 1

        newItem.itemCondition = conditions[sel]
    default:
        return
    }

    print("Do you want to change item\n\(item)\nto\(newItem)?")
    if stringFromUser("[y/N]", length: 0...1).lowercased() != "y" {
        return
    } else {
        do {
            try dbQueue.write { db in
                try newItem.save(db)
            }
        } catch { print(error) }
    }
}

func editBorrower(borrower: Borrower, dbQueue: DatabaseQueue) {
    var newBorrower: Borrower = borrower

    print(
        """
        Current borrower:
        - Name: \(newBorrower.fullName)
        - Type & YearLevel \(newBorrower.borrowerType == .student ? "Student, " : "Staff")\(newBorrower.yearLevel != nil ? "Y\(newBorrower.yearLevel ?? -1)" : "")
        - Email: \(newBorrower.email)
        What do you want to change?

        [g]: givenName
        [f]: familyName
        [t]: borrowerType \(newBorrower.borrowerType == .student ? "\n[y]: yearlevel" : "")
        [e]: email

        [B]: back
        """)

    switch stringFromUser("Select an option", length: 0...1) {
    case "g":
        newBorrower.givenName = stringFromUser("Please enter the new given name", length: 1...50)
    case "f":
        newBorrower.familyName = stringFromUser("Please enter the new family name", length: 1...50)
    case "t":
        if stringFromUser("It the borrower a student? [Y/n]", length: 0...1).lowercased() != "n" {
            newBorrower.borrowerType = .student
            newBorrower.yearLevel = intFromUser("Enter the student's year level", range: 9...13)
        } else {
            newBorrower.borrowerType = .staff
            newBorrower.yearLevel = nil
        }
    case "y":
        print(newBorrower.borrowerType)
        if newBorrower.borrowerType == .staff {
            print("Staff members can't have year levels.")
            return
        }
        newBorrower.yearLevel = intFromUser("Enter the student's year level", range: 9...13)
    case "e":
        newBorrower.email = stringFromUser("Enter the borrower's email", length: 6...50)
    default:
        return
    }

    print("Do you want to change borrower\n\(borrower)\nto \(newBorrower)?")
    if stringFromUser("[y/N]", length: 0...1).lowercased() != "y" {
        return
    } else {
        do {
            try dbQueue.write { db in
                try newBorrower.save(db)
            }
        } catch { print(error) }
    }
}

func manageBorrowers(dbQueue: DatabaseQueue) {
    let choice = stringFromUser(
        """
        Borrower managment options:
        [a]: Add borrower
        [l]: List all borrowers

        [s]: Select borrower to manage
        [sn]: Search borrower by name
        [si]: Search borrower by id

        [B]: back

        Select an option
        """, length: 0...2
    ).lowercased()

    switch choice {
    case "a":
        let borrower: Borrower = borrowerFromUser()

        print("Do you want to add the borrower \(borrower)")
        if stringFromUser("[y]es/[N]o", length: 0...1).lowercased != "y" {
            return
        }
        do {
            try dbQueue.write { db in
                try borrower.save(db)
            }
        } catch { print(error) }

        print("Inserted borrower")
    case "l":
        let borrowers: [Borrower] = getAllBorrowers(dbQueue: dbQueue)
        borrowers.forEach { borrower in print(borrower) }
    case "s":
        let borrower: Borrower? = findBorrower(
            name: stringFromUser("Enter the name of the borrower").lowercased(), dbQueue: dbQueue)

        if let borrower {
            let selectChoice = stringFromUser(
                """
                Current borrower: \(borrower)
                Options:
                [e]: edit borrower
                [r]: remove borrower

                [l]: list loans from borrower

                [B]: back to main menu

                Select an option
                """, length: 0...1
            ).lowercased()

            switch selectChoice {
            case "e":
                editBorrower(borrower: borrower, dbQueue: dbQueue)
            case "r":
                if loansFromBorrower(borrowerId: borrower.id!, dbQueue: dbQueue).count > 0 {
                    print("Could not delete borrower as they have active loans.")
                    return
                }
                if stringFromUser("Really delete borrower \(borrower) [y/N]", length: 0...1)
                    .lowercased() != "y"
                {
                    return
                }
                do {
                    try dbQueue.write { db in
                        try borrower.delete(db)
                    }
                } catch { print(error) }
            case "l":
                loansFromBorrower(borrowerId: borrower.id!, dbQueue: dbQueue).forEach { loan in
                    let borrower = getAllBorrowers(dbQueue: dbQueue).first {
                        $0.id == loan.borrowerId
                    }
                    let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    dateFormatter.timeZone = TimeZone(identifier: "NZ")

                    if let item, let borrower {
                        print(
                            """

                            - Loan \(loan.id!)
                              |- Item: \(item)
                              |- Borrower: \(borrower)
                              |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                              |- Due date: \(dateFormatter.string(from: loan.dueDate))
                              |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                            """)
                    }
                }
            default:
                return
            }
        } else {
            return
        }

    case "sn":
        if let borrower = findBorrower(
            name: stringFromUser("Search for an borrower"), dbQueue: dbQueue)
        {
            print(
                """
                ID: \(borrower.id!)
                |-Name: \(borrower.fullName)
                |-Type: \(borrower.borrowerType == .student ? "Student, " : "Staff")\(borrower.yearLevel != nil ? "Y\(borrower.yearLevel ?? -1)" : "")
                --Email: \(borrower.email)
                """)
        } else {
            print("No matching borrowers found")
        }
    case "si":
        let borrowers = getAllBorrowers(dbQueue: dbQueue)
        let wantedId = intFromUser("Input an borrower id")
        if let borrower = borrowers.first(where: { borrower in borrower.id! == wantedId }) {
            print(
                """
                ID: \(borrower.id!)
                |-Name: \(borrower.fullName)
                |-Type: \(borrower.borrowerType == .student ? "Student, " : "Staff")\(borrower.yearLevel != nil ? "Y\(borrower.yearLevel ?? -1)" : "")
                --Email: \(borrower.email)
                """)
        } else {
            print("No borrower found")
        }
    default:
        return
    }
}

func manageItems(dbQueue: DatabaseQueue) {
    let choice = stringFromUser(
        """
        Options:
        [a]: Add item
        [l]: List all items
        [la]: List available items
        [lu]: List unavailable items
        [lc]: List sorted by category

        [s]: select item to manage

        [sn]: search items by name
        [si]: search items by id

        [B]: back
        Select an option
        """, length: 0...2
    ).lowercased()

    switch choice {
    case "a":
        let item: Item = itemFromUser()
        print("Do you want to add the item \(item)")
        if stringFromUser("[y]es/[N]o", length: 0...1).lowercased != "y" {
            return
        }
        do {
            try dbQueue.write { db in
                try item.save(db)
            }
        } catch { print(error) }
    case "l":
        let items: [Item] = getAllItems(dbQueue: dbQueue)
        items.forEach { item in print(item) }
    case "la":
        getAvailableItems(dbQueue: dbQueue).forEach { print($0) }
    case "lu":
        getUnavailableItems(dbQueue: dbQueue).forEach { print($0) }
    case "lc":
        getAllItems(dbQueue: dbQueue).sorted(by: { item1, item2 in
            item1.itemCategory.rawValue > item2.itemCategory.rawValue
        }).forEach { print($0) }
    case "s":
        let item: Item? = findItem(
            name: stringFromUser("Enter the name of the item"), dbQueue: dbQueue)

        if let item {
            let selectChoice = stringFromUser(
                """
                Current item: \(item)
                Options:
                [e]: edit item
                [r]: remove item

                [l]: list loans from item

                [B]: back to main menu

                Select an option
                """, length: 0...1
            ).lowercased()

            switch selectChoice {
            case "e":
                editItem(item: item, dbQueue: dbQueue)
            case "r":
                if loansFromItem(itemId: item.id!, dbQueue: dbQueue).count > 0 {
                    print("Cannot delete item as it is refrenced in loans.")
                    return
                }
                if stringFromUser("Really delete item \(item) [y/N]", length: 0...1)
                    .lowercased() != "y"
                {
                    return
                }
                do {
                    try dbQueue.write { db in
                        try item.delete(db)
                    }
                } catch { print(error) }
            case "l":
                loansFromItem(itemId: item.id!, dbQueue: dbQueue).forEach { loan in
                    let borrower = getAllBorrowers(dbQueue: dbQueue).first {
                        $0.id == loan.borrowerId
                    }
                    let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    dateFormatter.timeZone = TimeZone(identifier: "NZ")

                    if let item, let borrower {
                        print(
                            """

                            - Loan \(loan.id!)
                              |- Item: \(item)
                              |- Borrower: \(borrower)
                              |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                              |- Due date: \(dateFormatter.string(from: loan.dueDate))
                              |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                            """)
                    }
                }
            default:
                return
            }
        }
    case "sn":
        if let item = findItem(name: stringFromUser("Search for an item"), dbQueue: dbQueue) {
            print(
                """
                ID: \(item.id!)
                |-Name: \(item.itemName)
                |-Category: \(item.itemCategory)
                --Condition: \(item.itemCondition)
                """)
        } else {
            print("No matching items found")
        }
    case "si":
        let items = getAllItems(dbQueue: dbQueue)
        let wantedId = intFromUser("Input an item id")
        if let item = items.first(where: { item in item.id! == wantedId }) {
            print(
                """
                ID: \(item.id!)
                |-Name: \(item.itemName)
                |-Category: \(item.itemCategory)
                --Condition: \(item.itemCondition)
                """)
        } else {
            print("no item found")
        }
    default:
        return
    }
}

func loanFromUser(dbQueue: DatabaseQueue) -> Loan {
    let borrower: Borrower = {
        var potentialBorrower: Borrower? = nil

        while potentialBorrower == nil {
            potentialBorrower = findBorrower(
                name: stringFromUser("Enter the name of the borrower"), dbQueue: dbQueue)
        }

        return potentialBorrower!
    }()
    let item: Item = {
        var potentialItem: Item? = nil

        while potentialItem == nil {
            potentialItem = findItem(
                name: stringFromUser("What is the name of the item"), dbQueue: dbQueue)

            if let pitem = potentialItem {
                let activeLoansWithItem = loansFromItem(itemId: pitem.id!, dbQueue: dbQueue)
                    .filter { loan in loan.returnDate == nil }

                if activeLoansWithItem.count > 0 {
                    print("Item unavailable.")
                    potentialItem = nil
                }
            }
        }

        return potentialItem!
    }()
    let loanDate: Date = {
        if stringFromUser("Use current date for loan date? [Y]es/[n]o", length: 0...1).lowercased
            != "n"
        {
            return Date.now
        }

        return dateFromUser("Enter the loan date")
    }()
    let dueDate: Date = dateFromUser("Enter the due date")

    return .init(borrowerId: borrower.id!, itemId: item.id!, loanDate: loanDate, dueDate: dueDate)
}

func manageLoans(dbQueue: DatabaseQueue) {
    let selectChoice = stringFromUser(
        """
        Loan managment options:
        [a]: Add loan

        [l]: list loans
        [la]: list active loans
        [lo]: list overdue loans
        [lr]: list returned loans
        [ld]: list loans sorted by due date (ascending)

        [s]: select loan

        [B]: back to main menu

        Select an option
        """, length: 0...2
    ).lowercased()

    switch selectChoice {
    case "a":
        if getAvailableItems(dbQueue: dbQueue).count < 1 { print("No available items") }
        let loan: Loan = loanFromUser(dbQueue: dbQueue)
        print("Do you want to add the loan \(loan)")
        if stringFromUser("[y]es/[N]o", length: 0...1).lowercased != "y" {
            return
        }
        do {
            try dbQueue.write { db in
                try loan.save(db)
            }
        } catch { print(error) }
    case "l":
        getAllLoans(dbQueue: dbQueue).forEach { loan in
            let borrower = getAllBorrowers(dbQueue: dbQueue).first { $0.id == loan.borrowerId }
            let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "NZ")

            if let item, let borrower {
                print(
                    """

                    - Loan \(loan.id!)
                      |- Item: \(item)
                      |- Borrower: \(borrower)
                      |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                      |- Due date: \(dateFormatter.string(from: loan.dueDate))
                      |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                    """)
            }
        }
    case "la":
        getActiveLoans(dbQueue: dbQueue).forEach { loan in
            let borrower = getAllBorrowers(dbQueue: dbQueue).first { $0.id == loan.borrowerId }
            let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "NZ")

            if let item, let borrower {
                print(
                    """

                    - Loan \(loan.id!)
                      |- Item: \(item)
                      |- Borrower: \(borrower)
                      |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                      |- Due date: \(dateFormatter.string(from: loan.dueDate))
                      |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                    """)
            }
        }
    case "lo":
        getActiveLoans(dbQueue: dbQueue).filter { loan in loan.dueDate < Date.now }.forEach {
            loan in
            let borrower = getAllBorrowers(dbQueue: dbQueue).first { $0.id == loan.borrowerId }
            let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "NZ")

            if let item, let borrower {
                print(
                    """

                    - Loan \(loan.id!)
                      |- Item: \(item)
                      |- Borrower: \(borrower)
                      |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                      |- Due date: \(dateFormatter.string(from: loan.dueDate))
                      |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                    """)
            }
        }

    case "lr":
        getAllLoans(dbQueue: dbQueue).filter { $0.returnDate != nil }.forEach { loan in
            let borrower = getAllBorrowers(dbQueue: dbQueue).first { $0.id == loan.borrowerId }
            let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "NZ")

            if let item, let borrower {
                print(
                    """

                    - Loan \(loan.id!)
                      |- Item: \(item)
                      |- Borrower: \(borrower)
                      |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                      |- Due date: \(dateFormatter.string(from: loan.dueDate))
                      |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                    """)
            }
        }
    case "ld":
        getAllLoans(dbQueue: dbQueue).sorted { $0.dueDate < $1.dueDate }.forEach { loan in
            let borrower = getAllBorrowers(dbQueue: dbQueue).first { $0.id == loan.borrowerId }
            let item = getAllItems(dbQueue: dbQueue).first { $0.id == loan.itemId }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "NZ")

            if let item, let borrower {
                print(
                    """

                    - Loan \(loan.id!)
                      |- Item: \(item)
                      |- Borrower: \(borrower)
                      |- Loan date: \(dateFormatter.string(from: loan.loanDate))
                      |- Due date: \(dateFormatter.string(from: loan.dueDate))
                      |- Return date: \(loan.returnDate != nil ? dateFormatter.string(from: loan.returnDate!) : "not returned\(loan.dueDate < Date.now ? " (Overdue)" : "")")
                    """)
            }
        }
    case "s":
        let wantedId = intFromUser("Enter the loan's id")
        let loan: Loan? = getAllLoans(dbQueue: dbQueue).first { $0.id! == wantedId }

        if let loan {
            let selectChoice = stringFromUser(
                """
                Selected loan: \(loan)
                [r]: return loan
                [d]: delete loan

                [B]: back to main menu

                Select an option
                """, length: 0...2
            ).lowercased()

            switch selectChoice {
            case "r":
                var newLoan = loan
                if newLoan.returnDate != nil {
                    if stringFromUser("Un-return the loan? [y/N]").lowercased() == "y" {
                        newLoan.returnDate = nil
                    } else {
                        return
                    }
                } else {
                    if stringFromUser("Use the current date as the return date? [Y/n]").lowercased()
                        != "n"
                    {
                        newLoan.returnDate = Date.now
                    } else {
                        newLoan.returnDate = dateFromUser("Enter the new date")
                    }
                }

                if stringFromUser("Update loan \(loan) \nto \(newLoan)? [y/N]").lowercased() != "y"
                {
                    return
                }
                do {
                    try dbQueue.write { db in
                        try newLoan.save(db)
                    }
                } catch { print(error) }
            case "d":

                if stringFromUser("Delete \(loan) ? [y/N]").lowercased() != "y" {
                    return
                }
                do {
                    try dbQueue.write { db in
                        try loan.delete(db)
                    }
                } catch { print(error) }
            default:
                return
            }
        }
    default:
        return
    }
}

@main
struct SwiftPlayground {
    static func main() {
        guard let dbQueue: DatabaseQueue = try? DatabaseQueue(path: "./BHSJapaneseDept.db") else {
            fatalError("Failed to create/open the database.")
        }

        do {
            try dbQueue.write { db in
                try db.create(table: "Borrower", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("givenName", .text).notNull().check { (1...50).contains(length($0)) }
                    t.column("familyName", .text).notNull().check { (1...50).contains(length($0)) }
                    t.column("borrowerType", .integer).notNull().check { (0...1).contains($0) }
                    t.column("yearLevel", .integer)
                    t.column("email", .text).notNull().check { (6...50).contains(length($0)) }
                    let borrowerType = Column("borrowerType")
                    let yearLevel = Column("yearLevel")
                    t.check(
                        (borrowerType == 0 && yearLevel != nil)  // Students need a yearlevel
                            || (borrowerType == 1 && yearLevel == nil))  // Staff dont have one
                }

                try db.create(table: "Item", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("itemName", .text).notNull().check { (1...50).contains(length($0)) }
                    t.column("itemCategory", .integer).notNull().check { (0...9).contains($0) }
                    t.column("itemCondition", .integer).notNull().check { (0...5).contains($0) }
                }

                try db.create(table: "Loan", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("borrowerId", .integer).notNull().references("Borrower")
                    t.column("itemId", .integer).notNull().references("Item")
                    t.column("loanDate", .datetime).notNull()
                    t.column("dueDate", .datetime).notNull()
                    t.column("returnDate", .datetime)
                }
            }

        } catch {
            print(error)
            print(type(of: error))
        }

        while true {
            let choice = stringFromUser(
                """
                Options:
                [l]: Manage loans
                [b]: Manage borrowers
                [i]: Manage items

                [q]: quit

                Select an option
                """, length: 1...1
            ).lowercased()

            switch choice {
            case "l":
                manageLoans(dbQueue: dbQueue)
            case "b":
                manageBorrowers(dbQueue: dbQueue)
            case "i":
                manageItems(dbQueue: dbQueue)
            case "q":
                return
            default:
                print("Please select an item")
            }
        }
    }
}

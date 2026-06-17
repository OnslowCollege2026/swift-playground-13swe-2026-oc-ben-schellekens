// Bungee High School Japanese Department Item Borrowing System
import Foundation
import GRDB

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
                    t.column("givenName", .text).notNull().check { (0...50).contains(length($0)) }
                    t.column("familyName", .text).notNull().check { (0...50).contains(length($0)) }
                    t.column("borrowerType", .integer).notNull()
                    t.column("yearLevel", .integer)
                    t.column("email", .text).notNull()
                }

                try db.create(table: "Item", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("itemName", .text).notNull().check { (0...50).contains(length($0)) }
                    t.column("itemCategory", .integer).notNull()
                    t.column("itemCondition", .integer).notNull()
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
    }
}

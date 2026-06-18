// Bungee High School Japanese Department Item Borrowing System
import Foundation
import GRDB

enum BorrowerType: Int, Codable {
    case staff
    case student
}

enum ItemCategory: Int, Codable {
    case textbooks
    case manga
    case readers
    case flashcardSets
    case culturalResources
    case games
    case electronicGames
}

enum ItemCondition: Int, Codable {
    case terrible
    case poor
    case fair
    case good
    case excellent
}

struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64? = nil
    var givenName: String
    var familyName: String
    var borrowerType: BorrowerType
    var yearLevel: Int?
    var email: String

    // enum CodingKeys: String, CodingKey { 
    //     var id: Int64? = nil
    //     var givenName: String
    //     var familyName: String
    //     var borrowerType: BorrowerType
    //     var yearLevel: Int?
    //     var email: String
    // }

    enum Columns { 
        static let id = Column(CodingKeys.id)
        static let givenName = Column(CodingKeys.givenName)
        static let familyName = Column(CodingKeys.familyName)
        static let borrowerType = Column(CodingKeys.borrowerType)
        static let yearLevel = Column(CodingKeys.yearLevel)
        static let email = Column(CodingKeys.email)
    }
}

struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64? = nil
    var itemName: String
    var itemCategory: ItemCategory
    var itemCondition: ItemCondition

    // enum CodingKeys: String, CodingKey {
    //     var id: Int64? = nil
    //     var itemName: String
    //     var itemCategory: ItemCategory
    //     var itemCondition: ItemCondition
    // }

    enum Columns { 
        static let id = Column(CodingKeys.id)
        static let itemName = Column(CodingKeys.itemName)
        static let itemCategory = Column(CodingKeys.itemCategory)
        static let itemCondition = Column(CodingKeys.itemCondition)
    }
}

struct Loan: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64? = nil
    var borrowerId: Int64
    var itemId: Int64
    var loanDate: Date
    var dueDate: Date
    var returnDate: Date?

    // enum CodingKeys: String, CodingKey {
    //     var id: Int64? = nil
    //     var borrowerId: Int64
    //     var itemId: Int64
    //     var loanDate: Date
    //     var dueDate: Date
    //     var returnDate: Date? 
    // }

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let borrowerId = Column(CodingKeys.borrowerId)
        static let itemId = Column(CodingKeys.itemId)
        static let loanDate = Column(CodingKeys.loanDate)
        static let dueDate = Column(CodingKeys.dueDate)
        static let returnDate = Column(CodingKeys.returnDate)
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
                    t.column("givenName", .text).notNull().check { (0...50).contains(length($0)) }
                    t.column("familyName", .text).notNull().check { (0...50).contains(length($0)) }
                    t.column("borrowerType", .integer).notNull().check { (0...1).contains($0)}
                    t.column("yearLevel", .integer)
                    t.column("email", .text).notNull()
                }

                try db.create(table: "Item", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("itemName", .text).notNull().check { (0...50).contains(length($0)) }
                    t.column("itemCategory", .integer).notNull().check { (0...7).contains($0) }
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

            try dbQueue.read { db in try db.dumpSchema() }
        } catch {
            print(error)
            print(type(of: error))
        }
    }
}

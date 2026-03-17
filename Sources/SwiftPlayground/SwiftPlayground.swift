// The Swift Programming Language
// https://docs.swift.org/swift-book
import GRDB

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "./cafe.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Could not open database.")
        }

        let purchaserID: Int = 2
        let purchaserName: String = "Dylan Jenkins"

        do {
            try dbQueue.read { db in
                let purchaser = try Purchaser.fetchOne(db, key: purchaserID)
                if let purchaser {
                    print("Found purchaser: \(purchaser.name)")
                } else {
                    print("No purchaser with id \(purchaserID)")
                }

                let purchaserFromName = try Purchaser.filter(
                    Purchaser.Columns.Name == purchaserName
                ).fetchOne(db)

                if let purchaserFromName {
                    print("\( purchaserFromName.name ) is with \(purchaserFromName.count) people")
                } else {
                    print("No purchaser named \(purchaserName)")
                }

                // let manyPurchasers = try Purchaser.filter()
            }

        } catch {}
    }
}

struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64
    var name: String
    var count: Int
    var reservedTable: String

    enum CodingKeys: String, CodingKey {
        case id = "PurchaserID"
        case name = "Name"
        case count = "Count"
        case reservedTable = "ReservedTable"
    }

    enum Columns {
        static let Name = Column("Name")
        static let Count = Column("Count")
        static let ReservedTable = Column("ReservedTable")
    }
}

struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64
    var name: String
    var price: Double

    enum CodingKeys: String, CodingKey {
        case id = "ItemID"
        case name = "Name"
        case price = "Price"
    }

    enum Columns {
        static let Name = Column("Name")
        static let Price = Column("Price")
    }
}

struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64
    var purchaserID: Int64
    var amount: Double

    enum CodingKeys: String, CodingKey {
        case id = "OrderID"
        case purchaserID = "PurchaserID"
        case amount = "Amount"
    }

    enum Columns {
        static let PurchaserID = Column("PurchaserID")
        static let Amount = Column("Amount")
    }
}

struct OrderLine: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64
    var itemID: Int64
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case id = "OrderID"
        case itemID = "PurchaserID"
        case quantity = "Quantity"
    }

    enum Columns {
        static let ItemID = Column("ItemID")
        static let Quantity = Column("Quantity")
    }
}

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
        do {
            try dbQueue.read { db in
                let schema = try db.dumpSchema()
                print(schema)
            }
        } catch {}
    }
}

struct Purchaser: Codable, FetchableRecord, PersistableRecord {
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
}

struct Item: Codable, FetchableRecord, PersistableRecord {
    var itemID: Int64
    var name: String
    var price: Double

    enum CodingKeys: String, CodingKey {
        case itemID = "ItemID"
        case name = "Name"
        case price = "Price"
    }
}

struct Order: Codable, FetchableRecord, PersistableRecord {
    var orderID: Int64
    var purchaserID: Int64
    var amount: Double

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case purchaserID = "PurchaserID"
        case amount = "Amount"
    }
}

struct OrderLine: Codable, FetchableRecord, PersistableRecord {
    var orderID: Int64
    var itemID: Int64
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case itemID = "PurchaserID"
        case quantity = "Quantity"
    }
}

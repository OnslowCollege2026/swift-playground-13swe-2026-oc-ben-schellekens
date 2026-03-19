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

        // code to dump schema
        // do { try dbQueue.read { db in try db.dumpSchema() } } catch {}
        var orderLines: [OrderLine] = []
        var total: Double = 0.0
        var item: Item?

        do {
            try dbQueue.read { db in
                // if let purchaser = try Purchaser.fetchOne(db, key: 1) {
                //     print(purchaser)
                // }
                //
                // if let noPurchaser = try Purchaser.fetchOne(db, key: Int64.max) {
                //     print(noPurchaser)
                // } else {
                //     print("no purchaser with id \(Int64.max)")
                // }
                //
                // if let item = try Item.fetchOne(db, id: 1) { print(item) }

                if let order = try Order.fetchOne(db, id: 2),
                    let purchaser = try Purchaser.fetchOne(db, id: order.purchaserID)
                {
                    print("Order #\(order.id) for \(purchaser.name) --- $\(order.amount)")

                    orderLines = try OrderLine.filter(
                        OrderLine.Columns.OrderID == order.id
                    ).fetchAll(db)

                    print(orderLines)

                    try orderLines.forEach { line in

                        var orderString = ""

                        if let item = try Item.fetchOne(db, id: line.itemID) {
                            let subtotal = item.price * Double(line.quantity)
                            total += subtotal
                            orderString += "\(item)"
                            orderString += " Subtotal: $\(subtotal)"
                        }
                        print(orderString)
                    }
                    item = try Item.fetchOne(db, id: orderLines[0].itemID)
                }
            }

            try dbQueue.write { db in
                if let item {
                    let newQuantity = 5
                    orderLines[0].quantity = newQuantity

                    let currentSubtotal = item.price * Double(orderLines[0].quantity)
                }
            }
        } catch { print(error) }

    }
}

struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible
{
    static let databaseTableName: String = "Purchaser"

    /// The purchaser's ID.
    var id: Int64
    /// The name of the customer
    var name: String
    /// The amount of people that are with the customer
    var count: Int
    /// The table that the customer has reserved
    var reservedTable: String?

    var description: String {
        "(Purchaser #\(id)) \(name) has reserved \(reservedTable ?? "") for a party of \(count)"
    }

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

struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    static let databaseTableName: String = "Item"

    /// The ID of the item
    var id: Int64
    /// The name of the item
    var name: String
    /// How much the item costs
    var price: Double

    var description: String {
        "(Item #\(id)) \(name) --- $\(price)"
    }

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
    static let databaseTableName: String = "Order"

    /// The order ID.
    var id: Int64
    /// The id of the person who purchaser
    var purchaserID: Int64
    /// The cost of the order
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

struct OrderLine: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "OrderLine"

    /// The id of the order that the line belongs to.
    var orderID: Int64
    /// The id of the item that the line refers to.
    var itemID: Int64
    /// The amount of the item in the order.
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case orderID = "OrderID"
        case itemID = "ItemID"
        case quantity = "Quantity"
    }

    enum Columns {
        static let OrderID = Column("OrderID")
        static let ItemID = Column("ItemID")
        static let Quantity = Column("Quantity")
    }
}

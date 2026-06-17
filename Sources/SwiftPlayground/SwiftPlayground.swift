// Database testing
import Foundation
import GRDB

enum SeatClass: Int, Codable {
    case Economy
    case Business
    case First
}

struct Customer: Codable, Identifiable, FetchableRecord, PersistableRecord, CustomStringConvertible
{
    var id: Int64? = nil
    var givenName: String
    var familyName: String
    var homePhone: String
    var address: String
    var region: String
    var country: String
    var city: String
    var email: String

    var description: String {
        """
        \(id != nil ? "User \(id ?? -1)" : "New user")
        Name: \(givenName) \(familyName)
        Home Phone: \(homePhone)
        Address: \(address)
        City: \(city)
        Region: \(region)
        Country: \(country)
        Email: \(email)
        """
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case givenName = "given_name"
        case familyName = "family_name"
        case homePhone = "home_phone"
        case address = "address"
        case region = "region"
        case country = "country"
        case city = "city"
        case email = "email"
    }

    enum Columns {
        static let id = Column("id")
        static let givenName = Column("given_name")
        static let familyName = Column("family_name")
        static let homePhone = Column("home_phone")
        static let address = Column("address")
        static let region = Column("region")
        static let country = Column("country")
        static let city = Column("city")
        static let email = Column("email")
    }
}

struct Location: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: String
    var name: String
    var address: String

    enum CodingKeys: String, CodingKey {
        case id = "airport_code"
        case name = "name"
        case address = "address"
    }

    enum Columns {
        static let id = Column("airport_code")
        static let name = Column("name")
        static let address = Column("address")
    }
}

struct Staff: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: Int? = nil
    var givenName: String
    var familyName: String
    var workPhone: String
    var mobilePhone: String
    var email: String
    var airportCode: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case givenName = "given_name"
        case familyName = "family_name"
        case workPhone = "work_phone"
        case mobilePhone = "mobile_phone"
        case email = "email"
        case airportCode = "airport_code"
    }

    enum Columns {
        static let id = Column("id")
        static let givenName = Column("given_name")
        static let familyName = Column("family_name")
        static let workPhone = Column("work_phone")
        static let mobilePhone = Column("mobile_phone")
        static let email = Column("email")
        static let airportCode = Column("airport_code")
    }
}

struct Plane: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: Int? = nil
    var model: String
    var minRunwayLength: Double
    var maxWeight: Double
    var capacity: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case model = "model"
        case minRunwayLength = "min_runway_length"
        case maxWeight = "max_weight"
        case capacity = "capacity"
    }


    enum Columns {
        static let id = Column("id")
        static let model = Column("model")
        static let minRunwayLength = Column("min_runway_length")
        static let maxWeight = Column("max_weight")
        static let capacity = Column("capacity")
    }
}

struct Flight: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: Int? = nil
    var planeId: Int
    var departureTime: Date
    var departureLocation: String
    var arrivalTime: Date
    var arrivalLocation: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case planeId = "plane_id"
        case departureTime = "departure_time"
        case departureLocation = "departure_location"
        case arrivalTime = "arrival_time"
        case arrivalLocation = "arrival_location"
    }

    enum Columns {
        static let id = Column("id")
        static let planeId = Column("plane_id")
        static let departureTime = Column("departure_time")
        static let departureLocation = Column("departure_location")
        static let arrivalTime = Column("arrival_time")
        static let arrivalLocation = Column("arrival_location")
    }
}

struct Seat: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: Int? = nil
    var planeId: Int
    var seatClass: SeatClass
    var emergency: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case planeId = "plane_id"
        case seatClass = "seat_class"
        case emergency = "emergency"
    }
}

struct Booking: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: Int? = nil
    var customerId: Int
    var staffId: Int
    var flightId: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case customerId = "customer_id"
        case staffId = "staff_id"
        case flightId = "flight_id"
    }
}

struct Passenger: Codable, FetchableRecord, PersistableRecord {
    var seatID: Int
    var bookingID: Int
    var adult: Bool

    enum CodingKeys: String, CodingKey {
        case seatID = "seat_id"
        case bookingID = "booking_id"
        case adult = "adult"
    }
}

@main
struct SwiftPlayground {
    static func main() {
        guard let dbQueue = try? DatabaseQueue(path: "./AirBungee.db") else {
            fatalError("womp womp the database is fucking broken")
        }

        do {
            try dbQueue.write { db in
                try db.create(table: "customer", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("given_name", .text).notNull().check { length($0) > 0 }
                    t.column("family_name", .text).notNull().check { length($0) > 0 }
                    t.column("home_phone", .text)
                    t.column("work_phone", .text)
                    t.column("mobile_phone", .text)
                    t.column("address", .text).notNull()
                    t.column("region", .text).notNull()
                    t.column("city", .text).notNull()
                    t.column("country", .text).notNull()
                    t.column("email", .text).notNull()
                }

                try db.create(table: "location", ifNotExists: true) { t in
                    t.column("airport_code", .text).primaryKey()
                    t.column("name", .text).notNull().check { length($0) > 0 }
                    t.column("address", .text).notNull().check { length($0) > 0 }
                }

                try db.create(table: "staff", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("given_name", .text).notNull()
                    t.column("family_name", .text).notNull()
                    t.column("work_phone", .text).notNull()
                    t.column("mobile_phone", .text).notNull()
                    t.column("email", .text).notNull()
                    t.column("airport_code", .text).notNull().references("location")
                }

                try db.create(table: "plane", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("model", .text).notNull()
                    t.column("min_runway_length", .real).notNull()
                    t.column("max_weight", .real).notNull()
                    t.column("capacity", .integer).notNull()
                }

                try db.create(table: "flight", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("plane_id", .text).notNull().references("plane")
                    t.column("departure_time", .datetime).notNull()
                    t.column("departure_location", .text).notNull().references("location")
                    t.column("arrival_time", .datetime).notNull()
                    t.column("arrival_location", .text).notNull().references("location")
                }

                try db.create(table: "seat", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("plane_id", .integer).notNull().references("plane")
                    t.column("class", .boolean).notNull()
                    t.column("emergency", .boolean).notNull().defaults(to: 0)
                }

                try db.create(table: "booking", ifNotExists: true) { t in
                    t.column("id", .integer).primaryKey(autoincrement: true)
                    t.column("customer_id", .integer).notNull().references("customer")
                    t.column("staff_id", .integer).notNull().references("staff")
                    t.column("flight_id", .integer).notNull().references("flight")
                }

                try db.create(table: "passenger", ifNotExists: true) { t in
                    t.column("seat_id", .integer).notNull().references("seat")
                    t.column("booking_id", .integer).notNull().references("booking")
                    t.column("adult", .boolean).notNull().defaults(to: true)
                }

            }

            try dbQueue.read { db in
                let customer = try Customer.filter(Customer.Columns.givenName == "").fetchOne(db)
                if let customer {
                    print("Found customer: \(customer)")
                } else {
                    print("Could not find customer")
                }

            }

        } catch {
            print(error)
        }
    }
}

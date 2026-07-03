import Foundation
import GRDB

enum BorrowerType: Int, Codable {
    case student
    case staff
}

enum ItemCategory: Int, Codable, CaseIterable {
    case textbook
    case manga
    case reader
    case flashcardSet
    case culturalResource
    case game
    case electronicGame
    case movie
    case novel
}

enum ItemCondition: Int, Codable, CaseIterable {
    case terrible
    case poor
    case fair
    case good
    case excellent
}

struct Borrower: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible
{
    var id: Int64? = nil
    var givenName: String
    var familyName: String
    var borrowerType: BorrowerType
    var yearLevel: Int?
    var email: String

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let givenName = Column(CodingKeys.givenName)
        static let familyName = Column(CodingKeys.familyName)
        static let borrowerType = Column(CodingKeys.borrowerType)
        static let yearLevel = Column(CodingKeys.yearLevel)
        static let email = Column(CodingKeys.email)
    }

    var fullName: String { "\(givenName) \(familyName)" }

    var description: String {
        "ID: \(id != nil ? String(id ?? -1) : "not inserted") | \(fullName) (\(borrowerType == .student ? "Student, " : "Staff")\(yearLevel != nil ? "Y\(yearLevel ?? -1)" : "")) Email: \(email)"
    }
}

struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    var id: Int64? = nil
    var itemName: String
    var itemCategory: ItemCategory
    var itemCondition: ItemCondition

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let itemName = Column(CodingKeys.itemName)
        static let itemCategory = Column(CodingKeys.itemCategory)
        static let itemCondition = Column(CodingKeys.itemCondition)
    }

    var description: String {
        "ID: \(id != nil ? String(id ?? -1) : "not inserted") | \(itemName) (\(itemCategory)) \(itemCondition) condition"
    }
}

struct Loan: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    var id: Int64? = nil
    var borrowerId: Int64
    var itemId: Int64
    var loanDate: Date
    var dueDate: Date
    var returnDate: Date?

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let borrowerId = Column(CodingKeys.borrowerId)
        static let itemId = Column(CodingKeys.itemId)
        static let loanDate = Column(CodingKeys.loanDate)
        static let dueDate = Column(CodingKeys.dueDate)
        static let returnDate = Column(CodingKeys.returnDate)
    }

    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "NZ")
        return "ID: \(id != nil ? String(id ?? -1) : "not inserted") | Item \(itemId) loaned to borrower \(borrowerId) on \(dateFormatter.string(from: loanDate)). Due back \(dateFormatter.string(from: dueDate)), \(returnDate != nil ? "Returned \(dateFormatter.string(from: returnDate!))": "Not returned")"
    }
}

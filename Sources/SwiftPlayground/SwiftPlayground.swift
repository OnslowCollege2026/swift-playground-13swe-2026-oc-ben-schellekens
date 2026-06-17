// Bungee High School Japanese Department Item Borrowing System
import Foundation
import GRDB

@main
struct SwiftPlayground {
    static func main() {
        guard let dbQueue: DatabaseQueue = try? DatabaseQueue(path: "./BHSJapaneseDept.db") else {
            fatalError("Failed to create/open the database.")
        }
    }
}

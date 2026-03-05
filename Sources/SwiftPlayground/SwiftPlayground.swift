// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct SwiftPlayground {
    static func main() {
        let receipts: [Receipt] = rentals.map { rental in
            let videoWithID: Video =
                videos.first { $0.id == rental.videoID }
                ?? Video(id: UUID(), title: "", dailyRate: 0)
            return Receipt(
                videoID: rental.videoID, customerID: rental.customerID,
                pricePaid: videoWithID.dailyRate * Double(rental.dayToReturn - rental.dayIssued),
                overdueFeeCharged: rental.wasReturned
            )

        }

        receipts.forEach { receipt in
            let video: Video =         
                videos.first { $0.id == receipt.videoID }
                ?? Video(id: UUID(), title: "", dailyRate: 0)
            let customer: Customer =         
                customers.first { $0.id == receipt.customerID }
                ?? Customer(id: UUID(), name: "", address: "")
            print("Receipt | Customer: \(customer.name) | Video: \(video.title) | Base: $\(String(format: "%.2f",  receipt.pricePaid)) | Overdue: \(receipt.overdueFeeCharged ? "Yes" : "No")")
        }
    }
}

struct Video: Identifiable {
    let id: UUID
    let title: String
    let dailyRate: Double
}

struct Customer: Identifiable {
    let id: UUID
    let name: String
    let address: String
}

struct VideoRental {
    let videoID: Video.ID
    let customerID: Customer.ID
    let dayIssued: Int
    let dayToReturn: Int
    let wasReturned: Bool
}

struct Receipt {
    let videoID: Video.ID
    let customerID: Customer.ID
    let pricePaid: Double
    let overdueFeeCharged: Bool
}

let videos: [Video] = [
    Video(id: UUID(), title: "The Matrix", dailyRate: 4.50),
    Video(id: UUID(), title: "Toy Story", dailyRate: 3.00),
    Video(id: UUID(), title: "Spirited Away", dailyRate: 4.00),
    Video(id: UUID(), title: "Interstellar", dailyRate: 5.00),
    Video(id: UUID(), title: "Moana", dailyRate: 3.50)
]

let customers: [Customer] = [
    Customer(id: UUID(), name: "Aroha Ngata", address: "14 Kowhai Street"),
    Customer(id: UUID(), name: "Liam Patel", address: "8 Tui Avenue"),
    Customer(id: UUID(), name: "Mia Thompson", address: "22 Rimu Road"),
    Customer(id: UUID(), name: "Noah Wiremu", address: "3 Pukeko Lane"),
    Customer(id: UUID(), name: "Eva Chen", address: "11 Nikau Place")
]

let rentals: [VideoRental] = [
    VideoRental(videoID: videos[0].id,
                customerID: customers[0].id,
                dayIssued: 1, dayToReturn: 3,
                wasReturned: true),
    VideoRental(videoID: videos[1].id,
                customerID: customers[1].id,
                dayIssued: 2, dayToReturn: 4,
                wasReturned: false),
    VideoRental(videoID: videos[2].id,
                customerID: customers[2].id,
                dayIssued: 2, dayToReturn: 5,
                wasReturned: true),
    VideoRental(videoID: videos[3].id,
                customerID: customers[3].id,
                dayIssued: 3, dayToReturn: 6,
                wasReturned: false),
    VideoRental(videoID: videos[4].id,
                customerID: customers[4].id,
                dayIssued: 4, dayToReturn: 6,
                wasReturned: true)
]

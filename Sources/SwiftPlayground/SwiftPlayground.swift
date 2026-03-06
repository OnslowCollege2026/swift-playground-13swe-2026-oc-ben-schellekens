// Written by Ben schellekens
// 06-03-2025

import Foundation

@main
struct SwiftPlayground {
    static func main() {
        // Task 1 part 1:

        // Map video rentals into receipts:
        let receipts: [Receipt] = rentals.map { rental in
            // Create a new receipts
            return Receipt(
                // Video             Customer
                video: rental.video, customer: rental.customer,
                // Price paid for the video
                pricePaid: (rental.video.dailyRate * Double(rental.dayToReturn - rental.dayIssued))
                    + overdueFee,
                // Whether the overdue fee should be charged
                overdueFeeCharged: rental.wasReturned
            )

        }

        // For each receipt
        receipts.forEach { receipt in
            // Print information in format
            print(
                "Receipt | Customer: \(receipt.customer.name) | Video: \(receipt.video.title) | Base: $\(String(format: "%.2f",  receipt.pricePaid)) | Overdue: \(receipt.overdueFeeCharged ? "Yes" : "No")"
            )
        }

        // Filter for only overdue receipts
        let overdueRecepits: [Receipt] = receipts.filter { $0.overdueFeeCharged }
        // Print out a message for each receipt
        overdueRecepits.forEach { receipt in
            print(
                "Overdue notice sent to: \( receipt.customer.name ), \( receipt.customer.address )")
        }

        let totalOverdueFees: Double = overdueRecepits.reduce(0) { total, _ in total + overdueFee }
        print("Total overdue fees collected: $\(String(format: "%.2f", totalOverdueFees))")

        let bills: [CustomerBill] = overdueRecepits.map {
            CustomerBill(customer: $0.customer, receipt: $0)
        }

        bills.sorted().reversed().forEach { bill in
            print(
                "Customer \"\(bill.customer.name)\" had a fee of $\(bill.receipt.pricePaid)"
            )
        }

        print(bills[0].description)
    }
}

let overdueFee: Double = 2.00

struct Video: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let dailyRate: Double
}

struct Customer: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let address: String
}

struct VideoRental: Hashable, Codable {
    let video: Video
    let customer: Customer
    let dayIssued: Int
    let dayToReturn: Int
    let wasReturned: Bool
}

struct Receipt: Hashable, Codable {
    let video: Video
    let customer: Customer
    let pricePaid: Double
    let overdueFeeCharged: Bool
}

struct CustomerBill: CustomStringConvertible, Equatable, Comparable, Hashable, Codable {
    let customer: Customer
    let receipt: Receipt

    var description: String {
        """
        Kia ora \(customer.name),

        Our records show that "\(receipt.video.title)" was overdue.
        Base rental paid: $\(String(format: "%.2f", receipt.pricePaid))
        Overdue fee now due: $\(overdueFee)

        Please pay this amount at your earliest convenience.
        Store Billing Team
        """
    }

    static func == (lhs: CustomerBill, rhs: CustomerBill) -> Bool {
        lhs.receipt.pricePaid == rhs.receipt.pricePaid
    }

    static func < (lhs: CustomerBill, rhs: CustomerBill) -> Bool {
        lhs.receipt.pricePaid < rhs.receipt.pricePaid
    }
}

let videos: [Video] = [
    Video(id: UUID(), title: "The Matrix", dailyRate: 4.50),
    Video(id: UUID(), title: "Toy Story", dailyRate: 3.00),
    Video(id: UUID(), title: "Spirited Away", dailyRate: 4.00),
    Video(id: UUID(), title: "Interstellar", dailyRate: 5.00),
    Video(id: UUID(), title: "Moana", dailyRate: 3.50),
]

let customers: [Customer] = [
    Customer(id: UUID(), name: "Aroha Ngata", address: "14 Kowhai Street"),
    Customer(id: UUID(), name: "Liam Patel", address: "8 Tui Avenue"),
    Customer(id: UUID(), name: "Mia Thompson", address: "22 Rimu Road"),
    Customer(id: UUID(), name: "Noah Wiremu", address: "3 Pukeko Lane"),
    Customer(id: UUID(), name: "Eva Chen", address: "11 Nikau Place"),
]

let rentals: [VideoRental] = [
    VideoRental(
        video: videos[0],
        customer: customers[0],
        dayIssued: 1, dayToReturn: 3,
        wasReturned: true),
    VideoRental(
        video: videos[1],
        customer: customers[1],
        dayIssued: 2, dayToReturn: 4,
        wasReturned: false),
    VideoRental(
        video: videos[2],
        customer: customers[2],
        dayIssued: 2, dayToReturn: 5,
        wasReturned: true),
    VideoRental(
        video: videos[3],
        customer: customers[3],
        dayIssued: 3, dayToReturn: 6,
        wasReturned: false),
    VideoRental(
        video: videos[4],
        customer: customers[4],
        dayIssued: 4, dayToReturn: 6,
        wasReturned: true),
]

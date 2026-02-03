// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        // Constants
        let lunches: [Double] = [6.50, 8.00, 5.75, 9.20, 7.10]
        let budget: Double = 37.00
        let snackCost: Double = 2.50

        var snackTotal: Double = 0

        print("Your budget: $\(budget)\n")

        // Enumerate through the days
        lunches.enumerated().forEach {(day, cost) in
            // Print the lunch cost for the day
            print("Day \(day + 1) cost: $\(cost)")
            // Show if the day is high spending day
            if cost > 9.00 {
                print("High spending day detected!")
            }
        }

        while snackTotal < 10.00 {
            snackTotal += snackCost
        }

        // Extra newline for formatting
        print()
        print("Total cost: \(totalCosts(lunches))")

        // Check if the user is over budget and print the corresponding string
        print(isOverBudget(total: totalCosts(lunches), budget: budget) ? 
        "Warning: You are over budget!" : "You are under budget")

    }
}


/// Function to give the total cost of the lunches
/// - Parameter prices: A list of the lunch prices for each day
/// - Returns: The total of all of the lunch prices
func totalCosts(_ prices: [Double]) -> Double {
    var total: Double = 0
    for price in prices {
        total += price
    }
    return total
}

/// Checks if the student is over budget
/// - Parameters:
///   - total: The total price of all the lunches for the week
///   - budget: The student's budget
/// - Returns: If the total is greater than the budgets
func isOverBudget(total: Double, budget: Double) -> Bool {
    return total > budget
}

/// Function to get the average cost of prices over the week
/// - Parameter prices: The prices of all the lunches
/// - Returns: The average cost of the lunches over the week
func averageCost(_ prices: [Double]) -> Double {
    let total = totalCosts(prices)
    return total / Double(prices.count)
}
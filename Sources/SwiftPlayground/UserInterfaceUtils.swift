// Utilities for user interface creation
import Foundation

/// Gets Input from the user and validates it against some critera
/// - Parameters:
///   - prompt: The Prompt to show the user.
///   - min: the minimum length of the string, 0 allows for empty strings. (default: 1)
///   - max: the maximum length of the string. (default: 9223372036854775807)
///   - terminator: What to end the prompt with (default: ": ")
///
/// - Returns: A string with a length between min and max
func getStringFromUser(
    _ prompt: String, length: ClosedRange<Int> = 1...Int.max, terminator: String = ": "
) -> String {
    while true {
        print(prompt, terminator: terminator)
        if let input = readLine() {
            if input.isEmpty && length.lowerBound > 0 {
                UI.warnPrint("Input invalid (empty string submitted), please try again")
                continue
            } else if input.count < length.lowerBound {
                UI.warnPrint(
                    "Input length is less than the minimum (\(length.lowerBound) character(s))")
                continue
            } else if input.count > length.upperBound {
                UI.warnPrint(
                    "Input length is more than the maximum (\(length.upperBound) character(s))")
                continue
            }

            return input
        }

    }
}

/// Gets an integer from the user and makes sure it is in a specific range
/// - Parameters:
///   - prompt: The Prompt to show the user.
///   - range: The range in which the number should be in
///   - terminator: What to end the prompt with (default: ": ")
///
/// - Returns: A string with a length between min and max
func getIntFromUser(
    _ prompt: String, range: ClosedRange<Int> = 1...Int.max, terminator: String = ": "
) -> Int {
    while true {
        let input = getStringFromUser(prompt, terminator: terminator)

        guard let integer: Int = Int(input) else {
            UI.errorPrint("Not a valid integer.")
            continue
        }

        switch integer {
        case range:
            return integer
        case ...range.lowerBound:
            UI.warnPrint("Number too small, please try again (Minimum: \(range.lowerBound))")
            continue
        case range.upperBound...:
            UI.warnPrint("Number too large, please try again (Maximum: \(range.upperBound))")
            continue
        default:
            print("test")
        }
    }
    return 0
}

/// Struct to help with the creation of user interfaces
struct UI {

    // Printing prefixes
    /// Prefix for printing error messages
    static let errorPrefix: String = "\u{001b}[1;31mError:\u{001b}[0m"
    /// Prefix for printing warning messages
    static let warnPrefix: String = "\u{001b}[1;31mWarning:\u{001b}[0m"
    /// Prefix for printing info messages
    static let infoPrefix: String = "\u{001b}[1;31mInfo:\u{001b}[0m"

    /// Formats a date into a string
    /// - Parameter date: The date to format
    /// - Returns: date properly formatted into a string
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(abbreviation: "NZDT")

        return formatter.string(from: date)
    }

    /// Prints message as an error
    /// - Parameter message: The message to output
    static func errorPrint(_ message: String) { print("\(errorPrefix) \(message)") }
    /// Prints message as an warning
    /// - Parameter message: The message to output
    static func warnPrint(_ message: String) { print("\(warnPrefix) \(message)") }
    /// Prints message as an info message
    /// - Parameter message: The message to output
    static func infoPrint(_ message: String) { print("\(infoPrefix) \(message)") }

    static func showOverdueLoans(loans: Set<Loan>) {
        let overdueLoans = loans.filter { loan in
            loan.isOverdue
        }

        if overdueLoans.count < 1 { UI.infoPrint("No overdue loans!") }

        overdueLoans.forEach({ loan in
            print(loan)
        })
    }

}

// Intro to object oriented programming.

@main
struct SwiftPlayground {
    static func main() {
        // Value for students task
        let students: [Student] = [
            Student(
                ID: 29, NSN: 1, name: "Gregory Gregenheimer", age: 99,
                email: "gregory.gregenheimer@greg.net"),
            Student(
                ID: 888888, NSN: 233, name: "Frederick Fringlegrotten", age: 77,
                email: "Fred.fring@fring-carpeting.org"),
            Student(ID: 30, NSN: Int.max, name: "John johnson", age: 21, email: "john@johnson.com"),
            Student(
                ID: Int.min, NSN: Int.min, name: "Int min", age: Int.min, email: "int.min@swift.org"
            ),
            Student(ID: 30, NSN: 30, name: "thirty", age: 30, email: "thirty@numbers.org"),
        ]

        // Student
        let ben: Student = Student(
            ID: 50,
            NSN: 50,
            name: "Google Man",
            age: 17,
            email: "google.man@real-school.edu"
        )

        // Get the age of the students in 10 years and format it as a string    
        let studentsAgeIn10Years: [String] = students.map {
            return "\($0.name) will be \($0.age + 10) in 10 years"
        }

        // Print out last two tasks
        studentsAgeIn10Years.forEach { print($0) }
        print(ben.summary())

        // Data for the race garage task
        let cars: [Car] = [
            Car(brand: "CarCompany", model: "CarModel", year: 2330),
            Car(brand: "Greg industries", model: "Long car", year: 5),
        ]

        for car in cars {
            // Print the cars sentence
            print(car.sentence())

            // Get values from dot syntax
            print("Model: \(car.model), Company: \(car.brand), Year: \(car.year)")
        }

        // Data for mini banking model task
        let accounts: [BankAccount] = [
            BankAccount(owner: "TestOwner", balance: Double.greatestFiniteMagnitude),
            BankAccount(owner: "John john", balance: 1.0 / 3.0),
        ]

        // Print the description of every bank account
        accounts.forEach { print($0.description()) }

        // Data for area checker task
        let rects: [Rectangle] = [
            Rectangle(width: 5, height: 5),
            Rectangle(width: 2, height: 44.32),
        ]

        // Print the area for each rectangle (with the rectangle number as well)
        rects.enumerated().forEach { print("Rectangle \($0.offset + 1) area:  \($0.element.area())") }
        
        // Get the largest rectangle or return a rectangle with no size
        let largestRectangle: Rectangle = rects.max {$0.area() < $1.area()} ?? Rectangle(width: 0, height: 0)
        print("Largest rectangle: \(largestRectangle.area())")

        // Data for quest board task
        let questBoard: [Quest] = [
            Quest(title: "Video game", difficulty: Difficulty.easy, reward: 29),
            Quest(title: "Make 64 iron pickaxes", difficulty: Difficulty.medium, reward: 93),
            Quest(title: "Funny quest", difficulty: Difficulty.hard, reward: -Double.greatestFiniteMagnitude)
        ]

        // Print the badges for each of the quests
        questBoard.forEach {print($0.badge)}

        // Get the hardest quest
        let hardestQuest: Quest = questBoard.max {
            $0.difficulty.rawValue > $1.difficulty.rawValue 
        } ?? Quest(title: "Quest that appears when the function fails", difficulty: .easy, reward: -Double.greatestFiniteMagnitude)

        // Print the hardest quest
        print("Hardest quest: \(hardestQuest.badge)")
    }
}

// Enum for the difficulty of the quests
enum Difficulty: Int {
    case easy = 0
    case medium = 1
    case hard = 2
}

// Struct for a student
struct Student {
    let ID: Int
    let NSN: Int

    var name: String
    var age: Int
    var email: String

    /// Gets the summary of the student
    /// - Returns: The summar of the student including all of the provided values
    func summary() -> String {
        return """
            --- \(name) ---
            ID:     \(ID)
            NSN:    \(NSN)
            Name:   \(name)
            Age:    \(age)
            Email:  \(email)
            ---------------
            """
    }
}

/// Struct for a car
struct Car {
    let brand: String
    let model: String
    let year: Int

    func sentence() -> String {
        return "This car is a \(model) by \(brand) from \(year)"
    }
}

struct BankAccount {
    var owner: String
    var balance: Double

    func description() -> String {
        return "\(owner) has $\(balance)"
    }
}

struct Rectangle {
    var width: Double
    var height: Double

    func area() -> Double {
        return width * height
    }
}

struct Quest {
    let title: String
    let difficulty: Difficulty
    let reward: Double

    var badge: String {
        "\(title) - \(difficulty) Quest - \(reward) XP "
    }
}

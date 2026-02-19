// Intro to object oriented programming.

@main
struct SwiftPlayground {
    static func main() {
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

        let ben: Student = Student(
            ID: 50,
            NSN: 50,
            name: "Google Man",
            age: 17,
            email: "google.man@real-school.edu"
        )

        let studentsAgeIn10Years: [String] = students.map {
            print($0.summary())
            return "\($0.name) will be \($0.age + 10) in 10 years"
        }

        print(studentsAgeIn10Years)

        print(ben.summary())

        let cars: [Car] = [
            Car(brand: "CarCompany", model: "CarModel", year: 2330),
            Car(brand: "Greg industries", model: "Long car", year: 5),
        ]

        for car in cars {
            print(car.sentence())

            print("Model: \(car.model), Company: \(car.brand), Year: \(car.year)")
        }

        let accounts: [BankAccount] = [
            BankAccount(owner: "TestOwner", balance: Double.greatestFiniteMagnitude),
            BankAccount(owner: "John john", balance: 1.0 / 3.0),
        ]

        accounts.forEach { print($0.description()) }

        let rects: [Rectangle] = [
            Rectangle(width: 5, height: 5),
            Rectangle(width: 2, height: 44.32),
        ]

        rects.enumerated().forEach { print("Rectangle \($0.offset + 1) area:  \($0.element.area())") }
        
        let largestRectangle: Rectangle = rects.max {$0.area() < $1.area()} ?? Rectangle(width: 0, height: 0)
        print("Largest rectangle: \(largestRectangle.area())")
    }
}

struct Student {
    let ID: Int
    let NSN: Int

    var name: String
    var age: Int
    var email: String

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

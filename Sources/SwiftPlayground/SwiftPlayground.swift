// Intro to object oriented programming.

@main
struct SwiftPlayground {
    static func main() {
        let students: [Student] = [
            Student(ID: 29, NSN: 1, name: "Gregory Gregenheimer", age: 99, email: "gregory.gregenheimer@greg.net"),
            Student(ID: 888888, NSN: 233, name: "Frederick Fringlegrotten", age: 77, email: "Fred.fring@fring-carpeting.org"),
            Student(ID: 30, NSN: Int.max, name: "John johnson", age: 21, email: "john@johnson.com"),
            Student(ID: Int.min, NSN: Int.min, name: "Int min", age: Int.min, email: "int.min@swift.org"),
            Student(ID: 30, NSN: 30, name: "thirty", age: 30, email: "thirty@numbers.org")
        ]

        let ben = Student(
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
// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct SwiftPlayground {
    static func main() {
        let testStudent: Student = Student(id: UUID(), name: "Test", age: 10)
        let course: Course = Course(
            id: "SWD13", title: "Software De-engineering",
            courseDescription: "Learn how to break torins code")

        var testEnrolment: Enrolment = Enrolment(studentID: testStudent.id, courseID: course.id)

        let data = try! JSONEncoder().encode(testEnrolment)
        let decoded = try! JSONDecoder().decode(Enrolment.self, from: data)

        let scores: [ScoreEntry] = [
            ScoreEntry(studentID: testStudent.id, points: 3),
            ScoreEntry(studentID: testStudent.id, points: 4),
            ScoreEntry(studentID: testStudent.id, points: 11),
        ]

        print(scores.sorted { $0 > $1 })

        print(data)
        print(decoded)

    }
}

struct Student: Identifiable {
    let id: UUID
    var name: String
    var age: Int
}

struct Course: CustomStringConvertible {
    let id: String
    var title: String
    var courseDescription: String

    var description: String {
        """
        --- \(title) ---
        Course ID: \(id)
        \(courseDescription)
        """
    }
}

struct Enrolment: Codable {
    let studentID: UUID
    let courseID: String
}

struct ScoreEntry: Comparable {
    let studentID: UUID
    var points: Int

    static func < (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool {
        lhs.points < rhs.points
    }
}

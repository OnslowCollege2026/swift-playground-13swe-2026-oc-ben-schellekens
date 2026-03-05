// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct SwiftPlayground {
    static func main() {
        let testStudent: Student = Student(id: UUID(), name: "Test", age: 10)
        let otherTestStudent: Student = Student(id: UUID(), name: "String", age: Int.max)
        let testCourse: Course = Course(
            id: "SWD13", title: "Software De-engineering",
            courseDescription: "Learn how to break torins code"
        )
        let courses: [Course] = [
            Course(
                id: "SMC13", title: "Selling miniature campfires",
                courseDescription: "learn how to sell miniature campfires"),
            Course(id: "TST12", title: "Tesintehs", courseDescription: "Screaming emoji"),
            Course(id: "LZY11", title: "Lazy", courseDescription: "thats what i am"),
        ]

        let testEnrolment: Enrolment = Enrolment(studentID: testStudent.id, courseID: testCourse.id)

        let data: Data?
        let decoded: Enrolment?
        do { data = try JSONEncoder().encode(testEnrolment) } catch { data = nil }

        do {
            guard data != nil else {
                decoded = nil
                return
            }
            decoded = try JSONDecoder().decode(Enrolment.self, from: data!)
        } catch { decoded = nil }

        let scores: [ScoreEntry] = [
            ScoreEntry(studentID: testStudent.id, points: 3),
            ScoreEntry(studentID: testStudent.id, points: 4),
            ScoreEntry(studentID: testStudent.id, points: 11),
        ]

        print(scores.sorted)

        print(data!)
        print(decoded!)

        print(decoded!.hashValue)

        let enrolments: Set<Enrolment> = [
            Enrolment(studentID: otherTestStudent.id, courseID: courses[0].id),
            Enrolment(studentID: testStudent.id, courseID: courses[0].id),
            Enrolment(studentID: testStudent.id, courseID: courses[1].id),
            Enrolment(studentID: testStudent.id, courseID: courses[1].id),
            Enrolment(studentID: otherTestStudent.id, courseID: courses[2].id),
        ]

        print(enrolments)
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

struct Enrolment: Codable, Hashable {
    let studentID: UUID
    let courseID: String
}

struct ScoreEntry: Comparable, Equatable {
    let studentID: UUID
    var points: Int

    static func < (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool { lhs.points < rhs.points }
    static func == (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool { lhs.points == rhs.points }
}

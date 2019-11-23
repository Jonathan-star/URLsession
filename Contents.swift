import Foundation

struct Person: Codable {
    let age: Int
    let firstName, lastName: String

    enum CodingKeys: String, CodingKey {
        case age
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

let session = URLSession.shared
let url = URL(string: "https://learnappmaking.com/ex/users.json")!

let task = session.dataTask(with: url) { data, response, error in

    if error != nil || data == nil {
        print("Client error!")
        return
    }

    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        print("Server error!")
        return
    }

    guard let type = response.mimeType, type == "application/json" else {
        print("Wrong MIME type!")
        return
    }

    do {
        let persons = try JSONDecoder().decode([Person].self, from: data!)
        for person in persons {
            print("age: ", person.age)
            print("first name: ", person.firstName)
            print("last name: ", person.lastName)
        }
    } catch {
        print("JSON error: \(error.localizedDescription)")
    }
}

task.resume()



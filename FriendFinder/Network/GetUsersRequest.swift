// See LICENSE.txt for licensing information

import Foundation

enum RequestError: Error {
    case missingData
    case wrongURL
}

struct GetUsersRequest {

    private let session: URLSessionProtocol
    private let urlString: String

    init(session: URLSessionProtocol = URLSession.shared,
         urlString: String = "https://jsonplaceholder.typicode.com/users") {
        self.session = session
        self.urlString = urlString
    }

    func execute(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(Result.failure(RequestError.wrongURL))
            return
        }

        let task = session.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                completion(Result.failure(RequestError.missingData))
                return
            }
            do {
                let users: [User] = try JSONDecoder().decode([User].self, from: data)
                completion(Result.success(users))
            } catch {
                completion(Result.failure(error))
            }
        }

        task.resume()
    }
}

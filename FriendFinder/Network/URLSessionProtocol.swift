// See LICENSE.txt for licensing information

import Foundation

protocol URLSessionProtocol {

    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let task: URLSessionDataTask = dataTask(with: url) { (data,response,error) in
            completionHandler(data, response, error)
        }
        return task
    }
}

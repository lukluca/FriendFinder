//
//  GetUsersRequestTests.swift
//  FriendFinder UnitTests
//
//  Created by Luca Tagliabue on 13/11/2020.
//

import XCTest
@testable import FriendFinder

class GetUsersRequestTests: XCTestCase {

    func testExecuteWithFailureIfNotValidUrlIsProvided() {
        let sut = makeSUT(urlString: "foo")

        let completionSpy = CompletionSpy<Result<[User], Error>>()
        sut.execute(completion: completionSpy.callable)

        XCTAssert(completionSpy.state == .called(withArgument: Result.failure(RequestError.wrongURL)))
    }

    func testExecuteMakesADataTaskIfAValidUrlIsProvided() {
        let sessionSpy = URLSessionSpy()
        let sut = makeSUT(session: sessionSpy, urlString: "https://www.foo.com")

        sut.execute { _ in }

        XCTAssertEqual(sessionSpy.dataTasksInvocations.count, 1)
    }

    func testExecuteCallsResumeOnDataTask() {
        let dataTaskSpy = URLSessionDataTaskSpy()
        let sessionStub = URLSessionStub(dataTask: dataTaskSpy)
        let sut = makeSUT(session: sessionStub, urlString: "https://www.foo.com")

        sut.execute { _ in }

        XCTAssertEqual(dataTaskSpy.resumeInvocationsCount, 1)
    }

    func testExecuteWithFailureIfNoDataAreProvided() {
        let sessionStub = URLSessionStub(data: nil)
        let sut = makeSUT(session: sessionStub)

        let completionSpy = CompletionSpy<Result<[User], Error>>()
        sut.execute(completion: completionSpy.callable)

        XCTAssert(completionSpy.state == .called(withArgument: Result.failure(RequestError.missingData)))
    }

    func testExecuteWithFailureIfWrongDataAreProvided() {
        let sessionStub = URLSessionStub(data: Data())
        let sut = makeSUT(session: sessionStub)

        let completionSpy = CompletionSpy<Result<[User], Error>>()
        sut.execute(completion: completionSpy.callable)

        XCTAssert(completionSpy.state == .called(withArgument: Result.failure(decodingError)))
    }

    func testExecuteWithSuccess() throws {
        let data = unwrap(correctJSON().data(using: .utf8))
        let sessionStub = URLSessionStub(data: data)
        let sut = makeSUT(session: sessionStub)

        let completionSpy = CompletionSpy<Result<[User], Error>>()
        sut.execute(completion: completionSpy.callable)

        let users = try JSONDecoder().decode([User].self, from: data)
        XCTAssert(completionSpy.state == .called(withArgument: Result.success(users)))
    }

    //MARK: Helper

    private func makeSUT(session: URLSessionProtocol = URLSessionDummy(), urlString: String = "https://www.foo.com") -> GetUsersRequest {
        GetUsersRequest(session: session, urlString: urlString)
    }

    private var decodingError: Error {
        DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: NSError(domain: NSCocoaErrorDomain, code: 3840, userInfo: ["NSDebugDescription": "No value."])))
    }

    private func correctJSON() -> String {
        "[{\"id\": 1,\"name\": \"Leanne Graham\",\"username\": \"Bret\",\"email\": \"Sincere@april.biz\",\"address\": {\"street\": \"Kulas Light\",\"suite\": \"Apt. 556\",\"city\": \"Gwenborough\",\"zipcode\": \"92998-3874\",\"geo\": {\"lat\": \"-37.3159\",\"lng\": \"81.1496\"}},\"phone\": \"1-770-736-8031 x56442\",\"website\": \"hildegard.org\",\"company\": {\"name\": \"Romaguera-Crona\",\"catchPhrase\": \"Multi-layered client-server neural-net\",\"bs\": \"harness real-time e-markets\"}}]"
    }
}

extension User: Equatable {
    public static func ==(lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.username == rhs.username &&
                lhs.email == rhs.email &&
                lhs.address == rhs.address &&
                lhs.phone == rhs.phone &&
                lhs.website == rhs.website &&
                lhs.company == rhs.company
    }
}

extension Address: Equatable {
    public static func ==(lhs: Address, rhs: Address) -> Bool {
        lhs.street == rhs.street &&
                lhs.suite == rhs.suite &&
                lhs.city == rhs.city &&
                lhs.zipcode == rhs.zipcode &&
                lhs.geo == rhs.geo
    }
}

extension Geo: Equatable {
    public static func ==(lhs: Geo, rhs: Geo) -> Bool {
        lhs.lat == rhs.lat &&
                lhs.lng == rhs.lng
    }
}

extension Company: Equatable {
    public static func ==(lhs: Company, rhs: Company) -> Bool {
        lhs.name == rhs.name &&
                lhs.catchPhrase == rhs.catchPhrase &&
                lhs.bs == rhs.bs
    }
}

private func ==<S: Equatable, F>(lhs: CompletionSpy<Result<S, F>>.State<Result<S, F>>, rhs: CompletionSpy<Result<S, F>>.State<Result<S, F>>) -> Bool {
    switch (lhs, rhs) {
    case (.called(withArgument: let lhsResult), .called(withArgument: let rhsResult)):
        switch (lhsResult, rhsResult) {
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
        case (.failure(let lhsError), .failure(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        default:
            return false
        }
    case (.notCalled, .notCalled):
        return true
    default:
        return true
    }
}

private class URLSessionDummy: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        URLSessionDataTaskDummy()
    }
}

private class URLSessionSpy: URLSessionProtocol {

    private(set) var dataTasksInvocations = [(url: URL, completionHandler: URLSessionProtocol.DataTaskResult)]()

    func dataTask(with url: URL, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        dataTasksInvocations.append((url, completionHandler))
        return URLSessionDataTaskDummy()
    }
}

private class URLSessionDataTaskDummy: URLSessionDataTaskProtocol {
    func resume() {}
}

private class URLSessionDataTaskSpy: URLSessionDataTaskProtocol {

    private(set) var resumeInvocationsCount = 0

    func resume() {
        resumeInvocationsCount += 1
    }
}

private class URLSessionStub: URLSessionProtocol {

    private let data: Data?
    private let dataTask: URLSessionDataTaskProtocol

    init(data: Data? =  nil, dataTask: URLSessionDataTaskProtocol = URLSessionDataTaskDummy()) {
        self.data = data
        self.dataTask = dataTask
    }

    func dataTask(with url: URL, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        completionHandler(data, nil, nil)
        return dataTask
    }
}

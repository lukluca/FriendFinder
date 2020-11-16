// See LICENSE.txt for licensing information

import XCTest

extension XCTestCase {
    func unwrap<T>(_ value: T?, file: StaticString = #file, line: UInt = #line) -> T {
        XCTAssertNotNil(value, file: file, line: line)
        return value!
    }
}
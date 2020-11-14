//
//  XCTestCase+Downgrade.swift
//  UITests
//
//  Created by Luca Tagliabue on 15/11/20.
//

import XCTest

extension XCTestCase {
    func cast<T, U>(_ value: T, file: StaticString = #file, line: UInt = #line) -> U {
        let casted = value as? U
        XCTAssertNotNil(casted, file: file, line: line)
        return casted!
    }
}

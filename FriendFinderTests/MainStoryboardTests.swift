//
//  FriendFinderTests.swift
//  FriendFinderTests
//
//  Created by Luca Tagliabue on 12/11/2020.
//

import XCTest
@testable import FriendFinder

class MainStoryboardTests: XCTestCase {

    func testHasFriendsTableViewControllerAsInitialViewController() {
        let initial = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? FriendsTableViewController
        XCTAssertNotNil(initial)
    }
}

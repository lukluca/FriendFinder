//
//  MainStoryboardTests.swift
//  FriendFinder UnitTests
//
//  Created by Luca Tagliabue on 12/11/2020.
//

import XCTest
@testable import FriendFinder

class MainStoryboardTests: XCTestCase {

    func testHasUINavigationControllerAsInitialViewControllerWithFriendsTableViewControllerAsFirstViewController() {
        let navigation: UINavigationController = cast(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController())
        let _: FriendsTableViewController = cast(navigation.viewControllers.first)
    }
}

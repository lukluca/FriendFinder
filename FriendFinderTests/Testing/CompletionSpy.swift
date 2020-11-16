//
//  CompletionSpy.swift
//  Testing
//
//  Created by Luca Tagliabue on 15/11/20.
//

import Foundation

class CompletionSpy<T> {

    enum State<T> {
        case notCalled
        case called(withArgument: T)
    }

    private(set) var state: State<T> = .notCalled

    var called: Bool {
        switch state {
        case .notCalled:
            return false
        default:
            return true
        }
    }

    func callable(_ arg: T) -> Void {
        state = .called(withArgument: arg)
    }
}

//
//  FatalError.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

/**
 Taken from https://medium.com/@marcosantadev/how-to-test-fatalerror-in-swift-e1be9ff11a29
 */
func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

struct FatalErrorUtil {

    // 1
    static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure

    // 2
    private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }

    // 3
    static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
        fatalErrorClosure = closure
    }

    // 4
    static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}

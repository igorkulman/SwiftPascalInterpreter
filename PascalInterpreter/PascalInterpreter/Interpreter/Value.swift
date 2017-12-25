//
//  Result.swift
//  SwiftPascalInterpreter
//
//  Created by Igor Kulman on 10/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

enum Value {
    case none
    case number(Number)
    case boolean(Bool)
    case string(String)
}

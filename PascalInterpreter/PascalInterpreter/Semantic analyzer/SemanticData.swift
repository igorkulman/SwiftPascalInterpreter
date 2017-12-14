//
//  SemanticData.swift
//  PascalInterpreter
//
//  Created by Igor Kulman on 13/12/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public struct SemanticData {
    let scopes: [String: ScopedSymbolTable]
    let procedures: [String: Procedure]
}

//
//  Token.swift
//  RuslanPivakSwift
//  Inspired by Ruslan Pivak: https://ruslanspivak.com/lsbasi-part1
//  Created by Julian Exenberger on 2017/01/14.
//  Copyright © 2017 Julian Exenberger. All rights reserved.
//

import Foundation

enum TokenType {
    case BEFORE, INTEGER, PLUS, MINUS, EOF, UNRECOGNISED
}

class Token: CustomStringConvertible {
    
    let type: TokenType
    let value: Any?
    
    public var description: String { return "Token:{\(type), \(value)}" }
    
    init(type:TokenType, value:Any?) {
        self.type = type
        self.value = value
    }
    
    
    
}

//
//  Util.swift
//  RuslanPivakSwift
//  Inspired by Ruslan Pivak: https://ruslanspivak.com/lsbasi-part1
//  Created by Julian Exenberger on 2017/01/21.
//  Copyright © 2017 Julian Exenberger. All rights reserved.
//

import Foundation

extension String {
    func char(at pos:Int) -> String? {
        if (self.characters.count <= pos) {
            return nil
        }
        return String(self[self.index(self.startIndex, offsetBy: pos)])
    }
    
    func peek(from pos:Int) -> String? {
        return char(at: pos+1)
    }
    
    func isWhiteSpace() -> Bool {
        return self == " " || self == "\t"
    }
}

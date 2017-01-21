//
//  main.swift
//  Inspired by Ruslan Pivak: https://ruslanspivak.com/lsbasi-part1
//  Created by Julian Exenberger on 2017/01/14.
//  Copyright © 2017 Julian Exenberger. All rights reserved.
//

import Foundation


repeat {
    guard let line = readLine(strippingNewline: true) else {
        break
    }
    let prog = Interpreter(text: line)
    let result = prog.expr()
    switch (result) {
    case .Success(let res):
        print(res)
    case .Error(let msg):
        print(msg)
    }
} while (0==0)


//
//  Interpreter.swift
//  RuslanPivakSwift
//  Inspired by Ruslan Pivak: https://ruslanspivak.com/lsbasi-part1
//  Created by Julian Exenberger on 2017/01/14.
//  Copyright © 2017 Julian Exenberger. All rights reserved.
//

import Foundation

enum Either<T, Err> {
    case Success(T)
    case Error(Err)
}


class Interpreter: Error {
    
    let text:String
    var pos:Int
    var currentToken:Token
    var currentChar:String?
    
    init(text:String) {
        self.text = text
        pos = 0
        currentToken = Token(.BEFORE, value: nil)
        self.currentChar = self.text.char(at: pos)
    }
    
    func advance() {
        pos += 1
        if pos >= text.characters.count {
            currentChar = nil
        } else {
            currentChar = text.char(at: pos)
        }
    }
    
    func skipWhitespace() {
        while (currentChar != nil && currentChar!.isWhiteSpace()) {
            advance()
        }
    }
    
    func term() -> Any?{
        let token = currentToken
        let _ = eat(type: .INTEGER)
        return token.value
    }
    
    func integer() -> Int {
        var buffer = ""
        while (currentChar != nil && Int(currentChar!) != nil) {
            buffer += currentChar!
            advance()
        }
        return Int(buffer)!
    }
    
    func getNextToken() -> Token {
        while currentChar != nil {
            if (currentChar!.isWhiteSpace()) {
                skipWhitespace()
            }
            if (Int(currentChar!) != nil) {
                return Token(.INTEGER, value: integer())
            }
            if (currentChar! == "+") {
                self.advance()
                return Token(.PLUS, value:nil)
            }
            if (currentChar! == "-") {
                self.advance()
                return Token(.MINUS, value:nil)
            }
            if (currentChar! == "*") {
                self.advance()
                return Token(.PLUS, value:nil)
            }
            if (currentChar! == "/") {
                self.advance()
                return Token(.MINUS, value:nil)
            }
            
        }
        return Token(.EOF, value:nil)
    }
    
    func eat(type:TokenType) -> Bool {
        if (currentToken.type == type)  {
            self.currentToken = getNextToken()
            return true
        }
        return false
    }
    
    func expr() -> Either<Any,String> {
        currentToken = getNextToken()
        var result = term()
        while (Token.arithmeticTokens().contains(currentToken.type)) {
            switch currentToken.type {
            case .PLUS:
                guard eat(type: .PLUS) else {
                    return .Error("Unexpected token \(currentToken.type)")
                }
                result = result as! Int + (term() as! Int)
            case .MINUS:
                guard eat(type: .MINUS) else {
                    return .Error("Unexpected token \(currentToken.type)")
                }
                result = result as! Int + (term() as! Int)
            default:
                return .Error("Unexpected token \(currentToken.type)")
            }
        }
        return .Success(result!)
    }
}

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
    
    init(text:String) {
        self.text = text
        pos = 0
        currentToken = Token(type: .BEFORE, value: nil)
    }
    
    func getToken(buffer:String) -> Token {
        switch (buffer) {
        case let iVal where Int(buffer) != nil:
            return Token(type: .INTEGER, value: Int(iVal))
        case let plus where plus == "+":
            return Token(type: .PLUS, value: plus)
        case let minus where minus == "-":
            return Token(type: .MINUS, value: minus)
        default:
            return Token(type: .UNRECOGNISED, value: nil)
        }
    }
    
    func getNextToken()  -> Token {
        /*
         Lexical analyser
         This method is responsible for breaking a sentence
         apart into tokens. One token at a time.
         */
        let workingText = self.text
        // is self.pos index past the end of the self.text ?
        // if so, then return EOF token because there is no more
        // input left to convert into tokens
        var extractedToken:Token?
        var buffer = ""
        var bufferComplete = false
        repeat {
            let currentChar =  workingText.char(at: self.pos)
            if (currentChar == nil) {
                if (!buffer.isEmpty) {
                    return getToken(buffer: buffer)
                } else {
                    return Token(type: .EOF, value: nil)
                }
            }
            let isWhitespace = currentChar?.isWhiteSpace()
            if (isWhitespace!) {
                bufferComplete = !buffer.isEmpty
            } else {
                buffer += currentChar!
            }
            if (bufferComplete) {
                extractedToken = getToken(buffer: buffer)
            }
            self.pos += 1
        } while extractedToken == nil
        return extractedToken!
    }
    
    func eat(tokenType:TokenType)-> Token? {
        var result:Token?
        if (currentToken.type == tokenType) {
            result = currentToken
        }
        return result
    }
    
    func expr() -> Either<Any,String> {
        currentToken = getNextToken()
        let left = currentToken
        if eat(tokenType: TokenType.INTEGER) == nil {
            let msg = "Urecognised token \(left.type)"
            return .Error(msg)
        }
        currentToken = getNextToken()
        let op  = currentToken
        if eat(tokenType: TokenType.PLUS) == nil && eat(tokenType: TokenType.MINUS) == nil {
            let msg = "Urecognised token \(op.type)"
            return .Error(msg)
        }
        currentToken = getNextToken()
        let right = currentToken
        if eat(tokenType: TokenType.INTEGER) == nil {
            let msg = "Urecognised token \(right.type)"
            return .Error(msg)
        }
        var result:Any = ""
        if (op.type == TokenType.PLUS) {
            result =  (left.value! as! Int) + (right.value! as! Int)
        } else {
            result =  (left.value! as! Int) - (right.value! as! Int)
        }
        return .Success(result)
    }
}

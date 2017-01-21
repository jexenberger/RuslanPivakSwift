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
    var currentToken:Either<Token,String>
    
    init(text:String) {
        self.text = text
        pos = 0
        currentToken = .Success(Token(type: .BEFORE, value: nil))
    }
    
    func getNextToken()  -> Either<Token, String> {
        /*
         Lexical analyser
         This method is responsible for breaking a sentence
         apart into tokens. One token at a time.
         */
        let workingText = self.text
        // is self.pos index past the end of the self.text ?
        // if so, then return EOF token because there is no more
        // input left to convert into tokens
        if self.pos > workingText.characters.count - 1 {
            return .Success(Token(type: .EOF, value: nil))
        }
        let currentChar =  String(workingText[workingText.index(workingText.startIndex, offsetBy: self.pos)])
        // if the character is a digit then convert it to
        // integer, create an INTEGER token, increment self.pos
        // index to point to the next character after the digit,
        // and return the INTEGER token
        
        if Int(currentChar) != nil {
            self.pos += 1
            return .Success(Token(type: .INTEGER, value: Int(currentChar)))
        }
        
        if currentChar == "+" {
            self.pos += 1
            return .Success(Token(type: .PLUS, value: currentChar))
        }
        return .Error("unable to parse token " + currentChar)
    }
    
    func eat(tokenType:TokenType)-> Token? {
        var result:Token?
        switch (currentToken) {
        case .Success(let token):
            if (token.type == tokenType) {
                result = token
            }
        case .Error:
            return nil
        }
        return result
    }
    
    func expr() -> Either<Any,String> {
        currentToken = getNextToken()
        var left:Token
        var right:Token
        switch currentToken {
            case .Success(let token):
                 left = token
            case .Error(let msg):
                return .Error(msg)
        }
        if eat(tokenType: TokenType.INTEGER) == nil {
            let msg = "Urecognised token \(left.type)"
            return .Error(msg)
        }
        currentToken = getNextToken()
        if eat(tokenType: TokenType.PLUS) == nil {
            let msg = "Urecognised token \(left.type)"
            return .Error(msg)
        }
        currentToken = getNextToken()
        switch currentToken {
            case .Success(let token):
                right = token
            case .Error(let msg):
                return .Error(msg)
        }
        if eat(tokenType: TokenType.PLUS) != nil {
            let msg = "Urecognised token \(right.type)"
            return .Error(msg)
        }
        let result:Any =  (left.value! as! Int) + (right.value! as! Int)
        return .Success(result)
    }
}

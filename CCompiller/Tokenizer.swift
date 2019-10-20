//
//  Tokenizer.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

typealias CharHandler = ((String)->(Bool))

enum TokenizerState: Int, CaseIterable {
    case start = 0
    case identifier
    case string
    case integer
    case `operator`
    case equal
    case tokenFound
    case error
}

class Tokenizer {
    private let file: FileHandle
    private var state = TokenizerState.start
    private var tokenType = TokenType.none
    private var currentToken = ""
    private var startHandlers = [Int: CharHandler]()
    
    init(file: FileHandle) {
        self.file = file
        for c in Character("a")...Character("z") {
            addCharToHandlers(c, withHandler: charHandler)
        }
        
        for digit in Character("0")...Character("9") {
            addCharToHandlers(digit, withHandler: digitHandler)
        }
        
        for operation in [Character("+"), Character("-"), Character("*"), Character("/")] {
            addCharToHandlers(operation, withHandler: operatorHandler)
        }
        
        addCharToHandlers("\"", withHandler: dquoteHandler)
        addCharToHandlers("=", withHandler: equalHandler)
    }
    
    func addCharToHandlers(_ char: Character, withHandler handler: @escaping CharHandler) {
        if let charCode = char.intValue() {
            startHandlers[charCode] = handler
        } else {
            exitWithError("Can't get code for \"[\(char)]\"", code: 1)
        }
    }

    func next() -> Token? {
        if state == .operator {
            state = .start
            return  Token(col: 0, row: 0, type: tokenType, value: currentToken)
        }
        currentToken = ""
        while true {
            let data = file.readData(ofLength: 1)
            guard let tokenChar = String(data: data, encoding: .utf8) else {
                return nil
            }
            
            if tokenChar == " " || tokenChar == "\n" {
                state = .start
                break
            } else if tokenChar == "" {
                return nil
            }
            
            let charCode = Character(tokenChar).intValue()!
            
            if let needToFinishPreviousToken = startHandlers[charCode]?(tokenChar) {
                if needToFinishPreviousToken {
                    file.seek(toFileOffset: file.offsetInFile - 1)
                    break
                }
                currentToken.append(tokenChar)
            }
        }
        
        state = .start

        return Token(col: 0, row: 0, type: tokenType, value: currentToken)
    }
}

private extension Tokenizer {
    
    //MARK: Handlers
    
    func charHandler(_ char: String) -> Bool {
        if state == .string {
            tokenType = .string
        } else {
            tokenType = .identifier
        }
        
        return false
    }
    
    func digitHandler(_ char: String) -> Bool {
        if state == .identifier {
            return false
        }
        state = .integer
        tokenType = .int
        return false
    }
    
    func operatorHandler(_ char: String) -> Bool {
        tokenType = .operation
        state = .operator
        return true
    }
    
    func dquoteHandler(_ char: String) -> Bool {
        if state == .string {
            currentToken.append(char)
            return false
        }
        tokenType = .string
        state = .string
        return false
    }
    
    func equalHandler(_ char: String) -> Bool {
        if state != .start {
            return true
        }
        tokenType = .equal
        state = .equal
        return false
    }
    
    func exitWithError(_ error: String, code: Int32) {
        print(error)
        exit(code)
    }
}

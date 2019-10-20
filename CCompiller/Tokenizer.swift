//
//  Tokenizer.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

struct CharHandler {
    var handler: ((String, TokenType)->(Bool))
    var tokenType: TokenType
}

enum TokenizerState: Int, CaseIterable {
    case start = 0
    case identifier
    case string
    case dquote
    case integer
    case `operator`
    case equal
    case separator
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
            addCharToHandlers(c, withHandler: CharHandler(handler: charHandler, tokenType: .char))
        }
        
        for digit in Character("0")...Character("9") {
            addCharToHandlers(digit, withHandler: CharHandler(handler: digitHandler, tokenType: .int))
        }
        
        for operation in [Character("+"), Character("-"), Character("*"), Character("/")] {
            addCharToHandlers(operation, withHandler: CharHandler(handler: operatorHandler, tokenType: .operation))
        }
        
        addCharToHandlers("\"", withHandler: CharHandler(handler: dquoteHandler, tokenType: .dquote))
        addCharToHandlers("=", withHandler: CharHandler(handler: equalHandler, tokenType: .equal))
        addCharToHandlers("{", withHandler: CharHandler(handler: separatorHandler, tokenType: .leftCurlyBrace))
        addCharToHandlers("}", withHandler: CharHandler(handler: separatorHandler, tokenType: .rightCurlyBrace))
        addCharToHandlers(";", withHandler: CharHandler(handler: separatorHandler, tokenType: .semicolon))
        addCharToHandlers("(", withHandler: CharHandler(handler: separatorHandler, tokenType: .leftBrace))
        addCharToHandlers(")", withHandler: CharHandler(handler: separatorHandler, tokenType: .rightBrace))
    }
    
    func addCharToHandlers(_ char: Character, withHandler handler: CharHandler) {
        if let charCode = char.intValue() {
            startHandlers[charCode] = handler
        } else {
            exitWithError("Can't get code for \"[\(char)]\"", code: 1)
        }
    }

    func next() -> Token? {
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
            
            if let needToFinishPreviousToken = startHandlers[charCode]?.handler(tokenChar, startHandlers[charCode]!.tokenType) {
                if needToFinishPreviousToken {
                    file.seek(toFileOffset: file.offsetInFile - 1)
                    break
                }
                currentToken.append(tokenChar)
                if state == .tokenFound {
                    break
                }
            }
        }
        
        state = .start

        return Token(col: 0, row: 0, type: tokenType, value: currentToken)
    }
}

private extension Tokenizer {
    
    //MARK: Handlers
    
    func charHandler(_ char: String, type: TokenType) -> Bool {
        if tokenType == .dquote {
            tokenType = .string
            state = .string
        }
        if state != .identifier && state != .string && state != .start {
            return true
        } else if state == .string {
            return false
        } else {
            tokenType = .identifier
            state = .identifier
            return false
        }
        
    }
    
    func digitHandler(_ char: String, type: TokenType) -> Bool {
        if state != .start {
            return false
        }
        state = .integer
        tokenType = .int
        return false
    }
    
    func operatorHandler(_ char: String, type: TokenType) -> Bool {
        tokenType = .operation
        state = .tokenFound
        return true
    }
    
    func dquoteHandler(_ char: String, type: TokenType) -> Bool {
        if state != .start {
            return true
        }
        if state == .dquote {
            currentToken.append(char)
            return true
        }
        tokenType = .dquote
        state = .tokenFound
        return false
    }
    
    func equalHandler(_ char: String, type: TokenType) -> Bool {
        if state != .start {
            return true
        }
        tokenType = .equal
        state = .tokenFound
        return false
    }
    
    func separatorHandler(_ char: String, type: TokenType) -> Bool {
        if state != .start {
            return true
        }
        tokenType = type
        state = .tokenFound
        return false
    }
    
    func exitWithError(_ error: String, code: Int32) {
        print(error)
        exit(code)
    }
}

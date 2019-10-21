//
//  Tokenizer.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

struct CharHandler {
    var handler: ((String, TokenType)->())
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
    case savePrevious
    case comment
    case slash
    case division
    case error
}

class Tokenizer {
    private let file: FileHandle
    private let keywords = ["int", "float", "return", "void", "if", "else", "do", "while", "break"]
    
    
    private var state = TokenizerState.start
    private var tokenType = TokenType.none
    private var currentToken = ""
    private var col = 1
    private var row = 1
    private var startHandlers = [Int: CharHandler]()
    
    init(file: FileHandle) {
        self.file = file
        for c in Character("a")...Character("z") {
            addCharToHandlers(c, withHandler: CharHandler(handler: charHandler, tokenType: .char))
        }
        
        for digit in Character("0")...Character("9") {
            addCharToHandlers(digit, withHandler: CharHandler(handler: digitHandler, tokenType: .int))
        }
        
        for operation in [Character("+"), Character("-"), Character("*")] {
            addCharToHandlers(operation, withHandler: CharHandler(handler: operatorHandler, tokenType: .operation))
        }
        
        addCharToHandlers("\"", withHandler: CharHandler(handler: dquoteHandler, tokenType: .dquote))
        addCharToHandlers("=", withHandler: CharHandler(handler: equalHandler, tokenType: .equal))
        addCharToHandlers("{", withHandler: CharHandler(handler: separatorHandler, tokenType: .leftCurlyBrace))
        addCharToHandlers("}", withHandler: CharHandler(handler: separatorHandler, tokenType: .rightCurlyBrace))
        addCharToHandlers(";", withHandler: CharHandler(handler: separatorHandler, tokenType: .semicolon))
        addCharToHandlers("(", withHandler: CharHandler(handler: separatorHandler, tokenType: .leftBrace))
        addCharToHandlers(")", withHandler: CharHandler(handler: separatorHandler, tokenType: .rightBrace))
        addCharToHandlers("\n", withHandler: CharHandler(handler: newStringHandler, tokenType: .none))
        addCharToHandlers("/", withHandler: CharHandler(handler: slashHandler, tokenType: .comment))
        addCharToHandlers(" ", withHandler: CharHandler(handler: spaceHandler, tokenType: .none))
    }
    
    func addCharToHandlers(_ char: Character, withHandler handler: CharHandler) {
        if let charCode = char.intValue() {
            startHandlers[charCode] = handler
        } else {
            exitWithError("Can't get code for \"[\(char)]\"", code: 1)
        }
    }

    func next() -> Token? {
        col += currentToken.count
        currentToken = ""
        while true {
            let data = file.readData(ofLength: 1)
            guard let tokenChar = String(data: data, encoding: .utf8) else {
                return nil
            }
            
            if tokenChar == "" {
                return nil
            }
            
            if state == .comment && tokenChar != "\n" {
                continue
            }
            
            let charCode = Character(tokenChar).intValue()!
            
            if let _ = startHandlers[charCode]?.handler(tokenChar, startHandlers[charCode]!.tokenType) {
                if state == .start {
                    break
                }
                if state == .savePrevious {
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
        if keywords.contains(currentToken) {
            tokenType = .keyword
        }
        return Token(col: col, row: row, type: tokenType, value: currentToken)
    }
}

private extension Tokenizer {
    
    //MARK: Handlers
    
    func charHandler(_ char: String, type: TokenType) {
        if tokenType == .dquote {
            tokenType = .string
            state = .string
        }
        if state != .identifier && state != .string && state != .start {
            state = .savePrevious
        } else if state == .string || state == .comment {
            return
        } else {
            tokenType = .identifier
            state = .identifier
            return
        }
        
    }
    
    func digitHandler(_ char: String, type: TokenType) {
        if state != .start {
            return
        }
        state = .integer
        tokenType = .int
    }
    
    func operatorHandler(_ char: String, type: TokenType) {
        tokenType = .operation
        if state != .start {
            state = .savePrevious
        } else {
            state = .tokenFound
        }
    }
    
    func dquoteHandler(_ char: String, type: TokenType) {
        if state != .start {
            return
        }
        if state == .dquote {
            currentToken.append(char)
            state = .savePrevious
            return
        }
        tokenType = .dquote
        state = .tokenFound
    }
    
    func equalHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        tokenType = .equal
        state = .tokenFound
    }
    
    func separatorHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        tokenType = type
        state = .tokenFound
    }
    
    func newStringHandler(_ char: String, type: TokenType) {
        row += 1
        col = 1
        state = .start
    }
    
    func spaceHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        col += 1
        tokenType = .none
    }
    
    func slashHandler(_ char: String, type: TokenType) {
        if state == .division {
            tokenType = .comment
            state = .comment
            return
        }
        tokenType = .division
        state = .division
    }
    
    func exitWithError(_ error: String, code: Int32) {
        print(error)
        exit(code)
    }
}

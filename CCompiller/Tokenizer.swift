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
    case float
    case `operator`
    case equal
    case separator
    case tokenFound
    case savePrevious
    case comment
    case slash
    case division
    case ampersand
    case pipe
    case space
    case newString
    case biggerThan
    case lowerThan
    case error
}

public class Tokenizer {
    private let file: FileHandle
    private let keywords = ["int", "float", "return", "void", "if", "else", "do", "while", "break", "const", "char"]
    
    
    private var state = TokenizerState.start
    private var tokenType = TokenType.none
    private var currentToken = ""
    private var col = 1
    private var row = 1
    private var startHandlers = [Int: CharHandler]()
    private var errorMessage = ""
    
    init(file: FileHandle) {
        self.file = file
        for c in Character("a")...Character("z") {
            addCharToHandlers(c, withHandler: CharHandler(handler: charHandler, tokenType: .char))
        }
        
        for digit in Character("0")...Character("9") {
            addCharToHandlers(digit, withHandler: CharHandler(handler: digitHandler, tokenType: .int))
        }
        
        addCharToHandlers("\"", withHandler: CharHandler(handler: dquoteHandler, tokenType: .dquote))
        addCharToHandlers("=", withHandler: CharHandler(handler: equalHandler, tokenType: .equal))
        addCharToHandlers("{", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .leftCurlyBrace))
        addCharToHandlers("}", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .rightCurlyBrace))
        addCharToHandlers(";", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .semicolon))
        addCharToHandlers("(", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .leftBrace))
        addCharToHandlers(")", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .rightBrace))
        addCharToHandlers("\n", withHandler: CharHandler(handler: newStringHandler, tokenType: .none))
        addCharToHandlers("/", withHandler: CharHandler(handler: slashHandler, tokenType: .comment))
        addCharToHandlers(" ", withHandler: CharHandler(handler: spaceHandler, tokenType: .none))
        addCharToHandlers("!", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .exclamation))
        addCharToHandlers(">", withHandler: CharHandler(handler: biggerThanHandler, tokenType: .biggerThan))
        addCharToHandlers("<", withHandler: CharHandler(handler: lowerThanHandler, tokenType: .lowerThan))
        addCharToHandlers(".", withHandler: CharHandler(handler: dotHandler, tokenType: .dot))
        addCharToHandlers("&", withHandler: CharHandler(handler: ampersandHandler, tokenType: .ampersand))
        addCharToHandlers("|", withHandler: CharHandler(handler: pipeHandler, tokenType: .pipe))
        addCharToHandlers("+", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .plus))
        addCharToHandlers("-", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .minus))
        addCharToHandlers("*", withHandler: CharHandler(handler: singleTokenHandler, tokenType: .multiple))
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
                if state == .error {
                    return Token(col: col, row: row, type: .error, source: errorMessage)
                }
                if state == .space || state == .newString {
                    currentToken = ""
                    state = .start
                    continue
                }
                if state == .savePrevious {
                    if tokenType == .comment {
                        currentToken = ""
                        state = .start
                        continue
                    }
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
        
        if tokenType == .int {
            guard let _ = Int(currentToken) else {
                return Token(col: col, row: row, type: .error, source: "Lexer error: Int is out of bounds")
            }
        }
        
        if tokenType == .float && currentToken.suffix(1) != "e" {
            guard let _ = Float(currentToken) else {
                return Token(col: col, row: row, type: .error, source: "Lexer error: Float is out of bounds")
            }
        }
        
        return Token(col: col, row: row, type: tokenType, source: currentToken)
    }
}

private extension Tokenizer {
    
    //MARK: Handlers
    
    func charHandler(_ char: String, type: TokenType) {
        if tokenType == .dquote {
            tokenType = .string
            state = .string
        }
        if tokenType == .int {
            state = .error
            errorMessage = "Lexer error: Invalid digit \"\(char)\" in decimal"
            return
        }
        if tokenType == .float && char == "e" {
            return
        }
        if tokenType == .float {
            state = .error
            errorMessage = "Lexer error: Invalid digit \"\(char)\" in float"
            return
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
    
    func dquoteHandler(_ char: String, type: TokenType) {
        if state == .string{
            state = .savePrevious
            return
        }
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
        if state != .start && state != .equal && state != .biggerThan && state != .lowerThan {
            state = .savePrevious
            return
        }
        
        if state == .biggerThan {
            state = .tokenFound
            tokenType = .biggerOrEqual
            return
        }
        
        if state == .lowerThan {
            state = .tokenFound
            tokenType = .lowerOrEqual
            return
        }
        
        if state == .equal {
            state = .tokenFound
            tokenType = .comparasion
            return
        }
        
        tokenType = type
        state = .equal
    }
    
    func newStringHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        row += 1
        col = 1
        state = .newString
    }
    
    func spaceHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        col += 1
        tokenType = .space
        state = .space
    }
    
    func slashHandler(_ char: String, type: TokenType) {
        if state == .division {
            tokenType = .comment
            state = .comment
            return
        }
        if state != .start {
            state = .savePrevious
            return
        }
        tokenType = .division
        state = .division
    }
    
    func dotHandler(_ char: String, type: TokenType) {
        if state == .integer {
            tokenType = .float
            state = .float
        } else if state == .float {
            state = .error
            errorMessage = "Lexer error: Invalid extra point in Float"
            return
        } else if state == .start {
            tokenType = .dot
            state = .tokenFound
        } else {
            tokenType = .dot
            state = .savePrevious
        }
    }
    
    func pipeHandler(_ char: String, type: TokenType) {
        if state != .start && state != .pipe {
            state = .savePrevious
            return
        }
        
        if state == .pipe {
            state = .tokenFound
            tokenType = .or
            return
        }
        tokenType = type
        state = .pipe
    }
    
    func ampersandHandler(_ char: String, type: TokenType) {
        if state != .start && state != .ampersand {
            state = .savePrevious
            return
        }
        if state == .ampersand {
            state = .tokenFound
            tokenType = .and
            return
        }
        tokenType = type
        state = .ampersand
    }
    
    func biggerThanHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        
        tokenType = type
        state = .biggerThan
    }
    
    func lowerThanHandler(_ char: String, type: TokenType) {
        if state != .start {
            state = .savePrevious
            return
        }
        
        tokenType = type
        state = .lowerThan
    }
    
    func singleTokenHandler(_ char: String, type: TokenType) {
        if state == .float && (type == .minus || type == .plus) && currentToken.suffix(1) == "e" {
            return
        }
        if state != .start {
            state = .savePrevious
            return
        }
        tokenType = type
        state = .tokenFound
    }
    
    func exitWithError(_ error: String, code: Int32) {
        print(error)
        exit(code)
    }
}

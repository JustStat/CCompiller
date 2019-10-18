//
//  Tokenizer.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

enum TokenizerState {
    case start
    case identifier
    case integer
    case dqoute
    case `operator`
    case tokenFound
}

class Tokenizer {
    private let file: FileHandle
    private var state = TokenizerState.start
    private var tokenType = TokenType.none
    private var currentToken = ""
    private var nfa = [TokenizerState: [String: (()->())]]()
    
    init(file: FileHandle) {
        self.file = file
    }

    func next() -> Token? {
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
            
            if ("a"..."z").contains(tokenChar) {
                if state == .dqoute {
                    currentToken.append(tokenChar)
                    continue
                }
                
                state = .identifier
                tokenType = .identifier
                currentToken.append(tokenChar)
                continue
            }
            if let _ = Int(tokenChar) {
                if state == .identifier {
                    currentToken.append(tokenChar)
                    continue
                }
                state = .integer
                tokenType = .int
                currentToken.append(tokenChar)
            }
            if ["+", "-", "*", "/", "="].contains(tokenChar) {
                tokenType = .operation
                state = .operator
                currentToken.append(tokenChar)
                break
            }
            if tokenChar == "\"" {
                if state == .dqoute {
                    currentToken.append(tokenChar)
                    break
                }
                tokenType = .string
                state = .dqoute
                currentToken.append(tokenChar)
            }
        }
        
        state = .start
        return Token(col: 0, row: 0, type: tokenType, value: currentToken)
    }
    
    func charHandler(_ char: String) {
        if state == .dqoute {
            currentToken.append(char)
            return
        }
        
        state = .identifier
        tokenType = .identifier
        currentToken.append(char)
    }
}

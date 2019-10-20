//
//  Token.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

enum TokenType {
    case none
    case int
    case float
    case char
    case string
    case delimeter
    case identifier
    case operation
    case equal
    case dquote
    case leftBrace
    case rightBrace
    case leftCurlyBrace
    case rightCurlyBrace
    case semicolon
    case keyword
}

struct Token {
    var col: Int
    var row: Int
    var type: TokenType
    var value: String
}

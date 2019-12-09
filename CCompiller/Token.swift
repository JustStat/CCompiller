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
    case division
    case equal
    case dquote
    case leftBrace
    case rightBrace
    case leftCurlyBrace
    case rightCurlyBrace
    case semicolon
    case keyword
    case comment
    case exclamation
    case biggerThan
    case lowerThan
    case dot
    case ampersand
    case pipe
    case plus
    case minus
    case multiple
    case or
    case and
    case biggerOrEqual
    case lowerOrEqual
    case comparasion
    case space
    case error
}

struct Token: Equatable {
    var col: Int
    var row: Int
    var type: TokenType
    var source: String
    var value: AnyHashable?
}

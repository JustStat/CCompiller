//
//  CCompillerTests.swift
//  CCompillerTests
//
//  Created by Kirill Varlamov on 21/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import XCTest

let filePath = "/Users/kirillvarlamov/Documents/Учеба/4 курс зима/Компиль/CCompiller/Tests/"
let files = ["empty.c"]

class CCompillerTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmpty() {
       let output = performWithFile(name: "empty.c")
       XCTAssertEqual([], output)
    }

    //MARK: Int Tests

    func testInt() {
        let output = performWithFile(name: "testInt.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .int, source: "123"),
            Token(col: 4, row: 1, type: .semicolon,  source: ";")])
    }

    func testNegativeInt() {
        let output = performWithFile(name: "testNegativeInt.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .minus,  source: "-"),
            Token(col: 2, row: 1, type: .int,  source: "123"),
            Token(col: 5, row: 1, type: .semicolon,  source: ";")])
    }

    func testPositiveInt() {
        let output = performWithFile(name: "testPositiveInt.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .plus,  source: "+"),
            Token(col: 2, row: 1, type: .int,  source: "2312223321"),
            Token(col: 12, row: 1, type: .semicolon,  source: ";")])
    }

    func testMaxIntOver() {
        let output = performWithFile(name: "testMaxIntOver.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error,  source: "Lexer error: Int is out of bounds")
        ])
    }

    func testIntMix() {
        let output = performWithFile(name: "testIntMix.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error,  source: "Lexer error: Invalid digit \"a\" in decimal")
        ])
    }

    //MARK: Float Tests

    func testFloat() {
        let output = performWithFile(name: "testFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .float,  source: "1.23"),
        Token(col: 5, row: 1, type: .semicolon,  source: ";")])
    }

    func testNegativeFloat() {
        let output = performWithFile(name: "testNegativeFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .minus,  source: "-"),
        Token(col: 2, row: 1, type: .float,  source: "1.23"),
        Token(col: 6, row: 1, type: .semicolon,  source: ";")])
    }

    func testExpanentFloat() {
        let output = performWithFile(name: "testExpanentFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .float,  source: "1.23e10"),
        Token(col: 8, row: 1, type: .semicolon,  source: ";")])
    }

    func testNegativeExpanentFloat() {
        let output = performWithFile(name: "testNegativeExpanentFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .float,  source: "1.23e-10"),
        Token(col: 9, row: 1, type: .semicolon,  source: ";")])
    }

    func testExtraPointFloat() {
        let output = performWithFile(name: "testExtraPointFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .error,  source: "Lexer error: Invalid extra point in Float")])
    }

    func testMixFloat() {
        let output = performWithFile(name: "testMixFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .error,  source: "Lexer error: Invalid digit \"f\" in float")])
    }

    func testMaxFloatOver() {
        let output = performWithFile(name: "testMaxFloatOver.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error,  source: "Lexer error: Float is out of bounds")
        ])
    }

    func testMinFloatOver() {
        let output = performWithFile(name: "testMinFloatOver.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error,  source: "Lexer error: Float is out of bounds")
        ])
    }

    //MARK: Identifier tests

    func testIdentifier() {
        let output = performWithFile(name: "testIdentifier.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "abcde")
        ])
    }

    func testInvalidIdentifier() {
        let output = performWithFile(name: "testInvalidIdentifier.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error,  source: "Lexer error: Invalid digit \"a\" in decimal")
        ])
    }

    func testKeywords() {
        let output = performWithFile(name: "testKeywords.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .keyword,  source: "int"),
            Token(col: 1, row: 2, type: .keyword,  source: "float"),
            Token(col: 1, row: 3, type: .keyword,  source: "return"),
            Token(col: 1, row: 4, type: .keyword,  source: "void"),
            Token(col: 1, row: 5, type: .keyword,  source: "if"),
            Token(col: 1, row: 6, type: .keyword,  source: "else"),
            Token(col: 1, row: 7, type: .keyword,  source: "do"),
            Token(col: 1, row: 8, type: .keyword,  source: "while"),
            Token(col: 1, row: 9, type: .keyword,  source: "break"),
            Token(col: 1, row: 10, type: .keyword,  source: "const"),
            Token(col: 1, row: 11, type: .keyword,  source: "char")
        ])
    }

    //MARK: Minus operator tests

    func testMinus() {
        let output = performWithFile(name: "testMinus.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .minus,  source: "-"),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }
    func testMinusWithoutSpace() {
        let output = performWithFile(name: "testMinusWithoutSpace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .minus,  source: "-"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testMinusWithoutSpaceExponent() {
        let output = performWithFile(name: "testMinusWithoutSpaceExponent.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "e"),
            Token(col: 2, row: 1, type: .minus,  source: "-"),
            Token(col: 3, row: 1, type: .int,  source: "100")
        ])
    }

    func testDoubleMinus() {
        let output = performWithFile(name: "testDoubleMinus.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .minus,  source: "-"),
            Token(col: 2, row: 1, type: .minus,  source: "-"),
            Token(col: 3, row: 1, type: .int,  source: "100")
        ])
    }

    //MARK: Plus operator tests

    func testPlus() {
        let output = performWithFile(name: "testPlus.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .plus,  source: "+"),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }
    func testPlusWithoutSpace() {
        let output = performWithFile(name: "testPlusWithoutSpace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .plus,  source: "+"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testPlusWithoutSpaceExponent() {
        let output = performWithFile(name: "testPlusWithoutSpaceExponent.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "e"),
            Token(col: 2, row: 1, type: .plus,  source: "+"),
            Token(col: 3, row: 1, type: .int,  source: "100")
        ])
    }

    func testDoublePlus() {
        let output = performWithFile(name: "testDoublePlus.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .plus,  source: "+"),
            Token(col: 2, row: 1, type: .plus,  source: "+"),
            Token(col: 3, row: 1, type: .int,  source: "100")
        ])
    }

    //MARK: Division operator tests

    func testDivision() {
        let output = performWithFile(name: "testDivision.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .division,  source: "/"),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }
    func testDivisionWithoutSpace() {
        let output = performWithFile(name: "testDivisionWithoutSpace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .division,  source: "/"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testComment() {
        let output = performWithFile(name: "testComment.c")
        XCTAssertEqual(output, [])
    }

    //MARK: Multiplication operator tests

    func testMultiplication() {
        let output = performWithFile(name: "testMultiplication.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .multiple,  source: "*"),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }
    func testMultiplicationWithoutSpace() {
        let output = performWithFile(name: "testMultiplicationWithoutSpace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .multiple,  source: "*"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    //Quotes tests

    func testDoubleQuote() {
        let output = performWithFile(name: "testDoubleQuote.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .dquote,  source: "\"")
        ])
    }
    func testTwoDoubleQuote() {
        let output = performWithFile(name: "testTwoDoubleQuote.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .dquote,  source: "\""),
            Token(col: 2, row: 1, type: .dquote,  source: "\"")
        ])
    }

    func testString() {
        let output = performWithFile(name: "testString.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .dquote,  source: "\""),
            Token(col: 2, row: 1, type: .string,  source: "abc"),
            Token(col: 5, row: 1, type: .dquote,  source: "\"")
        ])
    }

    //Brace test

    func testLeftCurlyBrace() {
        let output = performWithFile(name: "testLeftCurlyBrace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .leftCurlyBrace,  source: "{")
        ])
    }

    func testRightCurlyBrace() {
        let output = performWithFile(name: "testRightCurlyBrace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .rightCurlyBrace,  source: "}")
        ])
    }

    func testLeftBrace() {
        let output = performWithFile(name: "testLeftBrace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .leftBrace,  source: "(")
        ])
    }

    func testRightBrace() {
        let output = performWithFile(name: "testRightBrace.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .rightBrace,  source: ")")
        ])
    }

    //Equalision tests

    func testEqual() {
        let output = performWithFile(name: "testEqual.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .equal,  source: "="),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testComparasion() {
        let output = performWithFile(name: "testComparasion.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .comparasion,  source: "=="),
            Token(col: 6, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testComparasionWithoutSpaces() {
        let output = performWithFile(name: "testComparasionWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .comparasion,  source: "=="),
            Token(col: 4, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testEqualWithoutSpaces() {
        let output = performWithFile(name: "testEqualWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .equal,  source: "="),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testBiggerThan() {
        let output = performWithFile(name: "testBiggerThan.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .biggerThan,  source: ">"),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testBiggerThanWithoutSpaces() {
        let output = performWithFile(name: "testBiggerThanWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .biggerThan,  source: ">"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testLowerThan() {
        let output = performWithFile(name: "testLowerThan.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 3, row: 1, type: .lowerThan,  source: "<"),
            Token(col: 5, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testLowerThanWithoutSpaces() {
        let output = performWithFile(name: "testLowerThanWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .lowerThan,  source: "<"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testPipe() {
        let output = performWithFile(name: "testPipe.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .pipe,  source: "|")
        ])
    }

    func testOr() {
        let output = performWithFile(name: "testOr.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .or,  source: "||")
        ])
    }

    func testPipeWithoutSpaces() {
        let output = performWithFile(name: "testPipeWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .pipe,  source: "|"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testOrWithoutSpaces() {
        let output = performWithFile(name: "testOrWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .or,  source: "||"),
            Token(col: 4, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testAmpersand() {
        let output = performWithFile(name: "testAmpersand.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .ampersand,  source: "&")
        ])
    }

    func testAnd() {
        let output = performWithFile(name: "testAnd.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .and,  source: "&&")
        ])
    }

    func testAmpersandWithoutSpaces() {
        let output = performWithFile(name: "testAmpersandWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .ampersand,  source: "&"),
            Token(col: 3, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testAndWithoutSpaces() {
        let output = performWithFile(name: "testAndWithoutSpaces.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .identifier,  source: "a"),
            Token(col: 2, row: 1, type: .and,  source: "&&"),
            Token(col: 4, row: 1, type: .identifier,  source: "b")
        ])
    }

    func testBiggerOrEqual() {
        let output = performWithFile(name: "testBiggerOrEqual.c")
               XCTAssertEqual(output, [
                   Token(col: 1, row: 1, type: .identifier,  source: "a"),
                   Token(col: 3, row: 1, type: .biggerOrEqual,  source: ">="),
                   Token(col: 6, row: 1, type: .identifier,  source: "b")
               ])
    }

    func testBiggerOrEqualWithoutSpaces() {
        let output = performWithFile(name: "testBiggerOrEqualWithoutSpaces.c")
               XCTAssertEqual(output, [
                   Token(col: 1, row: 1, type: .identifier,  source: "a"),
                   Token(col: 2, row: 1, type: .biggerOrEqual,  source: ">="),
                   Token(col: 4, row: 1, type: .identifier,  source: "b")
               ])
    }

    func testLowerOrEqual() {
        let output = performWithFile(name: "testLowerOrEqual.c")
               XCTAssertEqual(output, [
                   Token(col: 1, row: 1, type: .identifier,  source: "a"),
                   Token(col: 3, row: 1, type: .lowerOrEqual,  source: "<="),
                   Token(col: 6, row: 1, type: .identifier,  source: "b")
               ])
    }

    func testLowerOrEqualWithoutSpaces() {
        let output = performWithFile(name: "testLowerOrEqualWithoutSpaces.c")
               XCTAssertEqual(output, [
                   Token(col: 1, row: 1, type: .identifier,  source: "a"),
                   Token(col: 2, row: 1, type: .lowerOrEqual,  source: "<="),
                   Token(col: 4, row: 1, type: .identifier,  source: "b")
               ])
    }

    func test1() {
        let output = performWithFile(name: "test1.c")
               XCTAssertEqual(output, [
                   Token(col: 1, row: 1, type: .identifier,  source: "a"),
                   Token(col: 2, row: 1, type: .biggerOrEqual,  source: ">="),
                   Token(col: 4, row: 1, type: .equal,  source: "="),
                   Token(col: 5, row: 1, type: .identifier,  source: "b")
               ])
    }

    func performWithFile(name: String) -> [Token] {
        let input = FileHandle(forReadingAtPath: filePath + name)
        let tokenizer = Tokenizer(file: input!)
        var tokens = [Token]()
        while let token = tokenizer.next() {
            if token.source == "" {
                break
            }

            tokens.append(token)

            if token.type == .error {
                break;
            }
        }

        return tokens
    }
}

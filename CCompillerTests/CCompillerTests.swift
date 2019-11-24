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
            Token(col: 1, row: 1, type: .int, value: "123"),
            Token(col: 4, row: 1, type: .semicolon, value: ";")])
    }
    
    func testNegativeInt() {
        let output = performWithFile(name: "testNegativeInt.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .minus, value: "-"),
            Token(col: 2, row: 1, type: .int, value: "123"),
            Token(col: 5, row: 1, type: .semicolon, value: ";")])
    }
    
    func testPositiveInt() {
        let output = performWithFile(name: "testPositiveInt.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .plus, value: "+"),
            Token(col: 2, row: 1, type: .int, value: "2312223321"),
            Token(col: 12, row: 1, type: .semicolon, value: ";")])
    }
    
    func testMaxIntOver() {
        let output = performWithFile(name: "testMaxIntOver.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error, value: "Lexer error: Int is out of bounds")
        ])
    }
    
    func testIntMix() {
        let output = performWithFile(name: "testIntMix.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error, value: "Lexer error: Invalid digit \"a\" in decimal")
        ])
    }
    
    //MARK: Float Tests
    
    func testFloat() {
        let output = performWithFile(name: "testFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .float, value: "1.23"),
        Token(col: 5, row: 1, type: .semicolon, value: ";")])
    }
    
    func testNegativeFloat() {
        let output = performWithFile(name: "testNegativeFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .minus, value: "-"),
        Token(col: 2, row: 1, type: .float, value: "1.23"),
        Token(col: 6, row: 1, type: .semicolon, value: ";")])
    }
    
    func testExpanentFloat() {
        let output = performWithFile(name: "testExpanentFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .float, value: "1.23e10"),
        Token(col: 8, row: 1, type: .semicolon, value: ";")])
    }
    
    func testNegativeExpanentFloat() {
        let output = performWithFile(name: "testNegativeExpanentFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .float, value: "1.23e-10"),
        Token(col: 9, row: 1, type: .semicolon, value: ";")])
    }
    
    func testExtraPointFloat() {
        let output = performWithFile(name: "testExtraPointFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .error, value: "Lexer error: Invalid extra point in Float")])
    }
    
    func testMixFloat() {
        let output = performWithFile(name: "testMixFloat.c")
        XCTAssertEqual(output, [
        Token(col: 1, row: 1, type: .error, value: "Lexer error: Invalid digit \"f\" in float")])
    }
    
    func testMaxFloatOver() {
        let output = performWithFile(name: "testMaxFloatOver.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error, value: "Lexer error: Float is out of bounds")
        ])
    }
    
    func testMinFloatOver() {
        let output = performWithFile(name: "testMinFloatOver.c")
        XCTAssertEqual(output, [
            Token(col: 1, row: 1, type: .error, value: "Lexer error: Float is out of bounds")
        ])
    }
    
    //MARK: Identifier tests
    
    
    
    
    
    func performWithFile(name: String) -> [Token] {
        let input = FileHandle(forReadingAtPath: filePath + name)
        let tokenizer = Tokenizer(file: input!)
        var tokens = [Token]()
        while let token = tokenizer.next() {
            if token.value == "" {
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

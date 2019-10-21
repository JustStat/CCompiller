//
//  CCompillerTests.swift
//  CCompillerTests
//
//  Created by Kirill Varlamov on 21/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import XCTest

let filePath = "/Users/kirillvarlamov/Documents/Учеба/4 курс зима/Компиль/CCompiller/build/Debug/Tests/"
let files = ["empty.c"]

class CCompillerTests: XCTestCase {
    
    override func setUp() {}

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmpty() {
        let input = FileHandle(forReadingAtPath: filePath + "empty.c")
        let tokenizer = Tokenizer(file: input!)
        while let token = tokenizer.next() {
            if token.value != "" {
                let output = "row: \(token.row) coll: \(token.col), type:\(token.type), value:\(token.value)"
                print(output)
                XCTAssert(output == "")
            }
        }
    }
    
    func testInt() {
        let input = FileHandle(forReadingAtPath: filePath + "intTest.c")
        let tokenizer = Tokenizer(file: input!)
        var output = ""
        while let token = tokenizer.next() {
            if token.value != "" {
                output = output + "row: \(token.row) coll: \(token.col), type:\(token.type), value:\(token.value)\n"
            }
        }
        print(output)
        print("row: 1 coll: 1, type:keyword, value:int\nrow: 1 coll: 5, type:int, value:10")
        XCTAssert(output == "row: 1 coll: 1, type:keyword, value:int\nrow: 1 coll: 5, type:int, value:10\n")
    }
}

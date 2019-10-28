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
       let output = performWithFile(name: "empty.c")
       XCTAssert(output == "")
    }
    
    func testInt() {
        /* int 10*/
        let output = performWithFile(name: "intTest.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:int, value:10\n
            """)
    }
    
    func testFloat() {
        /* float 12323123.22132232123 */
        let output = performWithFile(name: "floatTest.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:float
            row: 1 coll: 7, type:float, value:12323123.22132232123\n
            """)
    }
    
    func testMultiDigit() {
        /* int main() {
            return 100;
           }
         */
        let output = performWithFile(name: "multiDigit.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:100
            row: 2 coll: 15, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testNewLines() {
        /*
        int
        main
        (
        )
        {
        return
        0
        ;
        }*/
        let output = performWithFile(name: "newlines.c")
        XCTAssertEqual(output, """
            row: 2 coll: 1, type:keyword, value:int
            row: 3 coll: 1, type:identifier, value:main
            row: 4 coll: 1, type:leftBrace, value:(
            row: 5 coll: 1, type:rightBrace, value:)
            row: 6 coll: 1, type:leftCurlyBrace, value:{
            row: 7 coll: 1, type:keyword, value:return
            row: 8 coll: 1, type:int, value:0
            row: 9 coll: 1, type:semicolon, value:;
            row: 10 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testNoNewLines() {
        /* int main(){return 0;} */
        let output = performWithFile(name: "noNewlines.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 11, type:leftCurlyBrace, value:{
            row: 1 coll: 12, type:keyword, value:return
            row: 1 coll: 19, type:int, value:0
            row: 1 coll: 20, type:semicolon, value:;
            row: 1 coll: 21, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testSpaces() {
        /* int   main    (  )  {   return  0 ; } */
        let output = performWithFile(name: "spaces.c")
        XCTAssertEqual(output, """
            row: 1 coll: 4, type:keyword, value:int
            row: 1 coll: 10, type:identifier, value:main
            row: 1 coll: 18, type:leftBrace, value:(
            row: 1 coll: 21, type:rightBrace, value:)
            row: 1 coll: 24, type:leftCurlyBrace, value:{
            row: 1 coll: 28, type:keyword, value:return
            row: 1 coll: 36, type:int, value:0
            row: 1 coll: 38, type:semicolon, value:;
            row: 1 coll: 40, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testNestedOps() {
        /*
           int main() {
             return !-3;
           }
        */
        let output = performWithFile(name: "nestedOps.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:exclamation, value:!
            row: 2 coll: 13, type:minus, value:-
            row: 2 coll: 14, type:int, value:3
            row: 2 coll: 15, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testAdd() {
        /*
           int main() {
            return 1 + 2;
           }
        */
        let output = performWithFile(name: "add.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:plus, value:+
            row: 2 coll: 16, type:int, value:2
            row: 2 coll: 17, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testMult() {
        /*
            int main() {
                return 2 * 3;
            }
        */
        let output = performWithFile(name: "mult.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:2
            row: 2 coll: 14, type:multiple, value:*
            row: 2 coll: 16, type:int, value:3
            row: 2 coll: 17, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testParens() {
        /*
            int main() {
                return 2 * (3 + 4);
            }
        */
        let output = performWithFile(name: "parens.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:2
            row: 2 coll: 14, type:multiple, value:*
            row: 2 coll: 16, type:leftBrace, value:(
            row: 2 coll: 17, type:int, value:3
            row: 2 coll: 19, type:plus, value:+
            row: 2 coll: 21, type:int, value:4
            row: 2 coll: 22, type:rightBrace, value:)
            row: 2 coll: 23, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testSub() {
        /*
            int main() {
                return 1 - 2;
            }
        */
        let output = performWithFile(name: "sub.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:minus, value:-
            row: 2 coll: 16, type:int, value:2
            row: 2 coll: 17, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testAmpersand() {
        /*
            int main() {
                return 1 && 0;
            }
        */
        let output = performWithFile(name: "ampersand.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:ampersand, value:&
            row: 2 coll: 15, type:ampersand, value:&
            row: 2 coll: 17, type:int, value:0
            row: 2 coll: 18, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testEqual() {
        /*
            int main() {
                return 1 == 1;
            }
         */
        let output = performWithFile(name: "equal.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:equal, value:=
            row: 2 coll: 15, type:equal, value:=
            row: 2 coll: 17, type:int, value:1
            row: 2 coll: 18, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testBiggerEqual() {
        /*
            int main() {
                return 1 >= 2;
            }
        */
        let output = performWithFile(name: "biggerEqual.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:biggerThan, value:>
            row: 2 coll: 15, type:equal, value:=
            row: 2 coll: 17, type:int, value:2
            row: 2 coll: 18, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testBigger() {
        /*
            int main() {
                return 1 > 0;
            }
        */
        let output = performWithFile(name: "biggerEqual.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:biggerThan, value:>
            row: 2 coll: 15, type:equal, value:=
            row: 2 coll: 17, type:int, value:2
            row: 2 coll: 18, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testLessEqual() {
        /*
            int main() {
                return 0 <= 2;
            }
        */
        let output = performWithFile(name: "lessEqual.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:0
            row: 2 coll: 14, type:lowerThan, value:<
            row: 2 coll: 15, type:equal, value:=
            row: 2 coll: 17, type:int, value:2
            row: 2 coll: 18, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testLess() {
        /*
            int main() {
                return 1 < 2;
            }
        */
        let output = performWithFile(name: "less.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:lowerThan, value:<
            row: 2 coll: 16, type:int, value:2
            row: 2 coll: 17, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }

    func testNegative() {
        /*
            int main() {
                return -1 != -2;
            }
         */
        let output = performWithFile(name: "negative.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:minus, value:-
            row: 2 coll: 13, type:int, value:1
            row: 2 coll: 15, type:exclamation, value:!
            row: 2 coll: 16, type:equal, value:=
            row: 2 coll: 18, type:minus, value:-
            row: 2 coll: 19, type:int, value:2
            row: 2 coll: 20, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testOr() {
        /*
            int main() {
                return 1 || 0;
            }
         */
        let output = performWithFile(name: "or.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:return
            row: 2 coll: 12, type:int, value:1
            row: 2 coll: 14, type:pipe, value:|
            row: 2 coll: 15, type:pipe, value:|
            row: 2 coll: 17, type:int, value:0
            row: 2 coll: 18, type:semicolon, value:;
            row: 3 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testElse() {
        /*
            int main() {
                int a = 0;
                if (a)
                    return 1;
                else
                    return 2;
            }
        */
        let output = performWithFile(name: "else.c")
        XCTAssertEqual(output, """
            row: 1 coll: 1, type:keyword, value:int
            row: 1 coll: 5, type:identifier, value:main
            row: 1 coll: 9, type:leftBrace, value:(
            row: 1 coll: 10, type:rightBrace, value:)
            row: 1 coll: 12, type:leftCurlyBrace, value:{
            row: 2 coll: 5, type:keyword, value:int
            row: 2 coll: 9, type:identifier, value:a
            row: 2 coll: 11, type:equal, value:=
            row: 2 coll: 13, type:int, value:0
            row: 2 coll: 14, type:semicolon, value:;
            row: 3 coll: 5, type:keyword, value:if
            row: 3 coll: 8, type:leftBrace, value:(
            row: 3 coll: 9, type:identifier, value:a
            row: 3 coll: 10, type:rightBrace, value:)
            row: 4 coll: 9, type:keyword, value:return
            row: 4 coll: 16, type:int, value:1
            row: 4 coll: 17, type:semicolon, value:;
            row: 5 coll: 5, type:keyword, value:else
            row: 6 coll: 9, type:keyword, value:return
            row: 6 coll: 16, type:int, value:2
            row: 6 coll: 17, type:semicolon, value:;
            row: 7 coll: 1, type:rightCurlyBrace, value:}\n
            """)
    }
    
    func testIf() {
        /*
             int main() {
                int a = 0;
                if (1)
                    if (2)
                        a = 3;
                    else
                        a = 4;

                return a;
            }
         */
        let output = performWithFile(name: "if.c")
        XCTAssertEqual(output, """
        row: 1 coll: 1, type:keyword, value:int
        row: 1 coll: 5, type:identifier, value:main
        row: 1 coll: 9, type:leftBrace, value:(
        row: 1 coll: 10, type:rightBrace, value:)
        row: 1 coll: 12, type:leftCurlyBrace, value:{
        row: 2 coll: 5, type:keyword, value:int
        row: 2 coll: 9, type:identifier, value:a
        row: 2 coll: 11, type:equal, value:=
        row: 2 coll: 13, type:int, value:0
        row: 2 coll: 14, type:semicolon, value:;
        row: 3 coll: 5, type:keyword, value:if
        row: 3 coll: 8, type:leftBrace, value:(
        row: 3 coll: 9, type:int, value:1
        row: 3 coll: 10, type:rightBrace, value:)
        row: 4 coll: 9, type:keyword, value:if
        row: 4 coll: 12, type:leftBrace, value:(
        row: 4 coll: 13, type:int, value:2
        row: 4 coll: 14, type:rightBrace, value:)
        row: 5 coll: 13, type:identifier, value:a
        row: 5 coll: 15, type:equal, value:=
        row: 5 coll: 17, type:int, value:3
        row: 5 coll: 18, type:semicolon, value:;
        row: 6 coll: 9, type:keyword, value:else
        row: 7 coll: 13, type:identifier, value:a
        row: 7 coll: 15, type:equal, value:=
        row: 7 coll: 17, type:int, value:4
        row: 7 coll: 18, type:semicolon, value:;
        row: 9 coll: 5, type:keyword, value:return
        row: 9 coll: 12, type:identifier, value:a
        row: 9 coll: 13, type:semicolon, value:;
        row: 10 coll: 1, type:rightCurlyBrace, value:}\n
        """)
    }
    
    func performWithFile(name: String) -> String {
        let input = FileHandle(forReadingAtPath: filePath + name)
        let tokenizer = Tokenizer(file: input!)
        var output = ""
        while let token = tokenizer.next() {
            if token.value != "" {
                output = output + "row: \(token.row) coll: \(token.col), type:\(token.type), value:\(token.value)\n"
            }
        }
        
        return output
    }
}

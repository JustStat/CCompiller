//
//  main.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

//if CommandLine.arguments.count < 2 {
//    print("No file path in arguments")
//    exit(1)
//}
let filePath = "/Users/kirillvarlamov/Documents/Учеба/4 курс зима/Компиль/CCompiller/build/Debug/input.swift" //CommandLine.arguments[1]
if !FileManager.default.fileExists(atPath: filePath) {
    print("File not found at: \(filePath)")
    exit(1)
}

guard let input = FileHandle(forReadingAtPath: filePath) else {
    print("Can't get data from file at \(filePath)! Check permissions and try again!")
    exit(1)
}

let tokenizer = Tokenizer(file: input)
while let token = tokenizer.next() {
    if token.source != "" {
        print("row: \(token.row) coll: \(token.col), type:\(token.type), source:\(token.source)")
    }
}




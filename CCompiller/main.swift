//
//  main.swift
//  CCompiller
//
//  Created by Kirill Varlamov on 15/10/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import Foundation

let filePath = CommandLine.arguments[1]
if !FileManager.default.fileExists(atPath: filePath) {
    print("File not found at: \(filePath)")
    exit(1)
}

guard let input = FileHandle(forReadingAtPath: filePath) else {
    print("Can't get data from file at \(filePath)! Check permissions and try again!")
    exit(1)
}

while true {
    let data = input.readData(ofLength: 1)
    if data.isEmpty {
        break
    }
}




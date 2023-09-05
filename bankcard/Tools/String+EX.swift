//
//  String+EX.swift
//  bankcard
//
//  Created by rosua le on 2023/9/4.
//

import Foundation

extension String{
    func bankNumberString() -> String {
        let str = "110011001100" + self
        var result = ""
        for (index, character) in str.enumerated() {
            result.append(character)
            if index % 4 == 3 {
                result.append("  ")
            }
        }
        return result
    }
}

//
//  SourceParser.swift
//  avby2
//
//  Created by Sergey Garbalinskiy on 3/8/17.
//
//

import Foundation

public protocol SourceParser {
    var host: String { get }
    func parse(targetURL: URL, completionHandler: @escaping ([COAd]) -> ())
}

extension SourceParser {
    
    func cleanupNumber(value: String) -> Float {
        let range = value.startIndex ..< value.endIndex
        return Float(value.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression, range: range)) ?? 0
    }
    
    func cleanupString(value: String) -> String {
        var result = value.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: value.startIndex ..< value.endIndex)
        result = result.trimmingCharacters(in: [" "])
        return result
    }
}

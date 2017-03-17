//
//  COEngine.sources.swift
//  avby2
//
//  Created by Sergey Garbalinskiy on 3/8/17.
//
//

import Foundation

// Part of class that read urls from source file
extension COEngine {
    var targetsFileURL: URL {
        return URL(fileURLWithPath: COConstants.targetsPath)
    }
    
    // Read source file and returns array of lines
    private func readTargetsFile() -> [String]? {
        var text = ""
        
        do {
            text = try String(contentsOf: targetsFileURL)
        } catch {
            return nil
        }
        
        var lines:[String] = []
        
        for line in text.characters.split(separator: "\n") {
            lines.append(String(line))
        }
        
        return lines
    }
    
    var targets:[URL] {
        var urls:[URL] = []
        
        guard let lines = readTargetsFile() else {
            return urls
        }
        
        for line in lines {
            if let urlString = line.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
                urls.append(url)
            }
        }
        
        return urls
    }
}

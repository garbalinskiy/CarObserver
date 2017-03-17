//
//  COLogger.swift
//  avby2
//
//  Created by Sergey Garbalinskiy on 3/8/17.
//
//

import Foundation

public class COLogger {
    
    static let shared = COLogger()
    
    private var ids:Set<Int>
    private var logFilePath = COConstants.logPath
    
    private init() {
        if let jsonData = FileManager.default.contents(atPath: logFilePath) {
            let savedIds = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [Int]
            ids = Set<Int>(savedIds)
        } else {
            ids = []
        }
    }
    
    func contains(_ id: Int) -> Bool {
        return ids.contains(id)
    }
    
    func insert(_ id: Int) {
        ids.insert(id)
    }
    
    func save() {
        let jsonData = try! JSONSerialization.data(withJSONObject: Array(ids), options: [.prettyPrinted])
        let json = String(data: jsonData, encoding: .utf8)!
        do {
            try "\(json)".write(toFile: logFilePath, atomically: true, encoding: .utf8)
        } catch {
            print("Save to file failed")
        }
    }
    
    deinit {
        save()
    }
}

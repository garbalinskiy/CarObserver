//
//  ObserverEngine.swift
//  avby2
//
//  Created by Sergey Garbalinskiy on 3/8/17.
//
//

import Foundation

public class COEngine {
    
    // Host -> Parser
    private(set) var parsers: [String: SourceParser] = [:]
    
    func addParser(_ parser: SourceParser) {
        parsers[parser.host] = parser
    }
    
    func checkout() {
        for targetURL in targets {
            if let host = targetURL.host, let parser = parsers[host] {
                parser.parse(targetURL: targetURL, completionHandler: self.validateAds)
            }
        }
    }
    
    func validateAds(ads: [COAd]) {
        for ad in ads {
            if COLogger.shared.contains(ad.id) {
                continue
            }
            
            COMailer.shared.send(ad: ad)
            COLogger.shared.insert(ad.id)
        }
        
        COLogger.shared.save()
    }
}

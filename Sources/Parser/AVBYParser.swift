//
//  AVBYParser.swift
//  avby2
//
//  Created by Sergey Garbalinskiy on 3/8/17.
//
//

import Foundation
import Kanna

class AVBYParser: SourceParser {
    
    var host = "cars.av.by"
    
    func parse(targetURL: URL, completionHandler: @escaping ([COAd]) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: targetURL) { data, response, error in
            guard let data = data else {
                completionHandler([])
                return
            }
            
            guard let markup = String(data: data, encoding: .utf8) else {
                completionHandler([])
                return
            }
            
            completionHandler(self.parse(markup: markup))
        }
        
        dataTask.resume()
        
    }
    
    func parse(markup: String) -> [COAd] {
        var collection:[COAd] = []
        
        guard let doc = HTML(html: markup, encoding: .utf8) else {
            return collection
        }
        
        for node in doc.css(".listing-wrap .listing-item") {
            if let ad = parseAd(htmlNode: node)
            {
                collection.append(ad)
            }
        }
        
        return collection
    }
    
    func parseAd(htmlNode: Kanna.XMLElement) -> COAd? {
        guard let url = htmlNode.css(".listing-item-title a").first?["href"] else {
            return nil
        }
        
        guard let imageUrl = htmlNode.css(".listing-item-image img").first?["src"] else {
            return nil
        }
        
        guard let title = htmlNode.css(".listing-item-title a").first?.text else {
            return nil
        }
        
        guard let description = htmlNode.css(".listing-item-desc").first?.text else {
            return nil
        }
        
        let message = htmlNode.css(".listing-item-message-in").first?.text ?? ""
        
        guard let year = htmlNode.css(".listing-item-price span").first?.text else {
            return nil
        }
        
        guard let priceBYN = htmlNode.css(".listing-item-price strong").first?.text else {
            return nil
        }
        
        guard let priceUSD = htmlNode.css(".listing-item-price small").first?.text else {
            return nil
        }
        
        guard let location = htmlNode.css(".listing-item-location").first?.text else {
            return nil
        }
        
        guard let id = extractId(from: url) else {
            return nil
        }
        
        return COAd(id: id,
                     imageUrl: imageUrl,
                     url: cleanupString(value: url),
                     title: cleanupString(value: title),
                     description: cleanupString(value: description),
                     message: cleanupString(value: message),
                     year: Int(cleanupNumber(value: year)),
                     priceBYN: Int(cleanupNumber(value: priceBYN)),
                     priceUSD: Int(cleanupNumber(value: priceUSD)),
                     location: cleanupString(value: location))
    }
    
    func extractId(from url: String) -> Int? {
        let nsUrl = url as NSString
        let pattern = ".*/(\\d+)$"
        var id:Int?
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: [])
            if let match = regularExpression.matches(in: url, options: [], range: NSMakeRange(0, url.characters.count)).first {
                id = Int(nsUrl.substring(with: match.rangeAt(1)))
            }
        } catch {
            return nil
        }
        
        return id
    }
}

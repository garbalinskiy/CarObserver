//
//  COMailer.swift
//  avby2
//
//  Created by Sergey Garbalinskiy on 3/17/17.
//
//

import Foundation

class COMailer {
    
    public static let shared = COMailer()
    
    lazy var template: String = {
        return try! String(contentsOfFile: COConstants.emailTemplatePath , encoding: .utf8)
    }()
    
    func getEmailBody(ad: COAd) -> String {
        var body = template
        
        let placeholders = [
            "%id%" : "\(ad.id)",
            "%imageUrl%" : ad.imageUrl,
            "%url%" : ad.url,
            "%title%" : ad.title,
            "%description%" : ad.description,
            "%message%" : ad.message,
            "%year%" : "\(ad.year)",
            "%priceBYN%" : "\(ad.priceBYN)",
            "%priceUSD%" : "\(ad.priceUSD)",
            "%location%" : ad.location
        ]
        
        for (placeholder, value) in placeholders {
            body = body.replacingOccurrences(of: placeholder, with: value)
        }
        
        return body
    }
    
    func send(ad: COAd) {
        
        let test:[String:Any] = [
            "key": MandrillConstants.key,
            "message": [
                "html": getEmailBody(ad: ad),
                "subject": ad.title + " / " + ad.description,
                "from_name": MandrillConstants.fromName,
                "from_email": MandrillConstants.fromEmail,
                "to": [
                    [
                        "email": MandrillConstants.toEmail,
                        "name": MandrillConstants.toName,
                        "type": "to"
                    ]
                ]
            ]
        ]
        
        let requestUrl = URL(string: "https://mandrillapp.com/api/1.0/messages/send.json")!
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: test, options: [])
        
        DispatchQueue(label: "COMailer").async {
            let urlTask = URLSession.shared.dataTask(with: request) { data, response, error in
                print(response)
            }
            
            urlTask.resume()
        }
    }
}

//
//  Scraper.swift
//  App Store Buddy
//
//  Created by Yusif Aliyev on 27.08.23.
//

import Foundation
import SwiftSoup

class AppStoreScraper {
    
    private static let baseUrl = "https://apps.apple.com"
    
    static func scrape(appId: String, completion: @escaping (AppInfo) -> ()) {
        let urlPath = "\(baseUrl)/app/\(appId)"
        
        guard let url = URL(string: urlPath) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let htmlString = String(data: data, encoding: .utf8) else { return }
            
            let appTitle = (extractTextFromHTML(html: htmlString, tagName: "title", className: nil) ?? "").replacingOccurrences(of: " on the App Store", with: "")
            
            let appTagline = (extractTextFromHTML(html: htmlString, tagName: "h2", className: "product-header__subtitle") ?? "")
            
            let appPrice = extractTextFromHTML(html: htmlString, tagName: "li", className: "inline-list__item--bulleted")
            
            let appImage = extractAttributeFromHTML(html: htmlString, attributeName: "srcset", tagName: "source", className: nil)?.split(separator: ",").last?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").first
            
            let appRating = extractTextFromHTML(html: htmlString, tagName: "figcaption", className: "we-rating-count")
            
            let appInfo = AppInfo(title: appTitle, tagline: appTagline, price: appPrice, image: appImage, rating: appRating)
            
            completion(appInfo)
        }.resume()
        
    }
    
    static private func extractTextFromHTML(html: String, tagName: String, className: String?) -> String? {
        do {
            let doc = try SwiftSoup.parse(html)
            
            var query = tagName
            
            if let className = className {
                query = query + "." + className
            }
            
            if let element = try doc.select(query).first() {
                return try element.text()
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        return nil
    }
    
    static private func extractAttributeFromHTML(html: String, attributeName: String, tagName: String, className: String?) -> String? {
        do {
            let doc = try SwiftSoup.parse(html)
            
            var query = tagName
            
            if let className = className {
                query = query + "." + className
            }
            
            if let element = try doc.select(query).first() {
                return try element.attr(attributeName)
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        return nil
    }
    
}

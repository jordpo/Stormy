//
//  NetworkOperation.swift
//  Stormy
//
//  Created by Jordan Morano on 9/20/15.
//  Copyright © 2015 Jordan Morano. All rights reserved.
//

import Foundation

class NetworkOperation {
    // lazy loading only var properties
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    let queryUrl: NSURL
    
    typealias JSONDictionaryCompletition = ([String: AnyObject]?) -> Void
    
    init(url: NSURL) {
        self.queryUrl = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletition) {
        let request: NSURLRequest = NSURLRequest(URL: queryUrl)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            // 1 check HTTP response that is successful
            if let httpResponse = response as? NSHTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    // 2 create JSON object with data
                    // you need to use a do catch block to handle the error
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String: AnyObject]
                        completion(jsonDictionary)
                    } catch {
                        print(error)
                    }
                default:
                    print("not successful- HTTP status code of \(httpResponse.statusCode)")
                }
            } else {
                print("Error: not a valid HTTP response")
            }
        }
        
        dataTask.resume()
    }
}
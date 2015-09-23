//
//  NetworkOperation.swift
//  WeatherApp
//
//  Created by Wilhelm Michaelsen on 2015-07-30.
//  Copyright (c) 2015 Wilhelm Michaelsen. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    // Properies
    lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    // Typealias. downloadJSONFromURL callback closure signature. Takes dictionary String:id as single argument and returns Void
    typealias JSONDictionaryCompletion = (([String: AnyObject]?, status: Int, error: NSError?) -> Void)
    
    // Designated init method
    init(url: NSURL) {
        queryURL = url
    }
    
    // Download function. Takes a closure (with string:id dictionary as argument) that returns Void as single argument
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        
        // Does the actual request (trailing completion closure)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in // Values passed in by dataTaskWithRequest function
                        
            // Check response if any
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch httpResponse.statusCode {
                // Status everything fine
                case 200:
                    // Converts data type passed in by dataTaskWithRequest to Dictionary
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    
                    // Callback to completion closure (JSONDictionaryCompletion) passing fetched json in Dictionary
                    completion(jsonDictionary, status: 200, error: error)
                // Status bad coordinates
                case 400:
                    completion(nil, status: 400, error: error)
                    
                default:
                    println("Error: GET failed")
                }
                
            } else {
                println("Error: Invalid HTTP response")
            }
        }
        
        // Perform request task
        dataTask.resume()
        
    }
}
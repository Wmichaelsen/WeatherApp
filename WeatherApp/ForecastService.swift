//
//  ForecastService.swift
//  WeatherApp
//
//  Created by Wilhelm Michaelsen on 2015-08-06.
//  Copyright (c) 2015 Wilhelm Michaelsen. All rights reserved.
//

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init(apiKey: String) {
        forecastAPIKey = apiKey
        forecastBaseURL = NSURL(string: "http://api.openweathermap.org/data/2.5/")
        //forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    // Main method for getting the forecast by coordinates
    func getForecast(lat: Double, long: Double, completion: ((CurrentWeather?, status: Int, error: NSError?) -> Void)) {
        
        // Construct final url and check its validity
        if let forecastURL = NSURL(string: "weather?lat=\(lat)&lon=\(long)", relativeToURL: forecastBaseURL) {
            
            // Object of NetworkOperation class with constructed URL
            let networkOperation = NetworkOperation(url: forecastURL)
            
            // Download weather dictionary from constructed url (trailing closure)
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary, let status, let error) in              // Dictionary result from the web request
                                
                // Converts data from JSON to CurrentWeather (own class) dictionary
                let currentWeather = self.currentWeatherFromJSON(JSONDictionary)
                
                completion(currentWeather, status: status, error: error)
            }
            
        } else {
            println("Could not construct valid URL")
            completion(nil, status: 0, error: NSError(domain: "badURL", code: 2, userInfo: ["description" : "2"]))
        }
    }
    
    // Main method for getting the forecase by city name
    func getForecast(cityName: String, completion: ((CurrentWeather?, status: Int, error: NSError?) -> Void)) {
        
        // Construct url and check its validity
        if let forecastURL = NSURL(string: "weather?q=\(cityName)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, relativeToURL: forecastBaseURL) {
            
            // Object of NetworkOperation class with constructed URL
            let networkOperation = NetworkOperation(url: forecastURL)
            
            // Download weather dictionary from constructed url (trailing closure)
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary, let status, let error) in              // Dictionary result from the web request
                
                // Converts data from JSON to CurrentWeather (own class) dictionary
                let currentWeather = self.currentWeatherFromJSON(JSONDictionary)

                completion(currentWeather, status: status, error: error)
            }
        } else {
            println("Could not construct valid URL")
            completion(nil, status: 0, error: NSError(domain: "badURL", code: 2, userInfo: ["description" : "2"]))
        }
        
    }
    
    // Private helper method to parse retrieved weather dictionary
    private func currentWeatherFromJSON(jsonDictionary: [String: AnyObject]?) -> CurrentWeather? {
        
        // Return populated CurrentWeather class if dictionary passed in not is nil
        if let currentWeatherDictionary = jsonDictionary?["main"] as? [String: AnyObject] {
           return CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
        } else {
            println("Dictionary returned nil for main key")
            return nil
        }
    }
}
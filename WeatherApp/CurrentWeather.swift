//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Wilhelm Michaelsen on 2015-07-30.
//  Copyright (c) 2015 Wilhelm Michaelsen. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let temperature: Int
    let humidity: Int
    let pressure: Int
    let temp_min: Int
    let temp_max: Int
    //let precipProbability: Int
    //let summary: String
    
    
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temp"] as! Int
        humidity = weatherDictionary["humidity"] as! Int
        pressure = weatherDictionary["pressure"] as! Int
        temp_min = weatherDictionary["temp_min"] as! Int
        temp_max = weatherDictionary["temp_max"] as! Int
        
        //let precipFloat = weatherDictionary["precipProbability"] as! Double
        //precipProbability = Int(precipFloat * 100)
        //summary = weatherDictionary["summary"] as! String
    }
}
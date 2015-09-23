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
    //let precipProbability: Int
    //let summary: String
    
    
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temp"] as! Int
        let humidityFloat = weatherDictionary["humidity"] as! Double
        humidity = Int(humidityFloat * 100)
        //let precipFloat = weatherDictionary["precipProbability"] as! Double
        //precipProbability = Int(precipFloat * 100)
        //summary = weatherDictionary["summary"] as! String
    }
}
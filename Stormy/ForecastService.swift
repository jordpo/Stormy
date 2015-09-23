//
//  ForecastService.swift
//  Stormy
//
//  Created by Jordan Morano on 9/21/15.
//  Copyright © 2015 Jordan Morano. All rights reserved.
//

import Foundation

struct ForecastService {
    let forecastAPIKey: String
    let forecastBaseURL: NSURL? // store in an optional type without downcasting
    
    init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(lat: Double, long: Double, completion: (CurrentWeather? -> Void)) {
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL) {
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let currentWeather = self.currentWeatherFromJSON(JSONDictionary)
                
                completion(currentWeather)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func currentWeatherFromJSON(jsonDictionary: [String: AnyObject]?) -> CurrentWeather? {
        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String: AnyObject] {
            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
        } else {
            print("JSON dictionary returned nil for currently")
            return nil
        }
    }
}
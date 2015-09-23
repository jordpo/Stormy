//
//  ViewController.swift
//  Stormy
//
//  Created by Jordan Morano on 9/18/15.
//  Copyright © 2015 Jordan Morano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // standard optional - must use optional chaining in our code
    @IBOutlet weak var currentTempLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentWeatherLocation: UILabel?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    
    // private - access control only allows this to be accessible within this class when it is initialized
    private let forecastAPIKey = ""
    let BTV: (lat: Double, long: Double) = (lat: 44.4758, long: 44.4758) // named tuple

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveWeatherForecast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func retrieveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        
        forecastService.getForecast(BTV.lat, long: BTV.long) {
            (let currently) in
            if let currentWeather = currently {
                // Update UI - submits a closure to the main queue
                dispatch_async(dispatch_get_main_queue()) {
                    // will execute on the main thread from the background thread
                    
                    if let temperature = currentWeather.temperature {
                        self.currentTempLabel?.text = "\(temperature)º"
                    }
                    
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                    }
                    
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    
                    self.toggleRefreshAnimation(false)
                }
            }
        }

    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    @IBAction func refreshWeather() {
        toggleRefreshAnimation(true)
        retrieveWeatherForecast()
    }
    
}


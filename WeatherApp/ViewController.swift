//
//  ViewController.swift
//  WeatherApp
//
//  Created by Wilhelm Michaelsen on 2015-07-30.
//  Copyright (c) 2015 Wilhelm Michaelsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // IB Properties
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var rainLabel: UILabel?
    @IBOutlet weak var latInput: UITextField!
    @IBOutlet weak var lngInput: UITextField!
    
    // Properties
    let forecastService = ForecastService(apiKey: "a45693d7bd4dd291e8d339b92f17bbc8")
    var lat: Double = 0.0
    var lng: Double = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        latInput.delegate = self
        lngInput.delegate = self
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func getForecastAction(sender: AnyObject) {
        
        // Loading symbol - start when coordinates are submitted and quit when data is received
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.frame.size.width/2)-30, (self.view.frame.size.height/2)-30, 60, 60))
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // Dismiss keyboard
        self.view.endEditing(true)
        
        // Validates user input
        if latInput.text != "" && lngInput.text != "" {
            
            // Get forecast for lat and long. Forecast dictionary comes in currentWeather (closure)
            forecastService.getForecast(lat,long: lng) {
                (let currentWeather, let status, let error) in
                
                // Perform on Main Thread
                dispatch_async(dispatch_get_main_queue()) {
                    
                    // Stop loading symbol
                    activityIndicator.stopAnimating()
                    
                    // Status everythings fine
                    if status == 200 {
                        
                        if let weatherDictionary = currentWeather as CurrentWeather? {
                            println(currentWeather!.temperature)
                            self.updateLabels(currentWeather!.temperature, hum: currentWeather!.humidity, prec: 0)
                        } else {
                            if let errorMessage = error as NSError? {
                                self.alertUser("Oops", message: "Couldn't find location. Error message: \(errorMessage.description)")
                            } else {
                                self.alertUser("Oops", message: "Couldn't find location. Error code: 1")
                            }
                            
                        }
                    }
                    
                        
                    // Status bad coordinates
                    else if status == 400 {
                        
                        // Alert user
                        self.alertUser("Oops", message: "Seems like you entered nonvalid coordinates")
                    }
                }
            }
        }
        else {
            
            // Stop loading symbol
            activityIndicator.stopAnimating()
            
            // Alert user
            self.alertUser("Oops", message: "Seems like you didn't enter any coordinates")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    // MARK: Private helper methods
    
    private func updateLabels(temp: Int, hum: Int, prec: Int) {
        temperatureLabel!.text = "\(temp-272)°C"
        humidityLabel!.text = "\(hum)%"
        rainLabel!.text = "\(prec)%"
    }
    
    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: UITextField Delegate methods
    
    @IBAction func latChanged(sender: AnyObject) {
        lat = NSString(string: latInput.text).doubleValue
    }
    
    @IBAction func lngChanged(sender: AnyObject) {
        lng = NSString(string: lngInput.text).doubleValue
    }
}

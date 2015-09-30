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
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var min_tempLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    // Properties
    let forecastService = ForecastService(apiKey: "a45693d7bd4dd291e8d339b92f17bbc8")
    var lat: Double = 0.0
    var lng: Double = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        latInput.delegate = self
        
        scrollView!.contentSize = CGSizeMake(self.view.frame.size.width, 2000.0)
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
        if latInput.text != "" {
            
            // Get forecast for lat and long. Forecast dictionary comes in currentWeather (closure)
            forecastService.getForecast(latInput!.text) {
                (let currentWeather, let status, let error) in
                
                // Perform on Main Thread
                dispatch_async(dispatch_get_main_queue()) {
                    
                    // Stop loading symbol
                    activityIndicator.stopAnimating()
                    
                    // Status everythings fine
                    if status == 200 {
                        
                
                        // If CurrentWeather passed in is not nil
                        if let weatherDictionary = currentWeather as CurrentWeather? {
                            
                            // Update labels
                            self.updateLabels(currentWeather!.temperature, hum: currentWeather!.humidity, prec: 0, pressure: currentWeather!.pressure, temp_min: currentWeather!.temp_min)
                            
                            // Scroll user to results
                            self.scrollView!.setContentOffset(CGPointMake(0.0, self.view.frame.size.height), animated: true)
                            
                        } else {
                            if let errorMessage = error as NSError? {
                                self.alertUser("Oops", message: "Couldn't find location. Error message: \(errorMessage.description)")
                            } else {
                                self.alertUser("Oops", message: "Couldn't find location. Error code: 1")
                            }
                            
                        }
                    } else {
                        
                        // Alert user
                        self.alertUser("Oops", message: "HTTP response error code: \(status)")
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
    
    private func updateLabels(temp: Int, hum: Int, prec: Int, pressure: Int, temp_min: Int) {
        temperatureLabel!.text = "\(temp-273)°C"
        humidityLabel!.text = "\(hum)"
        rainLabel!.text = "\(prec)"
        pressureLabel!.text = "\(pressure)"
        min_tempLabel!.text = "\(temp_min-273)"
        
    }
    
    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: IBActions
    
    @IBAction func latChanged(sender: AnyObject) {
        lat = NSString(string: latInput.text).doubleValue
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        scrollView!.setContentOffset(CGPointMake(0.0, 0.0), animated:true)
    }
    
    
}

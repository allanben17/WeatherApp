//
//  ViewController.swift
//  Weather App
//
//  Created by Tianyi Ben on 2016-01-14.
//  Copyright © 2016 Tianyi Ben. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var weatherLabel: UILabel!
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        var isSuccess = false
        
        if cityTextField.text != "" {
            
            weatherLabel.text?.removeAll()
            weatherLabel.textColor = UIColor.blackColor()
            
            var city = cityTextField.text!
            city = city.stringByReplacingOccurrencesOfString(" ", withString: "-")
            
            let address = "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest"
            
            if let url = NSURL(string: address) {
                
                let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                    
                    if let urlContent = data {
                        
                        let weatherContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)!
                        
                        var weatherArray = weatherContent.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                        
                        if weatherArray.count > 1 {
                            
                            if var weatherString = weatherArray[1].componentsSeparatedByString("</span>").first {
                                
                                weatherString = weatherString.stringByReplacingOccurrencesOfString("&deg;C", withString: "ºC")
                                
                                isSuccess = true
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.weatherLabel.text = String(weatherString)
                                    
                                })
                            }
                        }
                    }
                    
                    if !isSuccess {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.weatherLabel.text = "Sorry. Cannot find such city. Please check the city you entered is correct."
                            self.weatherLabel.textColor = UIColor.redColor()
                        })

                    }
                    
                })
                
                task.resume()
            } else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.weatherLabel.text = "Sorry. Cannot find such city. Please check the city you entered is correct."
                    self.weatherLabel.textColor = UIColor.redColor()
                    
                })
                
            }
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


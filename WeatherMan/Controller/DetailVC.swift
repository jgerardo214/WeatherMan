//
//  DetailVC.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 9/30/21.
//

import Foundation
import UIKit

class DetailVC: UIViewController, WeatherManagerDel {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // write code to update weather
        
    }
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var weathermanager = WeatherManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weathermanager.delegate = self
        
        
    }
    
    
    
    func didUpdateWeather(weather: WeatherModel) {
        tempLabel.text = weather.tempString
        
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // write function to save the city to core data and add it to the Saved Cities VC
        
    }
    
    
    
}

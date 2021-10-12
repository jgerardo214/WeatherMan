//
//  WeatherVC.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 9/30/21.
//

import Foundation
import UIKit
import CoreLocation

class WeatherVC: UIViewController, UITextFieldDelegate, WeatherManagerDel {
    

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var saveButtpn: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var city = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        weatherManager.delegate = self
    }
    
    
    @IBAction func locationButtonPressed(_ sender: Any) {
       
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        // set it up so that search button will bring DetailVC
        searchText.endEditing(true)
        
        
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchText.text != "" {
            return true
        } else {
            textField.placeholder = "Enter city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use search text.text to get weather for city
        if let city = searchText.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchText.text = ""
    }
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.tempString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.city
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    
    
}

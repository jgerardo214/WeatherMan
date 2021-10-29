//
//  WeatherVC.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 9/30/21.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class WeatherVC: UIViewController, NSFetchedResultsControllerDelegate {
    

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var saveButtpn: UIButton!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var dataController: DataController!
    var cities: String = ""
    var fetchedResultsController:NSFetchedResultsController<City>!
    var city: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self

        
    }
    
    func setUpFetchResultsController() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "cityName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "city")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count == 0 {
                print("No city found!")
            } else {
                var cities = fetchedResultsController.fetchedObjects!
                for city in cities {
                    cities.append(city)
                }
                
                
            }
        } catch {
            fatalError("The fetch could not be performed because of \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let city = City(context: dataController.viewContext)
        city.cityName = "\(city)"
        try! dataController.viewContext.save()
        
    }
    

    
}

// MARK: - UITextFieldDelegate

extension WeatherVC: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: Any) {
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

    
}

// MARK: - WeatherManagerDelegate

extension WeatherVC: WeatherManagerDel {
    
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
    
}

// MARK: - CLLocationMangerDelegate

extension WeatherVC: CLLocationManagerDelegate {
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        locationManager.requestLocation()
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error)
    }
    
    
    
}



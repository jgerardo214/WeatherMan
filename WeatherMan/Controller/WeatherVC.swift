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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<City>!
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        activityIndicator.isHidden = true
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
        city.cityName = cityLabel.text
        city.temperature = tempLabel.text
        try? dataController.viewContext.save()
    }
}

// MARK: - UITextFieldDelegate

extension WeatherVC: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchText.endEditing(true)
        activityIndicator.hidesWhenStopped = true
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
       
    }
    
    
}

// MARK: - WeatherManagerDelegate

extension WeatherVC: WeatherManagerDel {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            self.tempLabel.text = weather.tempString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.city
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true 
        }
    }
    
    func didFailWithError(error: Error) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Enter a valid city!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print(error.localizedDescription)
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
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "Error", message: "Network failure! Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            print(error)
//        }
       
    
    }
    
}








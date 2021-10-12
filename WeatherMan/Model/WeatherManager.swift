//
//  OpenWeatherClient.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 10/1/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDel {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a51a075fe97539350b7ea0972ed37d36&units=imperial"
    
    var delegate: WeatherManagerDel?
    
    func fetchWeather(cityName: String) {
        let urlStringWithCityName = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlStringWithCityName)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlStringWithCLLocation = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlStringWithCLLocation)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    
                    }
                }
            }
            task.resume()
        }
        
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name            
            let weather = WeatherModel(conditionId: id, city: name, temp: temp)
            return weather
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            
        }
        return nil
    }
    
    
}

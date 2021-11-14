//
//  CityCell.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 10/12/21.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func insertData(model: City) {
        if let unwrappedCityName = model.cityName {
            cityLabel.text = model.cityName
        }
       
        tempLabel.text = "\(model.temperature)"
        
    }
    
}

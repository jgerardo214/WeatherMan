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
        if cityLabel.text != nil {
            cityLabel.text = model.cityName
        }
        
        if tempLabel.text != nil {
            tempLabel.text = model.temperature
        }
        
    }
    
}

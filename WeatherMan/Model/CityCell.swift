//
//  CityCell.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 10/12/21.
//

import UIKit

class CityCell: UITableViewCell {
    
    
    @IBOutlet weak var cityNameCell: UILabel!
    
    func insertData(model: City) {
        cityNameCell.text = model.cityName
    }
    
    
    
}

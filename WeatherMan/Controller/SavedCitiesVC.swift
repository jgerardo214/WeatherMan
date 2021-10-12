//
//  SavedCitiesVC.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 10/9/21.
//

import Foundation
import UIKit

class SavedCitiesVC: UITableViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when city is selected it will trigger the DetailVC segue which will show the detailed view of the weather in said city
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    
    
}

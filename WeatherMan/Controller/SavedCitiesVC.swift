//
//  SavedCitiesVC.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 10/9/21.
//

import Foundation
import UIKit
import CoreData

class SavedCitiesVC: UITableViewController, NSFetchedResultsControllerDelegate  {
    
    var weatherManager = WeatherManager()
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<City>!
    var city: City!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        if let city = city {
            let predicate = NSPredicate(format: "city == %@", city)
            fetchRequest.predicate = predicate
        }
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        fetchCityInfo()
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherVC = storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC
        weatherVC?.city = fetchedResultsController.object(at: indexPath).cityName
        weatherVC?.city = fetchedResultsController.object(at: indexPath).temperature
        self.navigationController?.pushViewController(weatherVC!, animated: true)
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        cell.insertData(model: fetchedResultsController.object(at: indexPath))
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCityInfo()
    }
    
    func fetchCityInfo() {
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         print("\(fetchedResultsController.object(at: indexPath))")
          dataController.deleteCity(city: fetchedResultsController.object(at: indexPath))
             fetchCityInfo()

        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

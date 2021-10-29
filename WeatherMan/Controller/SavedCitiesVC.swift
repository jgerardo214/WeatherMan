//
//  SavedCitiesVC.swift
//  WeatherMan
//
//  Created by Jonathan Gerardo on 10/9/21.
//

import Foundation
import UIKit
import CoreData

class SavedCitiesVC: UIViewController, NSFetchedResultsControllerDelegate  {
    
    var weatherManager = WeatherManager()
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<City>!
    var city: City!
    
    func setUpFetchResultsController() {
        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        if let city = city {
            let predicate = NSPredicate(format: "city == %@", city)
            fetchRequest.predicate = predicate
        }
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpFetchResultsController()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherVC = storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC
        weatherVC?.city = fetchedResultsController.object(at: indexPath).cityName!
        self.navigationController?.pushViewController(weatherVC!, animated: true)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityCell
        cell.insertData(model: fetchedResultsController.object(at: indexPath))
        return cell
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    
   
    
    
    
}

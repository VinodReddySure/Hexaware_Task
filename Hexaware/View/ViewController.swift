//
//  ViewController.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 05/01/21.
//  Copyright © 2020 Vinod Reddy Sure. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HomeController: UIViewController {

    let locationManager = CLLocationManager()

    @IBOutlet weak var listTable: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    var knownCities = [KnownCities(cityName: "Chennai", countryName: "India"),
                       KnownCities(cityName: "Hyderabad", countryName: "India"),
                       KnownCities(cityName: "Bangalore", countryName: "India"),
                       KnownCities(cityName: "Pune", countryName: "India"),
                       KnownCities(cityName: "Mumbai", countryName: "India"),
                       KnownCities(cityName: "Delhi", countryName: "India"),
                       KnownCities(cityName: "Kolkata", countryName: "India")]
    
    var searchKnownCities = [KnownCities]()
    
    var bookMarkedCities = [KnownCities]()
    var searchBookMarkCities = [KnownCities]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        retrieveData()
    }
}

extension HomeController {
    
    func initialLoads() {
        
        requestLocationAccess()
        locationManager.delegate = self
 
        self.listTable.register(UINib(nibName: "CitiesTableViewCell", bundle: .main), forCellReuseIdentifier: "CitiesTableViewCell")
        self.navigationController?.isNavigationBarHidden = false

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addCity))]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        listTable.tableHeaderView = searchController.searchBar
        listTable.tableFooterView = UIView()
        retrieveData()
        
    }
    
    @IBAction func addCity() {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        vc.onTapSave = {
            self.retrieveData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func retrieveData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
        let managedContext = appDelegate.persistentContainer.viewContext
                
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarkedCities")
                
        do {
            let result = try managedContext.fetch(fetchRequest)
            self.bookMarkedCities.removeAll()
            for data in result as! [NSManagedObject] {
                print()
                bookMarkedCities.append(KnownCities(cityName: data.value(forKey: "cityName") as? String, countryName: data.value(forKey: "countryName") as? String))
            }
            
            self.listTable.reloadData()

        } catch {
            
            print("Failed")
        }

    }

    func deleteData(selectedData : KnownCities?){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarkedCities")
        fetchRequest.predicate = NSPredicate(format: "cityName = %@", selectedData?.cityName ?? "")
       
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                self.retrieveData()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }


    //  MARK:- Swipe Action
    @available(iOS 11.0, *)
    private func swipeAction(at indexPath : IndexPath) -> UISwipeActionsConfiguration?{
        
        guard indexPath.section == 1 else { return nil}
        
        let entity = searchController.isActive ? self.searchBookMarkCities[indexPath.row] : self.bookMarkedCities[indexPath.row]
        
        let contextAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            let alert = UIAlertController(title: entity.cityName, message: "Are you sure", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "remove", style: .destructive, handler: { (_) in
                bool(true)
                self.deleteData(selectedData : entity)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                bool(true)
            }))
            alert.view.tintColor = .red
            self.present(alert, animated: true, completion: nil)
        }
        contextAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [contextAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration

    }

}

extension HomeController : UISearchBarDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = "\(searchController.searchBar.searchTextField.text ?? "")"
//        guard text.count > 0 else {
//            return
//        }
        self.searchKnownCities = knownCities.filter {(($0.cityName?.contains(text))!)}
        self.searchBookMarkCities = bookMarkedCities.filter {(($0.cityName?.contains(text))!)}
        self.listTable.reloadData()
    }
    
    
}

extension HomeController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCurrentLatitude = locations.first?.coordinate.latitude
        userCurrentLongitude = locations.first?.coordinate.longitude
    }
}


extension HomeController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? (self.searchBookMarkCities.count == 0 && self.searchKnownCities.count == 0) ? 0 : 2 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return section == 0 ? self.searchKnownCities.count : self.searchBookMarkCities.count
        }else{
            return section == 0 ? self.knownCities.count : self.bookMarkedCities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as! CitiesTableViewCell
        
        if indexPath.section == 0 {
            
            let entity = searchController.isActive ? self.searchKnownCities[indexPath.row] : self.knownCities[indexPath.row]
            cell.labelCity.text = entity.cityName
            cell.labelCountry.text = entity.countryName
            
            
        }else
        {
            let entity = searchController.isActive ? self.searchBookMarkCities[indexPath.row] : self.bookMarkedCities[indexPath.row]

            cell.labelCity.text = entity.cityName
            cell.labelCountry.text = entity.countryName
            
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Known Cities" : "Bookmarked Cities"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        
        vc.selectedCity = searchController.isActive ? (indexPath.section == 0 ? searchKnownCities[indexPath.row] : searchBookMarkCities[indexPath.row]) : (indexPath.section == 0 ? knownCities[indexPath.row] : bookMarkedCities[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       return self.swipeAction(at: indexPath)
    }
}

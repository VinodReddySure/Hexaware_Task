//
//  LocationSearchTableViewController.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 06/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {

    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension LocationSearchTableViewController {
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        
        var addressString : String?
        if let thoroughfare = selectedItem.thoroughfare {
            addressString = (addressString ?? "") + thoroughfare + ", "
        }
        
        if let locality = selectedItem.locality {
            addressString = (addressString ?? "") + locality + ", "
            print("locality : \(locality)")

        }
        
        if let subLocality = selectedItem.subLocality {
            addressString = (addressString ?? "") + subLocality + ", "
            print("Sub : \(subLocality)")
        }
        
        if let administrativeArea = selectedItem.administrativeArea {
            addressString = (addressString ?? "") + administrativeArea + ", "
            print("administrativeArea : \(administrativeArea)")

        }
        
        if let postalCode = selectedItem.postalCode {
            addressString = (addressString ?? "") + postalCode + ", "
        }
        
        if let country = selectedItem.country {
            addressString = (addressString ?? "") + country
        }
        cell.detailTextLabel?.text = addressString
                return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    

}
extension LocationSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView,
        let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.resultTypes = .address
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
}

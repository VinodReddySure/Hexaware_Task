//
//  MapViewController.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 05/01/21.
//  Copyright © 2020 Vinod Reddy Sure. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView?
    @IBOutlet weak var saveButton: UIButton!
    let locationManager = CLLocationManager()
    var centerAnnotation = MKPointAnnotation()

    var selectedCity : String?
    var selectedCountry : String?

    var resultSearchController:UISearchController? = nil

    var selectedPin:MKPlacemark? = nil
    var onTapSave : (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    

}

extension MapViewController {
    
    func initialLoads() {
        
        mapView?.delegate = self
        let location = CLLocation(latitude: userCurrentLatitude ?? 0.0, longitude: userCurrentLongitude ?? 0.0)
        self.updateLocationOnMap(to: location, with: nil)
        self.saveButton.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier:"LocationSearchTableViewController") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self

    }
    
    func updateLocationOnMap(to location: CLLocation, with title: String?) {
        
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        self.mapView?.addAnnotation(point)

        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)// set coordinate

        let latDelta:CLLocationDegrees = 0.01 // set delta
        let longDelta:CLLocationDegrees = 0.01 // set long

        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)

        self.mapView?.setRegion(region, animated: true)
        centerAnnotation.coordinate = mapView!.centerCoordinate
        self.mapView?.addAnnotation(centerAnnotation)

    }
    
    @IBAction func saveAction(sender:UIButton) {
        
        if sender.titleLabel?.text != "City Not Available" {
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Now let’s create an entity and new user records.
            let userEntity = NSEntityDescription.entity(forEntityName: "BookMarkedCities", in: managedContext)!

            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(selectedCity, forKey: "cityName")
            user.setValue(selectedCountry, forKey: "countryName")

            do {
                try managedContext.save()
               
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self.navigationController?.popViewController(animated: true)
            self.onTapSave?()
        }
    }
    
    

}

extension MapViewController : UISearchBarDelegate {
    
    @IBAction func searchAction(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        print(mapView.region)
        print(mapView.userLocation.coordinate.longitude)
        centerAnnotation.coordinate = mapView.centerCoordinate
        self.mapView?.addAnnotation(centerAnnotation)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: centerAnnotation.coordinate.latitude, longitude: centerAnnotation.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in

                // Place details
                guard let placeMark = placemarks?.first else { return }

                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    print(street)
                }
                // City
                guard let city = placeMark.locality else{
                    self.saveButton.setTitle("City Not Available", for: .normal)

                    print("City Not Available")
                    return
                }
                
                self.selectedCity = city
                
                self.saveButton.setTitle("Save", for: .normal)


                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print(zip)
                }
                // Country
                if let country = placeMark.country {
                    print(country)
                    self.selectedCountry = country
                }
                
        })

    }
    
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView?.removeAnnotations(mapView!.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView?.setRegion(region, animated: true)
    }
}

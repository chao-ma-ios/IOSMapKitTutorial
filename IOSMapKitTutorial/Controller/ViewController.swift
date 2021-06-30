//
//  ViewController.swift
//  IOSMapKitTutorial
//
//  Created by Arthur Knopper on 19/03/2019.
//  Copyright © 2019 Arthur Knopper. All rights reserved.
//

//
//  ViewController.swift
//  IOSMapKitTutorial
//
//  Created by Arthur Knopper on 19/03/2019.
//  Copyright © 2019 Arthur Knopper. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var Sege: UISegmentedControl!
    @IBOutlet weak var tableOfLocations: UITableView!
    private let locationManager = LocationManager()
    var locationsArray = [String]()
    var result: String?
    var selectedUnits: String?
        
    //Set units when value changed
    @IBAction func SegeValueChanged(sender: Any) {
        if Sege.selectedSegmentIndex == 0 {
            selectedUnits = "imperial"
        }
        if Sege.selectedSegmentIndex == 1 {
            selectedUnits = "metric"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init units
        selectedUnits = "imperial"
        
        tableOfLocations.delegate = self
        tableOfLocations.dataSource = self
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            mapView.addGestureRecognizer(longTapGesture)
        
        let location = CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
       
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
      
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
        
            annotation.coordinate = location
        let getLocation: CLLocation =  CLLocation(latitude: location.latitude, longitude: location.longitude)

    
        self.locationManager.getPlace(for: getLocation) { placemark in
                    guard let placemark = placemark else { return }
                    
                    var output = "Our location is:"
                    if let country = placemark.country {
                        output = output + "\n\(country)"
                    }
                    if let state = placemark.administrativeArea {
                        output = output + "\n\(state)"
                    }
                    if let town = placemark.locality {
                        output = output + "\n\(town)"
                    }
                    //self.locationLabel.text = output
                    annotation.title = output
                    annotation.subtitle = placemark.locality
            self.locationsArray.append(placemark.locality!)
            self.tableOfLocations.reloadData()
                }

            self.mapView.addAnnotation(annotation)
        }
    }

    extension ViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
        //Pressing clear button deletes all pins and all elements in the table view cell
        @IBAction func removeData() {
            mapView.removeAnnotations(mapView.annotations)
            self.locationsArray = []
            tableOfLocations.reloadData()
        }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    // - Private
    private let locationManager = CLLocationManager()
    
    
    // - API
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! TableViewCell
        cell.ciudad.text = self.locationsArray[indexPath.row]
        return cell
    }
    
    //pass city and unit info to WeatherViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController
        vc?.nameOfCity = locationsArray[indexPath.row]
        vc?.unitsOfInfo = selectedUnits
        self.navigationController?.pushViewController(vc!, animated: true)
        
        }
    
    //Delete a single pin and cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locationsArray.remove(at: indexPath.row)
            let strVar = self.mapView.annotations[indexPath.row]
            self.tableOfLocations.deleteRows(at: [indexPath], with: .automatic)
            self.mapView.removeAnnotation(strVar)
        }
        self.tableOfLocations.reloadData()
    }

}
extension LocationManager {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

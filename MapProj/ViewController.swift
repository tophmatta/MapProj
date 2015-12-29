//
//  ViewController.swift
//  MapProj
//
//  Created by Toph Matta on 12/20/15.
//  Copyright © 2015 Toph Matta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    
    // Data Labels
    
    @IBOutlet weak var latDataLabel: UILabel!
    @IBOutlet weak var longDataLabel: UILabel!
    @IBOutlet weak var speedDataLabel: UILabel!
    @IBOutlet weak var courseDataLabel: UILabel!
    @IBOutlet weak var altitudeDataLabel: UILabel!
    @IBOutlet weak var nearestAddressDataLabel: UILabel!
    
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let latitude: CLLocationDegrees = 13.745787
        
        let longitude: CLLocationDegrees = 100.530063
        
        let latDelta: CLLocationDegrees = 0.1
        
        let lonDelta: CLLocationDegrees = 0.1
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        annotation.title = "Bangkok"
        
        annotation.subtitle = "One day I'll be here eating delicious foodz"
        
        map.addAnnotation(annotation)
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
    }
    
    func action(gestureRecognizer: UILongPressGestureRecognizer){
        
        print("Gesture recognized")
        
        let touchPoint = gestureRecognizer.locationInView(self.map)
        
        let newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinate
        
        annotation.title = "Bangkok"
        
        annotation.subtitle = "One day I'll be here eating delicious foodz"
        
        self.map.addAnnotation(annotation)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0])
        
        map.showsUserLocation = true

        let userLocation: CLLocation = locations[0]
        
        latDataLabel.text = String(userLocation.coordinate.latitude)
        
        longDataLabel.text = String(userLocation.coordinate.longitude)
        
        speedDataLabel.text = String(userLocation.speed)
        
        courseDataLabel.text = String(userLocation.course)
        
        altitudeDataLabel.text = String(userLocation.altitude)
        
        let latitude = userLocation.coordinate.latitude
        
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.1
        
        let lonDelta: CLLocationDegrees = 0.1
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) -> Void in
            if error != nil{
                print(error)
            }
            else {
                
                if let p = placemarks!.first{
                    
                    var subThoroughfare:String = ""
                    
                    if p.subThoroughfare != nil{
                        
                        subThoroughfare = p.subThoroughfare!
                        
                    }
                    
                    self.nearestAddressDataLabel.text = "\(subThoroughfare) \(p.thoroughfare!) \n \(p.subAdministrativeArea!), \(p.administrativeArea!) \(p.postalCode!)"
                    
                }
                
            }
        }
        
        self.map.setRegion(region, animated: false)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Show data: lat., long., course, speed, alt., hint for nearest address: reverse geocode loc
    
    


}


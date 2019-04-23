//
//  MapViewController.swift
//  FiveThousand
//
//  Created by Burns Proctor on 4/22/19.
//  Copyright © 2019 Burns Proctor. All rights reserved.
//

import Foundation
import SharkORM
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        let saved_locations = getSavedLocations()
        createMapAnnotations(locations: saved_locations)
        
        super.viewDidLoad()
    }
    
    let regionRadius: CLLocationDistance = 20000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        centerMapOnLocation(location: CLLocation(latitude: locValue.latitude, longitude: locValue.longitude))
    }
    
    
    func createMapAnnotations(locations: [Location_DB]) {
        let locations = getSavedLocations()
        for i in 0...(locations.count - 1) {
            let game_details = getGameDetails(id: (locations[i].id?.intValue)!)
            let newPin = MapPin(title: game_details[0].winningPlayerName, subtitle: "\(game_details[0].completedAt) - High Score: \(game_details[0].finalRoundScoreToBeat)", coordinate: CLLocationCoordinate2D(latitude: locations[i].latitude, longitude: locations[i].longitude))
            mapView.addAnnotation(newPin)
        }
    }
    
    func getSavedLocations() -> [Location_DB] {
        let results : SRKResultSet = Location_DB.query().fetch()
        return results as! [Location_DB]
    }
    
    func getGameDetails(id: Int) -> [Game_DB] {
        let results : SRKResultSet = Game_DB.query().where("id = ?", parameters: [id]).fetch()
        return results as! [Game_DB]
    }
}



class MapPin: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}

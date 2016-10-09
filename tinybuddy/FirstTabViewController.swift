//
//  FirstTabViewController.swift
//  swift3
//
//  Created by Yung Kim on 10/8/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//import GoogleMaps

class FirstTabViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem?.title = "TinyBuddy"
        map.delegate = self

        
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        print("blah")
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("here")
        let userLocation = manager.location?.coordinate
         map.region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        manager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var map: MKMapView!
    @IBAction func find(sender: UIButton) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "RV park"
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({
            response, error in
            if error != nil {
                print(error)
            } else if let mapItems = response?.mapItems {
                for place in mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = place.placemark.coordinate
                    annotation.title = place.name
                    self.map.addAnnotation(annotation)
                }
            }
        })
        let newrequest = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/locations")!)
        newrequest.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(newrequest) {
            data, response, error in
            guard error == nil && data != nil else {
                print("error")
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
            }
            
            do {
                let locations = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                self.addCustomLocations(locations as! NSArray)
            } catch {
                
            }
//            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
//            print(responseString)
        }
        task.resume()
    }
    
//    func direction(hospital: Hospital) {
//        
//        let test = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: hospital.latitude, longitude: hospital.longitude), addressDictionary: nil)
//        
//        let mapItem = MKMapItem(placemark: test)
//        
//        mapItem.name = hospital.location
//        
//        //You could also choose: MKLaunchOptionsDirectionsModeWalking
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//        
//        mapItem.openInMapsWithLaunchOptions(launchOptions)
//    }
//    @IBAction func directionButtonPressed(sender: UIButton) {
//        direction(receivedTinyhome!)
//    }

    
    func addCustomLocations(locations: NSArray){
        for location in locations{
            let dict = location as! NSDictionary
            let coordinate = CLLocationCoordinate2D(latitude: dict["latitude"] as! Double, longitude: dict["longitude"] as! Double)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = dict["title"] as! String
            self.map.addAnnotation(annotation)
        }
    }

}


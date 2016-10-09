//
//  SecondTabViewController.swift
//  swift3
//
//  Created by Yung Kim on 10/8/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//import GoogleMaps

class SecondTabViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Parking Spot"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedMap))
        map.addGestureRecognizer(tap)
    }
    
    func pressedMap(sender: AnyObject){
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
        let touchPoint = sender.locationInView(map)
        let locationCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        let source = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinate, addressDictionary: nil))
        map.addAnnotation(annotation)
        
    }
    
    
    @IBAction func submitPressed(sender: UIButton) {
        let title = textField.text
        let longitude = String(map.annotations[0].coordinate.longitude)
        let latitude = String(map.annotations[0].coordinate.latitude)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/locations")!)
        request.HTTPMethod = "POST"
        let postString = "title=" + title! + "&longitude=" + longitude + "&latitude=" + latitude
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            guard error == nil && data != nil else {
                print("error")
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
            }
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


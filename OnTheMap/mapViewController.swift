//
//  mapViewController.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/26/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBAction func postStudent(_ sender: AnyObject) {
        
        //We need to check if a location for this user has been posted yet
        let parameters = ["where":"{\"uniqueKey\":\"\(UDClient.sharedInstance().userID!)\"}" as AnyObject]
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parameters, nil), self)
        print("the post was pressed")
        print(ParseClient.sharedInstance().URLParseMethod(parameters, nil))
    }
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    // The logout action
    @IBAction func logout(_ sender: AnyObject) {
    
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
        UDClient.sharedInstance().logoutPressed = true 
        print("logout was pressed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let navigationController = self.navigationController
        navigationController?.isNavigationBarHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //We create annotations to go on the map
        var annotations = [MKPointAnnotation]()
        //check if we have a myStudent
        if ParseClient.sharedInstance().myStudent != nil{
            //annotations.append((ParseClient.sharedInstance().myStudent?.annotation)!)
            ParseClient.sharedInstance().studentArray.append(ParseClient.sharedInstance().myStudent!)
        }
        //The annotations come from the annotation assigned to each student in the ParseClient student array shared instance
        for students in ParseClient.sharedInstance().studentArray{
            annotations.append(students.annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) {
                app.open( url, options: [String : Any](), completionHandler: nil)
            }
        }
    }
    
    
    
  
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    
    /*func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z" as AnyObject,
                "firstName" : "Jessica" as AnyObject,
                "lastName" : "Uelmen" as AnyObject,
                "latitude" : 28.1461248 as AnyObject,
                "longitude" : -82.75676799999999 as AnyObject,
                "mapString" : "Tarpon Springs, FL" as AnyObject,
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en" as AnyObject,
                "objectId" : "kj18GEaWD8" as AnyObject,
                "uniqueKey" : 872458750 as AnyObject,
                "updatedAt" : "2015-03-09T22:07:09.593Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z" as AnyObject,
                "firstName" : "Gabrielle" as AnyObject,
                "lastName" : "Miller-Messner" as AnyObject,
                "latitude" : 35.1740471 as AnyObject,
                "longitude" : -79.3922539 as AnyObject,
                "mapString" : "Southern Pines, NC" as AnyObject,
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en" as AnyObject,
                "objectId" : "8ZEuHF5uX8" as AnyObject,
                "uniqueKey" : 2256298598 as AnyObject,
                "updatedAt" : "2015-03-11T03:23:49.582Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z" as AnyObject,
                "firstName" : "Jason" as AnyObject,
                "lastName" : "Schatz" as AnyObject,
                "latitude" : 37.7617 as AnyObject,
                "longitude" : -122.4216 as AnyObject,
                "mapString" : "18th and Valencia, San Francisco, CA" as AnyObject,
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29" as AnyObject,
                "objectId" : "hiz0vOTmrL" as AnyObject,
                "uniqueKey" : 2362758535 as AnyObject,
                "updatedAt" : "2015-03-10T17:20:31.828Z" as AnyObject
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z" as AnyObject,
                "firstName" : "Jarrod" as AnyObject,
                "lastName" : "Parkes" as AnyObject,
                "latitude" : 34.73037 as AnyObject,
                "longitude" : -86.58611000000001 as AnyObject,
                "mapString" : "Huntsville, Alabama" as AnyObject,
                "mediaURL" : "https://linkedin.com/in/jarrodparkes" as AnyObject,
                "objectId" : "CDHfAy8sdp" as AnyObject,
                "uniqueKey" : 996618664 as AnyObject,
                "updatedAt" : "2015-03-13T03:37:58.389Z" as AnyObject
            ]
        ]
    }*/
}

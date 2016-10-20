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



class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let navigationController = self.navigationController
        navigationController?.isNavigationBarHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove all the annotations
        mapView.removeAnnotations(mapView.annotations)
        let parametersFor100 = ["limit":100 as AnyObject]
        //obtain the new student array and set it equal to ParseCLient.SharedInstance.studentArray to repopulate the map
        //create a closure to populate the map
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray in
            ParseClient.sharedInstance().studentArray = localStudentArray.map({student($0)})
            var annotations = [MKPointAnnotation]()
            
            
            for students in ParseClient.sharedInstance().studentArray{
                annotations.append(students.annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
        }

        
        /*//We create annotations to go on the map
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
        self.mapView.addAnnotations(annotations)*/
        
    }

    
    
        // The map. See the setup in the Storyboard file. Note particularly that the view controller is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    // The logout action
    @IBAction func logout(_ sender: AnyObject) {
    
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
        UDClient.sharedInstance().logoutPressed = true 
        print("logout was pressed")
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        //remove all the annotations
        mapView.removeAnnotations(mapView.annotations)
        let parametersFor100 = ["limit":100 as AnyObject]
        //obtain the new student array and set it equal to ParseCLient.SharedInstance.studentArray to repopulate the map
        //create a closure to populate the map
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray in
            ParseClient.sharedInstance().studentArray = localStudentArray.map({student($0)})
            var annotations = [MKPointAnnotation]()
            //check if we have a myStudent
            /*if ParseClient.sharedInstance().myStudent != nil{
             //annotations.append((ParseClient.sharedInstance().myStudent?.annotation)!)
             ParseClient.sharedInstance().studentArray.append(ParseClient.sharedInstance().myStudent!)
             }*/
            //The annotations come from the annotation assigned to each student in the ParseClient student array shared instance
            for students in ParseClient.sharedInstance().studentArray{
                annotations.append(students.annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
        }
        

    }
    
    @IBAction func postStudent(_ sender: AnyObject) {
        
        //set the parameters to search students with unique key the same as the user
        let parameters = ["where":"{\"uniqueKey\":\"\(UDClient.sharedInstance().userID!)\"}" as AnyObject]
        // call this method to return an array of type [String: AnyObject] where the uniqueKey is the same as the userId
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parameters, nil)){ localStudentArray in
            //if the localStudentArray.count is more than 0, that means the student was already posted otherwise the student was nonexisting.
            if localStudentArray.count > 0 {
                //we set up MyStudent to be the first student in this aray if exists 
                ParseClient.sharedInstance().myStudent = student(localStudentArray[0])
                let  alertController = UIAlertController(title: "", message: "You have already posted a Student Location", preferredStyle: UIAlertControllerStyle.alert)
                
                performUIUpdatesOnMain {
                    self.present(alertController, animated:true,completion: nil)
                    
                    alertController.addAction(UIAlertAction(title: "Canel", style: .default, handler: { (UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                    }))
                    
                    alertController.addAction(UIAlertAction(title: "Override", style: .default, handler: { (UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                        
                        let navigationPostController = self.storyboard?.instantiateViewController(withIdentifier: "PostingNavigationController")
                        self.present(navigationPostController!, animated: true)
                    }))
                    
                    
                }
            }else{
                performUIUpdatesOnMain {
                    let navigationPostController = self.storyboard?.instantiateViewController(withIdentifier: "PostingNavigationController")
                    self.present(navigationPostController!, animated: true)
                }
                
            }
        
        }
        print("the post was pressed")
        print(ParseClient.sharedInstance().URLParseMethod(parameters, nil))
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

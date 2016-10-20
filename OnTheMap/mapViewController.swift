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
        //create a closure to populate the map from the array of students returned by the method. We also save the student array into the ParseClient shared instance to be used latter. 
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray in
                self.closureToPopulateTheMap(localStudentArray)
        }
        
    }

    
    
        // The map. See the setup in the Storyboard file. Note particularly that the MapViewController is set up as the map view's delegate.
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
            
                self.closureToPopulateTheMap(localStudentArray)
            
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
    
    func closureToPopulateTheMap(_ dictionary:[[String:AnyObject]]){
        ParseClient.sharedInstance().studentArray = dictionary.map({student($0)})
        var annotations = [MKPointAnnotation]()
        
        for students in ParseClient.sharedInstance().studentArray{
            annotations.append(students.annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
}

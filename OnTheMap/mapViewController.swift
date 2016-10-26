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
        let parametersFor100 = ["order":"-updatedAt" as AnyObject,"limit":100 as AnyObject]
        //obtain the new student array and set it equal to ParseCLient.SharedInstance.studentArray to repopulate the map
        //create a closure to populate the map from the array of students returned by the method. We also save the student array into the ParseClient shared instance to be used latter. 
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray, error in
            
            //check if we have connectivity error
            guard (error?.localizedDescription != "The Internet connection appears to be offline.")else{
                self.connectivityAlert(_title: "No internet Connection", "Can not load since there is no internet connectivity, please connect to the internet and try again")
                return
            }
            // check if we have an error of other type
            guard (error == nil) else{
                self.connectivityAlert(_title: "Error", "There was an error \(error?.localizedDescription)")
                print("we do see this")
                return
            }

                self.closureToPopulateTheMap(localStudentArray)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(statusChanged), name: .reachabilityChanged, object: nil)
    }

    func statusChanged(_ selector: Notification){
        internetStatus = (selector.object as! Reachability).currentReachabilityStatus().rawValue
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    func connectivityAlert(_title: String, _ message:String){
        let alertController = UIAlertController()
        alertController.title = title
        alertController.message = message
        let actionAlert = UIAlertAction(title: "OK", style: .default){ (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(actionAlert)
        
        performUIUpdatesOnMain {
            self.present(alertController, animated: true)
        }
        
    }
    
    
        // The map. See the setup in the Storyboard file. Note particularly that the MapViewController is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    // The logout action
    @IBAction func logout(_ sender: AnyObject) {
        if internetStatus! == 0{
            connectivityAlert(_title: "No internet connection", "We can not logout without internet connectivity, please connect to the internet and then logout")
        }else{
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
        UDClient.sharedInstance().logoutPressed = true 
        print("logout was pressed")
        }
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        
      
            //remove all the annotations
            mapView.removeAnnotations(mapView.annotations)
            let parametersFor100 = ["order":"-updatedAt" as AnyObject,"limit":100 as AnyObject]
            //obtain the new student array and set it equal to ParseCLient.SharedInstance.studentArray to repopulate the map
            //create a closure to populate the map
            ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray, error in
                //check if we have connectivity error
                guard (error?.localizedDescription != "The Internet connection appears to be offline.")else{
                    self.connectivityAlert(_title: "No internet Connection", "Can not refresh since there is no internet connectivity, please connect to the internet and try again")
                    return
                }
                // check if we have an error of other type
                guard (error == nil) else{
                    self.connectivityAlert(_title: "Error", "There was an error \(error?.localizedDescription)")
                    print("we do see this")
                    return
                }

                    self.closureToPopulateTheMap(localStudentArray)
            
            }
        

    }
    
    @IBAction func postStudent(_ sender: AnyObject) {
        /*if internetStatus! == 0 {
            connectivityAlert(_title:"No internet", "We can not post since there is no internet connection, please connect to the internet and try again")
        }else*/
        
            //set the parameters to search students with unique key the same as the user
            let parameters = ["where":"{\"uniqueKey\":\"\(UDClient.sharedInstance().userID!)\"}" as AnyObject]
            // call this method to return an array of type [String: AnyObject] where the uniqueKey is the same as the userId
            ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parameters, nil)){ localStudentArray, error in
                
                
                //check if we have connectivity error
                guard (error?.localizedDescription != "The Internet connection appears to be offline.")else{
                 self.connectivityAlert(_title: "No internet Connection", "Can not post since there is no internet connectivity, please connect to the internet and try again")
                 return
                 }
                // check if we have an error of other type
                guard (error == nil) else{
                    self.connectivityAlert(_title: "Error", "There was an error \(error?.localizedDescription)")
                    print("we do see this")
                    return
                }


                //if the localStudentArray.count is more than 0, that means the student was already posted otherwise the student was nonexisting.
                if localStudentArray.count > 0 {
                    //we set up MyStudent to be the first student in this aray if exists
                    StudentModel.sharedInstance().myStudent = student(localStudentArray[0])
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
        StudentModel.sharedInstance().studentArray = dictionary.map({student($0)})
        var annotations = [MKPointAnnotation]()
        
        for students in StudentModel.sharedInstance().studentArray{
            annotations.append(students.annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
}

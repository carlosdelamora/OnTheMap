//
//  PostingControllView.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/28/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class PostingControllView: UIViewController, UITextViewDelegate{
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    
    
    var numberOfEditsLocationText = 0
    var numberOfEditsURLText = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var mapLocationText: UITextView!
    @IBOutlet weak var URLTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func cancelButton(_ sender: AnyObject) {
       
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.shouldAutorotate)
        super.viewWillAppear(true)
        mapLocationText.delegate = self
        URLTextView.delegate = self
        resetToInitalConditions()
        
        //Using the GET method we got the firstname and lastname of the user set it up to student in this class
        
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/users/\(UDClient.sharedInstance().userID!)"), "GET", username: nil, password: nil, hostViewController: self)
        
        //add an observer to see if the internet conection changed
        NotificationCenter.default.addObserver(self, selector: #selector(statusChanged), name: .reachabilityChanged, object: nil)
        //we check what is the internet status
        internetStatus = internetReach.currentReachabilityStatus().rawValue

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    //this function gets called when there is a change in the internet connectivity
    func statusChanged(_ selector: Notification){
        internetStatus = (selector.object as! Reachability).currentReachabilityStatus().rawValue
    }
    
    //this funtion presents an alert view controller with the given message and title for no internet connection
    func noConnectionAlert(_ message: String){
        let controller = UIAlertController()
        controller.title = "No internet connection"
        controller.message = message//"Can not find the location due to no internet connection, please connecto to the internet and try again"
        performUIUpdatesOnMain {
            
            let action = UIAlertAction(title:
            "OK", style: .default){(UIAlertAction) in
                controller.dismiss(animated: true, completion: nil)
            }
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
       // if there is no internet connection when the findOnTheMap is pressed we display an allert view controller
        print(internetStatus)
        if internetStatus! == 0 {
            let message = "Can not find the location due to no internet connection, please connecto to the internet and try again"
            noConnectionAlert(message)
        }
        
        activityIndicator.startAnimating()
        initialView.isHidden = true
        StudentModel.sharedInstance().dictionaryOfMyStudent["mapString"] = mapLocationText.text as AnyObject
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = mapLocationText.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        var placemark : MKPlacemark? = nil
        search.start { response, _ in
            //function to display an error if the place is not found
            func displayError(string:String){
                print(string)
                self.initialView.isHidden = false
                let  alertController = UIAlertController()
                alertController.title = "Not found"
                alertController.message = "We were not able to find the location, please try again"
                self.present(alertController, animated:true,completion: nil)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                    }))
                }
            
            guard let response = response else {
                self.activityIndicator.stopAnimating()
                displayError(string:"There was no response")
                return
            }
            
            placemark = response.mapItems[0].placemark
            StudentModel.sharedInstance().dictionaryOfMyStudent["latitude"] = placemark!.coordinate.latitude as AnyObject
            StudentModel.sharedInstance().dictionaryOfMyStudent["longitude"] = placemark!.coordinate.longitude as AnyObject
            
           
        
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark!.coordinate
            annotation.title = placemark?.name
            if let city = placemark?.locality,
                let state = placemark?.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotation(annotation)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegionMake(placemark!.coordinate, span)
            
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    @IBAction func SubmitButton(_ sender: AnyObject) {
        if internetStatus == 0{
            let message = "We can not submit your request given that there is no internet connection, please connect and try again"
            noConnectionAlert(message)
        }
       StudentModel.sharedInstance().dictionaryOfMyStudent["mediaURL"] = URLTextView.text.replacingOccurrences(of: "\n", with: "") as AnyObject
       StudentModel.sharedInstance().dictionaryOfMyStudent["mapString"] = mapLocationText.text.replacingOccurrences(of: "\n", with: "") as AnyObject
        
        // we should do this method "POST" when we have no student i.e. when myStudent is nil
        
        if StudentModel.sharedInstance().myStudent == nil{
            ParseClient.sharedInstance().parsePUTorPostMethod(ParseClient.sharedInstance().URLParseMethod(nil, nil), "POST", self){ jsonData in
               
                guard let objectId = jsonData["objectId"] else{
                   
                        print( "error with the post method")
                
                    return
                }
        
                StudentModel.sharedInstance().dictionaryOfMyStudent["objectId"] = objectId
                guard let createdAt = jsonData["createdAt"] else{
                    print("we could not find createdAt")
                    return
                }
                //since the student was created the update time and the create time is the same
                StudentModel.sharedInstance().dictionaryOfMyStudent["createdAt"] = createdAt
                StudentModel.sharedInstance().dictionaryOfMyStudent["updatedAt"] = createdAt
                StudentModel.sharedInstance().myStudent = student(StudentModel.sharedInstance().dictionaryOfMyStudent)
                print("student was posted")
                performUIUpdatesOnMain {
                    //return back to mapViewController once the myStudents has been created
                    //let Controller = self.storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
                    //self.present(Controller!, animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                    
                
                
            }
        }
        
        
       
        // we should do this method "PUT" when we have an existing student
        if StudentModel.sharedInstance().myStudent != nil{
            //createdAt does not change
            StudentModel.sharedInstance().dictionaryOfMyStudent["createdAt"] = StudentModel.sharedInstance().myStudent!.createdAt as AnyObject
            //objectId should not change 
            StudentModel.sharedInstance().dictionaryOfMyStudent["objectId"] = StudentModel.sharedInstance().myStudent!.objectId as AnyObject
            ParseClient.sharedInstance().parsePUTorPostMethod(ParseClient.sharedInstance().URLParseMethod(nil, "/" + "\(StudentModel.sharedInstance().myStudent!.objectId)"), "PUT", self){ jsonData in
            
                guard let updatedAt = jsonData["updatedAt"] else{
                    print( "error with the put method")
                    return
                }
                print("we are almost done")
                StudentModel.sharedInstance().dictionaryOfMyStudent["updatedAt"] = updatedAt
                StudentModel.sharedInstance().myStudent = student(StudentModel.sharedInstance().dictionaryOfMyStudent)
                print("student was updated")
                
                    performUIUpdatesOnMain {
                        //return back to mapViewController once the myStudents has been created
                        let Controller = self.storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
                        self.present(Controller!, animated: true, completion: nil)
                    }
                }
    
        }
        
    }

    @IBAction func theUserTaped(_ sender: AnyObject) {
        mapLocationText.resignFirstResponder()
        URLTextView.resignFirstResponder()
        
    }
    
    func resetToInitalConditions(){
        mapLocationText.text = "Enter Your Location Here"
        URLTextView.text = "Enter a Link to Share Here"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if mapLocationText.isFirstResponder && numberOfEditsLocationText == 0{
            mapLocationText.text = ""
            numberOfEditsLocationText = 1
        }
        
        if URLTextView.isFirstResponder && numberOfEditsURLText == 0{
            URLTextView.text = ""
            numberOfEditsURLText = 1
        }
        
    }
    
    

}





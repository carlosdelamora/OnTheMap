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
    
    
    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var mapLocationText: UITextView!
    @IBOutlet weak var URLTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        let Controller = self.storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
        present(Controller!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.shouldAutorotate)
        super.viewWillAppear(true)
        mapLocationText.delegate = self
        URLTextView.delegate = self
        resetToInitalConditions()
        
        //Using the GET method we got the firstname and lastname of the user set it up to student in this class
        
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/users/\(UDClient.sharedInstance().userID!)"), "GET", username: nil, password: nil, hostViewController: self)
        
    }
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
        initialView.isHidden = true
        ParseClient.sharedInstance().dictionaryOfMyStudent["mapString"] = mapLocationText.text as AnyObject
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
                displayError(string:"There was no response")
                return
            }
            
            placemark = response.mapItems[0].placemark
            ParseClient.sharedInstance().dictionaryOfMyStudent["latitude"] = placemark!.coordinate.latitude as AnyObject
            ParseClient.sharedInstance().dictionaryOfMyStudent["longitude"] = placemark!.coordinate.longitude as AnyObject
            
           
        
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark!.coordinate
            annotation.title = placemark?.name
            if let city = placemark?.locality,
                let state = placemark?.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            self.mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark!.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func SubmitButton(_ sender: AnyObject) {
       
       ParseClient.sharedInstance().dictionaryOfMyStudent["mediaURL"] = URLTextView.text as AnyObject
       ParseClient.sharedInstance().dictionaryOfMyStudent["mapString"] = mapLocationText.text as AnyObject
        // we should do this method "POST" when we have no student i.e. when myStudent is nil
        
        if ParseClient.sharedInstance().myStudent == nil{
            ParseClient.sharedInstance().parsePUTorPostMethod(ParseClient.sharedInstance().URLParseMethod(nil, nil), "POST", self){ jsonData in
               
                guard let objectId = jsonData["objectId"] else{
                   
                        print( "error with the post method")
                
                    return
                }
        
                ParseClient.sharedInstance().dictionaryOfMyStudent["objectId"] = objectId
                guard let createdAt = jsonData["createdAt"] else{
                    print("we could not find createdAt")
                    return
                }
                //since the student was created the update time and the create time is the same
                ParseClient.sharedInstance().dictionaryOfMyStudent["createdAt"] = createdAt
                ParseClient.sharedInstance().dictionaryOfMyStudent["updatedAt"] = createdAt
                ParseClient.sharedInstance().myStudent = student(ParseClient.sharedInstance().dictionaryOfMyStudent)
                print("student was posted")
                performUIUpdatesOnMain {
                    //return back to mapViewController once the myStudents has been created
                    let Controller = self.storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
                    self.present(Controller!, animated: true, completion: nil)
                }
                    
                
                
            }
        }
        
        
       
        // we should do this method "PUT" when we have an existing student
        if ParseClient.sharedInstance().myStudent != nil{
            //createdAt does not change
            ParseClient.sharedInstance().dictionaryOfMyStudent["createdAt"] = ParseClient.sharedInstance().myStudent!.createdAt as AnyObject
            //objectId should not change 
            ParseClient.sharedInstance().dictionaryOfMyStudent["objectId"] = ParseClient.sharedInstance().myStudent!.objectId as AnyObject
            ParseClient.sharedInstance().parsePUTorPostMethod(ParseClient.sharedInstance().URLParseMethod(nil, "/" + (ParseClient.sharedInstance().myStudent?.objectId)!), "PUT", self){ jsonData in
            
                guard let updatedAt = jsonData["updatedAt"] else{
                    print( "error with the put method")
                    return
                }
                print("we are almost done")
                ParseClient.sharedInstance().dictionaryOfMyStudent["updatedAt"] = updatedAt
                ParseClient.sharedInstance().myStudent = student(ParseClient.sharedInstance().dictionaryOfMyStudent)
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





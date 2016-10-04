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


class PostingControllView:UIViewController, UITextViewDelegate{
    /*
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
     */
    
    var numberOfEditsLocationText = 0
    var numberOfEditsURLText = 0
    
    var newStudent:student?
    var studentArray = [String: AnyObject]()
    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var mapLocationText: UITextView!
    @IBOutlet weak var URLTextView: UITextView!
    
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        let Controller = self.storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
        present(Controller!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapLocationText.delegate = self
        resetToInitalConditions()
    }
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
        initialView.isHidden = true
        studentArray["mapString"] = mapLocationText.text as AnyObject
    }
    
    @IBAction func SubmitButton(_ sender: AnyObject) {
       //We got the firstname and lastname of the user set it up to student in this class
       //TODO: fix my user id 2412918542
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/users/2412918542"/*\(UDClient.sharedInstance().userID!)"*/), "GET", username: nil, password: nil, hostViewController: self)
       studentArray["mediaURL"] = URLTextView.text as AnyObject
       let currentDate = Date()
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "YYY-MM-dd'T'HH:mm:SS.SSSS"
       let createdAt = dateFormatter.string(from: currentDate)
       studentArray["updatedAt"] = createdAt as AnyObject
       //TODO: Ckeck that has not been created before
       studentArray["createdAt"] = createdAt as AnyObject
        
        
    }

    @IBAction func theUserTaped(_ sender: AnyObject) {
        mapLocationText.resignFirstResponder()
        print("the user taped")
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
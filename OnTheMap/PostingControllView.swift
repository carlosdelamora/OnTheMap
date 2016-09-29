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

//my user id is 2412918542
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
    
    func resetToInitalConditions(){
        mapLocationText.text = "Enter Your Location Here"
        URLTextView.text = "Enter a Link to Share Here"
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapLocationText.delegate = self
        resetToInitalConditions()
    }
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
        initialView.isHidden = true
    }
    
    @IBAction func SubmitButton(_ sender: AnyObject) {
       print(UDClient.sharedInstance().userID)
    }

    @IBAction func theUserTaped(_ sender: AnyObject) {
        mapLocationText.resignFirstResponder()
        print("the user taped")
    }
    
}

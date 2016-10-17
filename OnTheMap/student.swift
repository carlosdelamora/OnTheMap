//
//  student.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/26/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import MapKit
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

struct student{
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniquekey: String
    let updateAt: String
    let annotation = MKPointAnnotation()
    init(_ dictionary:[String:AnyObject]){
        self.createdAt = dictionary["createdAt"] as! String
        self.firstName = dictionary["firstName"] as! String
        self.lastName = dictionary["lastName"] as! String
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        self.mapString = dictionary["mapString"] as! String
        self.mediaURL = dictionary["mediaURL"] as! String
        self.uniquekey = String(describing: dictionary["uniqueKey"])
        self.updateAt = dictionary["updatedAt"] as! String
        let coordinates = CLLocationCoordinate2D(latitude: self.latitude , longitude: self.longitude)
        self.annotation.coordinate = coordinates
        self.annotation.title = "\(self.firstName) \(self.lastName)"
        self.annotation.subtitle = self.mediaURL

        
    }
}

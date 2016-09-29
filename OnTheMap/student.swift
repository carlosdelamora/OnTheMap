//
//  student.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/26/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
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
    let mapSting: String
    let mediaURL: String
    let uniquekey: Int
    let updateAt: String
    
    init(_ dictinary:[String:AnyObject]){
        self.createdAt = dictinary["createdAt"] as! String
        self.firstName = dictinary["firstName"] as! String
        self.lastName = dictinary["lastName"] as! String
        self.latitude = dictinary["latitude"] as! Double
        self.longitude = dictinary["longitude"] as! Double
        self.mapSting = dictinary["mapString"] as! String
        self.mediaURL = dictinary["mediaURL"] as! String
        self.uniquekey = dictinary["uniqueKey"] as! Int
        self.updateAt = dictinary["updatedAt"] as! String
    }
}

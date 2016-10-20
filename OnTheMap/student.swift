//
//  student.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/26/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import MapKit


struct student{
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
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
        self.objectId = dictionary["objectId"] as! String 
        self.uniquekey = String(describing: dictionary["uniqueKey"])
        self.updateAt = dictionary["updatedAt"] as! String
        let coordinates = CLLocationCoordinate2D(latitude: self.latitude , longitude: self.longitude)
        self.annotation.coordinate = coordinates
        self.annotation.title = "\(self.firstName) \(self.lastName)"
        self.annotation.subtitle = self.mediaURL

        
    }
}

//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/26/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation


class ParseClient: NSObject{
    
    
    var studentArray = [student]()
    //myStudent is the student I will create with the information of the user.
    var myStudent: student? = nil
    
    //singleton
    func sharedInstance()->ParseClient{
        struct Singleton{
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
}

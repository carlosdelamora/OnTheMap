//
//  StudentModel.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 10/21/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation


class StudentModel{
    
    var studentArray = [student]()
    var myStudent: student? = nil
    var dictionaryOfMyStudent = [String: AnyObject]()
    
    class func sharedInstance() -> StudentModel{
        struct Singelton{
            static var sharedInstance = StudentModel()
        }
        return Singelton.sharedInstance
    }
}

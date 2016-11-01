//
//  Constans.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/22/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: UD
    
    struct UD {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: TMDB Parameter Keys
    struct UDParameterKeys {
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Response Keys
    struct UDResponseKeys {
        static let SessionID = "session_id"
        
    }

    struct ParseKeys {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    //https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
    struct Parse{
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    struct UI {
        //static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorTop = UIColor(red: 0.9, green: 0.53, blue: 0.1, alpha: 1.0).cgColor
        //static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.9, green: 0.4, blue: 0.0, alpha: 1.0).cgColor
        //static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        //static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }

}

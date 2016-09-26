//
//  Constans.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/22/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation


struct Constants {
    
    // MARK: UD
    
    struct UD {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    
    // MARK: TMDB Parameter Keys
    struct UDParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Parameter Values
    struct UDParameterValues {
        static let ApiKey = ""
    }
    
    // MARK: TMDB Response Keys
    struct UDResponseKeys {
        static let SessionID = "session_id"
        
    }

}

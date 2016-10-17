//
//  GCD.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/22/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}


func performUpdatesOnMainSync(_ updates: @escaping () -> Void ){
    DispatchQueue.main.sync {
        updates()
    }
}



func perfromUpdatesInTheBackground(_ updates: @escaping () -> Void) {
    DispatchQueue.global().async {
        updates()
    }
    
    
}

//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 10/12/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
        UDClient.sharedInstance().logoutPressed = true
        print("logout was pressed")
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let aStudent = ParseClient.sharedInstance().studentArray[indexPath.row]
        cell.textLabel?.text = aStudent.firstName + " " + aStudent.lastName
        return cell 
    }
    
    
}

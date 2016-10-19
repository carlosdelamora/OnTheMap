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
    
    override func viewDidLoad() {
         super.viewDidLoad()
        //self.tableView.delegate = self
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        let parametersFor100 = ["limit":100 as AnyObject]
        //create a closure with self.tavleViewReloadData
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil), self)
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
        
        
    }
    
    @IBAction func postButton(_ sender: AnyObject) {
        let parameters = ["where":"{\"uniqueKey\":\"\(UDClient.sharedInstance().userID!)\"}" as AnyObject]
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parameters, nil), self)
        print("the post was pressed")
        print(ParseClient.sharedInstance().URLParseMethod(parameters, nil))
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
        UDClient.sharedInstance().logoutPressed = true
        print("logout was pressed")
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! Cell
        let aStudent = ParseClient.sharedInstance().studentArray[indexPath.row]
        cell.nameLabel.text = aStudent.firstName + " " + aStudent.lastName + aStudent.mapString
        return cell 
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aStudent = ParseClient.sharedInstance().studentArray[indexPath.row]
        let app = UIApplication.shared
        if let url = URL(string: aStudent.mediaURL) {
            app.open( url, options: [String : Any](), completionHandler: nil)
        }
    }
    
}

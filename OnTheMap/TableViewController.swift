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
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray in
            StudentModel.sharedInstance().studentArray = localStudentArray.map({student($0)})
            self.tableView.reloadData()
        }
    }
    
    @IBAction func postButton(_ sender: AnyObject) {
        //set the parameters to search students with unique key the same as the user
        let parameters = ["where":"{\"uniqueKey\":\"\(UDClient.sharedInstance().userID!)\"}" as AnyObject]
        // call this method to return an array of type [String: AnyObject] where the uniqueKey is the same as the userId
        ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parameters, nil)){ localStudentArray in
            //if the localStudentArray.count is more than 0, that means the student was already posted otherwise the student was nonexisting.
            if localStudentArray.count > 0 {
                StudentModel.sharedInstance().myStudent = student(localStudentArray[0])
                let  alertController = UIAlertController(title: "", message: "You have already posted a Student Location", preferredStyle: UIAlertControllerStyle.alert)
                
                performUIUpdatesOnMain {
                    self.present(alertController, animated:true,completion: nil)
                    
                    alertController.addAction(UIAlertAction(title: "Canel", style: .default, handler: { (UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                    }))
                    
                    alertController.addAction(UIAlertAction(title: "Override", style: .default, handler: { (UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                        
                        let navigationPostController = self.storyboard?.instantiateViewController(withIdentifier: "PostingNavigationController")
                        self.present(navigationPostController!, animated: true)
                    }))
                    
                    
                }
            }else{
                performUIUpdatesOnMain {
                    let navigationPostController = self.storyboard?.instantiateViewController(withIdentifier: "PostingNavigationController")
                    self.present(navigationPostController!, animated: true)
                }
                
            }
            
        }

        print("the post was pressed")
        print(ParseClient.sharedInstance().URLParseMethod(parameters, nil))
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
        UDClient.sharedInstance().logoutPressed = true
        print("logout was pressed")
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.sharedInstance().studentArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! Cell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //we sort the student array by the date where it was updated
        let sortedArray = StudentModel.sharedInstance().studentArray.sorted( by: { dateFormatter.date(from: $0.updateAt)! > dateFormatter.date(from: $1.updateAt)! } )
            
        let aStudent = sortedArray[indexPath.row]
        cell.nameLabel.text = aStudent.firstName + " " + aStudent.lastName
        return cell 
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aStudent = StudentModel.sharedInstance().studentArray[indexPath.row]
        let app = UIApplication.shared
        if let url = URL(string: aStudent.mediaURL) {
            app.open( url, options: [String : Any](), completionHandler: nil)
        }
    }
    
}

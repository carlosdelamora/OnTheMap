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
        //subscribe to notification to see if the internet connection has changed
        NotificationCenter.default.addObserver(self, selector: #selector(statusChanged), name: .reachabilityChanged, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        if internetStatus! == 0{
            connectivityAlert(_title: "No internet Connection", "We can not refresh the table because there is no iternet connection")
        }else{
            let parametersFor100 = ["order":"-updatedAt" as AnyObject,"limit":100 as AnyObject]
            //create a closure with self.tavleViewReloadData
            ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil)){ localStudentArray in
                StudentModel.sharedInstance().studentArray = localStudentArray.map({student($0)})
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func postButton(_ sender: AnyObject) {
        if internetStatus! == 0{
            connectivityAlert(_title: "No internet Connection", "Can not post since there is no internet connectivity, please connect to the internet and try again")
        }else{
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
        }
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        if internetStatus! == 0{
            connectivityAlert(_title: "No internet Connection", "We can not logout because there is not interent connectivity, please connect to the internet and logout again")
        }else{
            UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "DELETE", username: nil, password: nil, hostViewController: self)
            UDClient.sharedInstance().logoutPressed = true
            print("logout was pressed")
        }
    }
    
    func connectivityAlert(_title: String, _ message:String){
        let alertController = UIAlertController()
        alertController.title = title
        alertController.message = message
        let actionAlert = UIAlertAction(title: "OK", style: .default){ (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(actionAlert)
        
        performUIUpdatesOnMain {
            self.present(alertController, animated: true)
        }
        
    }
    
    func statusChanged(_ selector: Notification){
        internetStatus = (selector.object as! Reachability).currentReachabilityStatus().rawValue
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

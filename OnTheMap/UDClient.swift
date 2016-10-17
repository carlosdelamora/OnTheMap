//
//  UDClient.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/23/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class UDClient:NSObject{
    
    let session = URLSession.shared
    var sessionID : String? = nil
    var userID : Int? = nil
    var logoutPressed: Bool = false 
    
    override init() {
        super.init()
    }
    class func sharedInstance() -> UDClient{
        struct Singleton {
            static var sharedInstance = UDClient()
        }
        return Singleton.sharedInstance
    }
    
    func URLUdacityMethod(_ pathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.UD.ApiScheme
        components.host = Constants.UD.ApiHost
        components.path = Constants.UD.ApiPath + (pathExtension ?? "")
        return components.url!
    }
    
    //we use this method to parse data into an object of type [String:Anyobject] out of the udacity methods
    func closures(_ data: Data?, _ response:URLResponse?, _ error:Error?)->[String: AnyObject]?{
        
        var jsonData: Any!
        guard (error == nil) else {
            print("There was an error with your request: \(error)")
            return nil
        }
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
            print("Your request returned a status code \((response as? HTTPURLResponse)?.statusCode)")
            //print("\(response as? HTTPURLResponse)?.statusCode)")
            return nil
        }
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            print("No data was returned by the request!")
            return nil
        }
        let newData = data.subdata(in: Range(5..<data.count)) /* subset response data! */
        do{jsonData = try JSONSerialization.jsonObject(with: newData, options:.allowFragments)}catch{
            print("the json data could not be obtained")
        }
        print(jsonData)
        print("here is the json Data")
        return jsonData as? [String:AnyObject]
    }
    
    
    func udacityMethod(_ methodtype: URL, _ type: String, username:String?, password:String?, hostViewController: UIViewController){
        
        let request = NSMutableURLRequest(url: methodtype)
        var jsonData: [String:AnyObject]?
        print(methodtype)
        print("\(type)")
        switch type {
        case "POST":
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\":\"\(username!)\", \"password\": \"\(password!)\"}}".data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                jsonData = self.closures(data, response, error)
                
                func displayError(string:String){
                    print(string)
                    let  alertController = UIAlertController()
                    alertController.title = "Not registered"
                    alertController.message = "Either the password or the username are wrong"
                    performUIUpdatesOnMain {
                        hostViewController.present(alertController, animated:true,completion: nil)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                            alertController.dismiss(animated: true, completion: nil)
                        }))
                    }
                }
                
                guard let sessionDirctionary = jsonData?["session"] as? [String:AnyObject]else{
                    displayError(string: "The session was not found")
                    return
                }
                
                
                self.sessionID = sessionDirctionary["id"]! as? String
                
                guard let accountDictionary = jsonData!["account"] as? [String:AnyObject]else{
                    displayError(string: "account was not found")
                    return
                }
                guard (accountDictionary["registered"] as? Int)! == 1 else{
                    displayError(string:"not registered")
                    print((accountDictionary["registered"] as? Int))
                    return
                }
                //for some unknown reason userID = accountDictionary["key"] as? Int fails that is why need the constant number
                
                guard let number = accountDictionary["key"] as? String else{
                    displayError(string: "the user ID does not exist")
                    print(accountDictionary["key"])
                    print(accountDictionary["key"] as? Int)
                    return
                }
                
                performUIUpdatesOnMain {
                    let tabBarController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "Tab Bar Controller") as! UITabBarController
                        hostViewController.present(tabBarController, animated: true, completion: nil)
                }
                
                self.userID = Int(number)!
                print(self.userID)
                
            }
            task.resume()
        case "DELETE":
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                // the udacityClosures gets data response and error returns a dictionary of type [String:AnyObject]?
                jsonData = self.closures(data, response, error)
                
                func displayError(string: String){
                    print("String")
                }
                guard let logoutDictionary = jsonData?["session"] as? [String:AnyObject]else{
                    displayError(string: "the session does not exist")
                    return
                }
                guard let logoutSessionID = logoutDictionary["id"] else{
                    displayError(string: "there is no session id")
                    return
                }
                
               
                performUIUpdatesOnMain {
                    print(logoutSessionID)
                
                let viewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                hostViewController.present(viewController, animated: true, completion: nil)
                }
            }
            task.resume()
        case "GET": //https://www.udacity.com/api/session/users/2412918542
            print("We are in case GET")
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                jsonData = self.closures(data, response, error)
                
                guard let user = jsonData?["user"] as? [String:AnyObject] else{
                    print("We could not find user")
                    return
                }
                guard let firstName = user["first_name"] else{
                    print("we can not find the first_name")
                    return
                }
                guard let lastName = user["last_name"] else{
                    print("we can not find the last_name")
                    return
                }
                
                guard let key = user["key"] else{
                    print("we can not find the last bame")
                    return
                }
                
                let PostingController = hostViewController as! PostingControllView
                
                PostingController.studentArray["firstName"] = firstName as AnyObject
                PostingController.studentArray["lastName"] = lastName as AnyObject
                PostingController.studentArray["uniqueKey"] = key as AnyObject
                print(lastName)
                print(firstName)
                print(key)
                
            }
            task.resume()
        default:
            print("Do not recognize the method type")
        }
    }

    

    
    
}

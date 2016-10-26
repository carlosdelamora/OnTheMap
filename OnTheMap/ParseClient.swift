//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/26/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject{
    
    
    //var studentArray = [student]()
    //myStudent is the student I will create with the information of the user in my PostingViewController.
    //var myStudent: student? = nil
    //var dictionaryOfMyStudent = [String: AnyObject]()
    
    override init() {
        super.init()
    }
    //singleton
    class func sharedInstance() -> ParseClient{
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

    //the function creates a URL that is ASCII character
    func URLParseMethod(_ parameters: [String: AnyObject]?, _ pathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.ApiScheme
        components.host = Constants.Parse.ApiHost
        components.path = Constants.Parse.ApiPath + (pathExtension ?? "")
        
        guard let parameters = parameters else{
            return components.url!
            
        }
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

    
  
    
    
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
        /* subset response data! */
        do{jsonData = try JSONSerialization.jsonObject(with: data, options:.allowFragments)}catch{
            print("the json data could not be obtained")
        }
        print(jsonData)
        print("here is the json Data")
        return jsonData as? [String:AnyObject]
    }    

    
    
    //we use this method for both GET methods, that returns an array of one student or an array of I believe 100 students
    //TODO check that we need the UIVIewController
    func parseGetMethod(_ methodtype: URL, _ completionHandeler: @escaping ([[String:AnyObject]]) -> Void ){
        
        let request = NSMutableURLRequest(url: methodtype)
        var jsonData: [String:AnyObject]?
        var finalStudentArray: [student]?
        print("the methodtype is \(methodtype)")
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            jsonData = self.closures(data, response, error)
            //TODO may be fix the displayError to do something?
            func displayError(string:String){
                print(string)
            }
            guard let localStudentArray = jsonData?["results"] as? [[String: AnyObject]]else{
                displayError(string: "results is not part of the data")
                return
            }
            
            performUIUpdatesOnMain {
                completionHandeler(localStudentArray)
            }
            
           
        }
        task.resume()
    }
    
    func parsePUTorPostMethod(_ methodtype: URL, _ type:String, _ hostViewController: UIViewController, _ completionHandeler: @escaping ([String:AnyObject]) -> Void ){
        
        let request = NSMutableURLRequest(url: methodtype)
        var jsonData: [String:AnyObject]?
        print("the methodtype is \(methodtype), type \(type)")
        request.httpMethod = type
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(StudentModel.sharedInstance().dictionaryOfMyStudent)
        request.httpBody = "{\"uniqueKey\": \"\(StudentModel.sharedInstance().dictionaryOfMyStudent["uniqueKey"]!)\", \"firstName\": \"\(StudentModel.sharedInstance().dictionaryOfMyStudent["firstName"]!)\", \"lastName\": \"\(StudentModel.sharedInstance().dictionaryOfMyStudent["lastName"]!)\",\"mapString\": \"\(StudentModel.sharedInstance().dictionaryOfMyStudent["mapString"]!)\", \"mediaURL\": \"\(StudentModel.sharedInstance().dictionaryOfMyStudent["mediaURL"]!)\",\"latitude\":\(StudentModel.sharedInstance().dictionaryOfMyStudent["latitude"]!), \"longitude\": \(StudentModel.sharedInstance().dictionaryOfMyStudent["longitude"]!)}".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let session = URLSession.shared
        print("this is the unique key \(StudentModel.sharedInstance().dictionaryOfMyStudent["uniqueKey"]!)")
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
        jsonData = self.closures(data, response, error)
            
            
            guard let jsonData = jsonData else{
                print("the jsonData for the method \(methodtype) of type \(type) failed")
                return
            }
            completionHandeler(jsonData)
            
        }
        task.resume()

        
    }
    
    
}

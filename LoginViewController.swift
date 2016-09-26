//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/21/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBAction func loginWasPressed(_ sender: AnyObject) {
    
        //userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            //debugTextLabel.text = "Username or Password Empty."
            print("Username or Password Empty.")
        } else {
            UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod(nil), "POST", username: emailTextField.text, password: passwordTextField.text, hostViewController: self)
            completeLogin()
        }
    }
    
    func completeLogin(){
        performUIUpdatesOnMain {
            let tabBarController = self.storyboard!.instantiateViewController(withIdentifier: "Tab Bar Controller") as! UITabBarController
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    fileprivate func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
    }
}


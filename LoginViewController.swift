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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        //we do not want to send a request when the logout button is pressed only when the app loads for the first time
        if !UDClient.sharedInstance().logoutPressed{
            let parametersFor100 = ["limit":100 as AnyObject]
            ParseClient.sharedInstance().parseGetMethod(ParseClient.sharedInstance().URLParseMethod(parametersFor100, nil), self)
            UDClient.sharedInstance().logoutPressed = false
        }
    }
    
    @IBAction func loginWasPressed(_ sender: AnyObject) {
        
    
        //userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            //debugTextLabel.text = "Username or Password Empty."
            print("Username or Password Empty.")
        } else {
            print("login was pressed")
            UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "POST", username: emailTextField.text, password: passwordTextField.text, hostViewController: self)
            
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


extension LoginViewController {
    
    func configureTextField(){
         emailTextField.delegate = self
         passwordTextField.delegate = self
    }
}

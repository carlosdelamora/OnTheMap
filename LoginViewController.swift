//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Carlos De la mora on 9/21/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import Foundation
import UIKit

var internetReach = Reachability()
var internetStatus: NSInteger? // 0 not reachable, 1 is reachable viwa wifi ReachableViaWWAN
class LoginViewController: UIViewController{
    
    var keyboardOnScreen = false
    
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure set the delegates of the text fields to self
        configureTextField()
        
        //subscibe to notifications in order to move the view up or down
        subscribeToNotification(NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(keyboardWillShow))
        subscribeToNotification(NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(keyboardWillHide))
        subscribeToNotification(NSNotification.Name.UIKeyboardDidShow.rawValue, selector: #selector(keyboardDidShow))
        subscribeToNotification(NSNotification.Name.UIKeyboardDidHide.rawValue, selector: #selector(keyboardDidHide))
        
        //we check what is the internet status
        internetStatus = internetReach.currentReachabilityStatus().rawValue
        //we add self as an observer with a notification when the network status changed 
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged), name: .reachabilityChanged, object: nil)
    }
    
    func reachabilityStatusChanged(_ sender: NSNotification){
        internetStatus = (sender.object as! Reachability).currentReachabilityStatus().rawValue
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // we need to unsubscribe from all notifications when the view disappears
        unsubscribeFromAllNotifications()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }

    
    
    @IBAction func loginWasPressed(_ sender: AnyObject) {
        print("the internet status is \(internetStatus)")
        
        //
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
        //if the login is Empty and login is pressed do nothing
        } else {
            // We check if there is internet connection. 
            if internetStatus! == 0{
                
                
                let  alertController = UIAlertController()
                alertController.title = "No internet Connection"
                alertController.message = "You are not connected to the newrok, please connect and try again"
                performUIUpdatesOnMain {
                    self.present(alertController, animated:true,completion: nil)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                    }))
                }
            }else{
                UDClient.sharedInstance().udacityMethod(UDClient.sharedInstance().URLUdacityMethod("/session"), "POST", username: emailTextField.text, password: passwordTextField.text, hostViewController: self)
            }
        }
    }
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    

    //The function lets the keyboard hide when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // the function returns the height of the keyboard and deterimens the displacement need it by the view to not cover the text fields 
    fileprivate func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    fileprivate func subscribeToNotification(_ notification: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: notification), object: nil)
    }
    
    fileprivate func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
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
    
    override var shouldAutorotate: Bool{
        return false
    }
}

//
//  LoginViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
//    var ref : DatabaseReference!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        
    }
    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if (error == nil) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
            } else {
                
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Login Error", message: "Incorrect username or password", preferredStyle: .alert)
                let forgotPassword = UIAlertAction(title: "Forgot Password?", style: .default, handler: { (UIAlertAction) in
                    //do the forgot password shit
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
                    //do nothing
                })
                
                alert.addAction(forgotPassword)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                print("error with logging in: ", error!)
            }
        }
    }
}

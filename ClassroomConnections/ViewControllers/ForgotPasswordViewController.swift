//
//  ForgotPasswordViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 3/17/20.
//  Copyright © 2020 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recoverPassword(_ sender: Any) {
        guard let email = emailText.text, email != "" else {
            SVProgressHUD.showError(withStatus: "Please Enter an email address for password reset")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error == nil {
                self.view.endEditing(true)
                SVProgressHUD.showSuccess(withStatus: "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password")
            } else {
                print(error)
                SVProgressHUD.showError(withStatus: "There has been an error")
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

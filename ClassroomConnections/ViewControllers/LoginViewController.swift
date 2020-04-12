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
    @IBOutlet var currView: UIView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
    }
    @IBAction func loginPressed(_ sender: Any) {
        var hi = UIOffset(horizontal: currView.frame.size.width/2 , vertical: currView.frame.size.height/2 )
//        SVProgressHUD.show()
//        SVProgressHUD.setOffsetFromCenter(hi)
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if (error == nil) {
                
                self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in

                    guard let value = snapshot.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    let status = value["Status"] as! String


                    print (status)
                    if (status == "Teacher") {
                        self.performSegue(withIdentifier: "teacherLogin", sender: self)
                    }
                    else {
                        self.performSegue(withIdentifier: "studentLogin", sender: self)
                    }


                }) { (error) in
                    print("error:\(error.localizedDescription)")
                }
//                
                
//                SVProgressHUD.dismiss()
//                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
            } else {
                
//                SVProgressHUD.dismiss()
                
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

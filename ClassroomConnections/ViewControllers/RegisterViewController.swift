//
//  ViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    //Variables
    var isStudent : Bool = true
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    //Buttons
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var TeachersButton: UIButton!
    @IBOutlet var currView: UIView!
    
    //Firebase
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustButtons()
        
        ref = Database.database().reference()
        
        
        
        
    }
    
    
    func adjustButtons(){
        studentButton.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
        TeachersButton.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        studentButton.layer.cornerRadius = 5
        TeachersButton.layer.cornerRadius = 5
        //        studentButton.layer.corne = 10
        //        TeachersButton.layer.cornerRadius = 10
    }
    
    @IBAction func studentPressed(_ sender: Any) {
        isStudent = true
        studentButton.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
        TeachersButton.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    
    @IBAction func teacherPressed(_ sender: Any) {
        isStudent = false
        TeachersButton.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
        studentButton.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        var hi = UIOffset(horizontal: currView.frame.size.width/2 , vertical: currView.frame.size.height/2 )
//        SVProgressHUD.show()
//        SVProgressHUD.setOffsetFromCenter(hi)
        if (FirstName.text?.isEmpty ?? true || LastName.text?.isEmpty ?? true || Email.text?.isEmpty ?? true || Password.text?.isEmpty ?? true) {
//            SVProgressHUD.dismiss()
            print("THERE IS AN ERROR")
            let alert = UIAlertController(title: "Registration Error", message: "Please make sure you have completed filled out every textfield", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
                return
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: Email.text!, password: Password.text!) { (user, error) in
                if (error == nil) {
                    self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).setValue(["FirstName" : self.FirstName.text, "LastName" : self.LastName.text])
                    if (self.isStudent) {
                        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).updateChildValues(["Status" : "Student"])
                    
                    }
                    else {
                        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).updateChildValues(["Status" : "Teacher"])
                    }
                    
//                    SVProgressHUD.dismiss()
                    if (self.isStudent) {
                        self.performSegue(withIdentifier: "studentToClassSelection", sender: self)
                    }
                    else {
                        self.performSegue(withIdentifier: "teacherToClassSelection", sender: self)
                    }
                    //                    self.performSegue(withIdentifier: "goToMainMenu", sender: self)
                } else {
//                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Registration Error", message: error?.localizedDescription as! String, preferredStyle: .alert)
                    
                    let OK = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.Password.text = ""
                    })
                    
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                    print("--------------------------------")
                    print("Error: \(error?.localizedDescription)")
                    print("--------------------------------")
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
}


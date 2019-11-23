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
    }
    
    
    
    
    
    
    


}


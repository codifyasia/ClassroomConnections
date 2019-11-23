//
//  ViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

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
        
        
        
        
    }
    
    
    func adjustButtons(){
        studentButton.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        TeachersButton.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        studentButton.layer.cornerRadius = 10
        TeachersButton.layer.cornerRadius = 10
    }
    
    
    
    
    
    
    
    


}


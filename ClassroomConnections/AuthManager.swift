//
//  AuthManager.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 12/21/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import Firebase
import UIKit

class AuthManager {
    static let shared = AuthManager()
    var ref : DatabaseReference!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var authHandler: AuthHandler!
    
    private init() {
        ref = Database.database().reference()
    }
    
    func showApp() {
        if (Auth.auth().currentUser == nil) {
            var viewController: UIViewController
            print("auth is nil")
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            authHandler.present(viewController, animated: false, completion: nil)
        
        } else {
            print("auth is found:" + Auth.auth().currentUser!.uid)
            self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                guard let value = snapshot.value as? NSDictionary else {
                    print("no data in: userinfo -> auth.auth().currentuser!.uid")
                    return
                }
                let status = value["Status"] as! String
                if (status == "Student") {
                    print("status is student")
                    let viewController: UIViewController = self.storyboard.instantiateViewController(withIdentifier: "StudentClasses")
                    self.authHandler.present(viewController, animated: false, completion: nil)
                } else {
                    print("status is teacher")
                    let viewController: UIViewController = self.storyboard.instantiateViewController(withIdentifier: "TeacherClasses")
                    self.authHandler.present(viewController, animated: false, completion: nil)
                }

            }) { (error) in
                print("error:\(error.localizedDescription)")
            } // go into firebae to find whether the user is sa teacher or a tsudent and then segue accordingly
        }
    }
    
    
}



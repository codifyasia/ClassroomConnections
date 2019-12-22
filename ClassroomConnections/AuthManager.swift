//
//  AuthManager.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 12/21/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import FirebaseAuth
import UIKit

class AuthManager {
    static let shared = AuthManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var authHandler: AuthHandler!
    
    private init() {
        
    }
    
    func showApp() {
        var viewController: UIViewController
        if (Auth.auth().currentUser == nil) {
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "") // go into firebae to find whether the user is sa teacher or a tsudent and then segue accordingly
        }
        authHandler.present(viewController, animated: false, completion: nil)
    }
    
    
}



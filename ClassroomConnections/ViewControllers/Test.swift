//
//  Test.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 6/7/20.
//  Copyright © 2020 CodifyAsia. All rights reserved.
//

import UIKit

class Test: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var bottomViewY : CGFloat = 0
    var tableViewH : CGFloat = 0
    
    
    override func viewDidLoad() {
        bottomViewY = bottomView.frame.origin.y
        tableViewH = tableView.frame.height
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomView.frame.origin.y -= keyboardSize.height
            self.tableView.frame.size.height -= keyboardSize.height
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomView.frame.origin.y = bottomViewY
            self.tableView.frame.size.height = tableViewH
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

//
//  ViewController.swift
//  randomstuff
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class TeacherClasses: UIViewController {
    
    var ref: DatabaseReference!

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var textField = UITextField()
    var classes : [Class] = [
        Class(classTitle: "APLAC", teacher: "Seike"),
        Class(classTitle: "AP Minecraft" , teacher: "Your mom")
    ]
    
//    var colors : [UIColor] = [UIColor.brown, UIColor.green]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddClass", bundle: nil), forCellReuseIdentifier: "Cell")
        
        ref = Database.database().reference()
        
    }


}

extension TeacherClasses: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == classes.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddClass
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
            cell.textLabel?.text = classes[indexPath.row].classTitle
            cell.detailTextLabel?.text = classes[indexPath.row].teacher
//            cell.backgroundColor = colors[indexPath.row]
            return cell
        }
        
    }
    
}

extension TeacherClasses: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == classes.count) {
            let alert = UIAlertController(title: "Enter code to join class", message: "", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                print(self.textField.text!)
                self.classes.append(Class(classTitle: "AP CSA", teacher: "Fulk"))
                self.tableView.reloadData()
                
//                ref.child("")
            }
            
            alert.addAction(doneButton)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Class code"
                self.textField = alertTextField
//                /Users/michaelpeng/Desktop/ClassroomConnections/Pods/PKRevealController/Source/PKRevealController/PKRevealController.m:1363:1: Conflicting return type in implementation of 'supportedInterfaceOrientations': 'UIInterfaceOrientationMask' (aka 'enum UIInterfaceOrientationMask') vs 'NSUInteger' (aka 'unsigned long')
            }
            
            self.present(alert, animated: true, completion: nil)
            
        }
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: title,
          handler: { (action, view, completionHandler) in
          // Update data source when user taps action
            self.classes.remove(at: indexPath.row)
            self.tableView.reloadData()
          completionHandler(true)
        })
        action.backgroundColor = UIColor.red
        action.title = "Delete"
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//    }
}


//
//  ViewController.swift
//  randomstuff
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class StudentClasses: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    
    var topic : String = ""
    
    
    var textField = UITextField()
//    var topicTextField = UITextField()
//    var titleTextField = UITextField()
    
    var name : String = ""
    
    var classes : [Class] = [
        Class(classTitle: "APLAC", teacher: "Seike", id: "asdf"),
        Class(classTitle: "AP Minecraft" , teacher: "Your mom", id :"sdf")
    ]
    
    
    
    //    var colors : [UIColor] = [UIColor.brown, UIColor.green]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddClass", bundle: nil), forCellReuseIdentifier: "Cell")
        ref = Database.database().reference()
        
        
        getInfo()
//        updateClasses()
        
    }
    
    
    func getInfo() {
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let lastName = value["LastName"] as! String
            self.name = lastName
            
            self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Classrooms").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        self.classes.removeAll()
                        
                        print("retrieve data: " + String(snapshot.childrenCount))
                        
                        for rest in snapshot.children.allObjects as! [DataSnapshot] {
                            guard let value = rest.value as? NSDictionary else {
                                print("could not collect label data")
                                return
                            }
                            let title = value["Title"] as! String
                            print(title)
                            self.classes.append(Class(classTitle: title , teacher: lastName, id: self.topic))
                            self.tableView.reloadData()
            //                self.performSegue(withIdentifier: "studentToTabBar", sender: self)
                        }
                        
                    }) { (error) in
                        print("error:\(error.localizedDescription)")
                    }
            
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    
    func updateClasses() {
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Classrooms").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.classes.removeAll()
            
            print("retrieve data: " + String(snapshot.childrenCount))
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("could not collect label data")
                    return
                }
                let title = value["Title"] as! String
                print(title)
                self.classes.append(Class(classTitle: title , teacher: self.name, id: self.topic))
                self.tableView.reloadData()
//                self.performSegue(withIdentifier: "studentToTabBar", sender: self)
            }
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
}
//
//func updateClasses() {
//    ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Classrooms").observeSingleEvent(of: .value, with: { (snapshot) in
//
//
//        print("retrieve data: " + String(snapshot.childrenCount))
//
//        for rest in snapshot.children.allObjects as! [DataSnapshot] {
//            guard let value = rest.value as? NSDictionary else {
//                print("could not collect label data")
//                return
//            }
//            let title = value["Title"] as! String
//            let username = value["Username"] as! String
//
//
//        }
//
//    }) { (error) in
//        print("error:\(error.localizedDescription)")
//    }
//}

extension StudentClasses: UITableViewDataSource {
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

extension StudentClasses: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == classes.count) {
            let alert = UIAlertController(title: "Enter code to join class", message: "", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                print(self.textField.text!)
                //                self.classes.append(Class(classTitle: "APCSA", teacher: "Fulk"))
                //                self.tableView.reloadData()
                self.ref.child("Classrooms").child(self.textField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let value = snapshot.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    let titleValue = value["Title"] as! String
                    
                    
                    self.topic = titleValue
            self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Classrooms").child(self.textField.text!).updateChildValues(["ID" : self.textField.text!, "Title" : titleValue])
                    
                }) { (error) in
                    print("error:\(error.localizedDescription)")
                };                 self.ref.child("Classrooms").child(self.textField.text!).child("Students").child(Auth.auth().currentUser!.uid).updateChildValues(["SubmitStatus" : false])
                //update
                self.updateClasses()
            }
            
            alert.addAction(doneButton)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Class code"
                self.textField = alertTextField
                //                /Users/michaelpeng/Desktop/ClassroomConnections/Pods/PKRevealController/Source/PKRevealController/PKRevealController.m:1363:1: Conflicting return type in implementation of 'supportedInterfaceOrientations': 'UIInterfaceOrientationMask' (aka 'enum UIInterfaceOrientationMask') vs 'NSUInteger' (aka 'unsigned long')
            }
            
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            let identification = classes[indexPath.row].id
                
            
                print(identification)
            ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").updateChildValues(["ID" : identification, "Title" : classes[indexPath.row].classTitle ])
            
                performSegue(withIdentifier: "studentToTabBar", sender: self)
            
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
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "studentToTabBar" {
//            let destinationVC = segue.destination as! StudentConflictCalendar
//            destinationVC.ClassID = textField.text!
//            print(textField.text!)
//        }
//    }
    //
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //    }
}


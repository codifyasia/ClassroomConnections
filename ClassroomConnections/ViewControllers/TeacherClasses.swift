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
    var topicTextField = UITextField()
    var titleTextField = UITextField()
    var ide : String = ""
    
    var name : String = ""
    
    var classes : [Class] = []
    
    
    
    //    var colors : [UIColor] = [UIColor.brown, UIColor.green]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddClass", bundle: nil), forCellReuseIdentifier: "Cell")
        ref = Database.database().reference()
        
        
        getInfo()
        updateClasses()
        
    }
    
    func removeEverything(index: Int ) {
        print("\(classes.count) \(index)")
        print("id of remove:\(classes[index].id)")
        let removeID = classes[index].id
        self.ref.child("Classrooms").child(classes[index].id).child("Students").observeSingleEvent(of: .value, with: { (snapshot) in


            

            print("retrieve data: " + String(snapshot.childrenCount))

            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? NSDictionary else {
                    print("could not collect label data")
                    return
                }
                let iden = value["id"] as! String

                
                self.ref.child("UserInfo").child(iden).child("Classrooms").child(removeID).removeValue()
                self.getInfo()
            }

            self.ref.child("Classrooms").child(removeID).removeValue()
            self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Classrooms").child(removeID).removeValue()

        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
        
    }
    
    //
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "back2", sender: self)
            
        }catch let signOutError as NSError {
            print("Logout Error")
        }
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
                    let inden = value["ID"] as! String
                    print("\(lastName) hi hi")
                    self.classes.append(Class(classTitle: title , teacher: lastName, id:inden , teacherID: Auth.auth().currentUser!.uid))
                    self.tableView.reloadData()
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
                let iden = value["ID"] as! String
                print("\(self.name) hi hi")
                self.classes.append(Class(classTitle: title , teacher: self.name, id:iden, teacherID: Auth.auth().currentUser!.uid))
                self.tableView.reloadData()
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
            //            let identification = classes[indexPath.row].id
            //
            //
            //            print(identification)
            //            performSegue(withIdentifier: "teacherToTabView", sender: self)
            //            cell.backgroundColor = colors[indexPath.row]
            return cell
        }
        
    }
    
}

extension TeacherClasses: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == classes.count) {
            let alert = UIAlertController(title: "Enter code to create class", message: "", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "Done", style: .default) { (action) in
                print(self.textField.text!)
                self.ref.child("Classrooms").observeSingleEvent(of: .value, with: { (snap) in
                    if (self.topicTextField.text! == "" || self.textField.text! == "") {
                        let alert1 = UIAlertController(title: "Error with creating class", message: "", preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
                            //does nothing
                        }
                        let tryAgain = UIAlertAction(title: "Try again", style: .default) { (try) in
                            self.present(alert, animated: true, completion: nil)
                        }
                        alert1.addAction(cancelButton)
                        alert1.addAction(tryAgain)
                        self.present(alert1, animated: true, completion: nil)
                    } else if (snap.hasChild(self.textField.text!)) {
                        let alert1 = UIAlertController(title: "This code already exists", message: "", preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
                            //does nothing
                        }
                        let tryAgain = UIAlertAction(title: "Try again", style: .default) { (try) in
                            self.present(alert, animated: true, completion: nil)
                        }
                        alert1.addAction(cancelButton)
                        alert1.addAction(tryAgain)
                        self.present(alert1, animated: true, completion: nil)
                    }
                    else {
                        
                        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("Classrooms").child( self.textField.text!).updateChildValues(["Title" : self.topicTextField.text!, "Teacher" : self.name, "TeacherID": Auth.auth().currentUser!.uid, "ID" : self.textField.text!])
                    
                        self.ref.child("Classrooms").child(self.textField.text!).updateChildValues(["Teacher" : self.name, "Title" : self.topicTextField.text!, "TeacherID": Auth.auth().currentUser!.uid, "ID" : self.textField.text!, "Generator" : 0])
                    
                        self.ref.child("Classrooms").child(self.textField.text!).child("Calendar").updateChildValues([ "monday" : 0, "tuesday" : 0, "wednesday" : 0, "thursday" : 0, "friday" : 0])
                        
//                        self.ref.child("Classrooms").child(self.textField.text!).child("Calendar").child("Friday").updateChildValues(["Friday" : 0])
//                        self.ref.child("Classrooms").child(self.textField.text!).child("Calendar").child("Thursday").updateChildValues(["Thursday" : 0])
//                        self.ref.child("Classrooms").child(self.textField.text!).child("Calendar").child("Wednesday").updateChildValues(["Wednesday" : 0])
//                        self.ref.child("Classrooms").child(self.textField.text!).child("Calendar").child("Tuesday").updateChildValues(["Tuesday" : 0])
//                        self.ref.child("Classrooms").child(self.textField.text!).child("Calendar").child("Monday").updateChildValues(["Monday" : 0])
                        
                 self.ref.child("Classrooms").child(self.textField.text!).child("Messages").updateChildValues(["last_commended id": -1])
                    //update
                        self.updateClasses()
                    
                    }
                })
                
                
                
            }
            
            alert.addAction(doneButton)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Class code"
                self.textField = alertTextField
                //                /Users/michaelpeng/Desktop/ClassroomConnections/Pods/PKRevealController/Source/PKRevealController/PKRevealController.m:1363:1: Conflicting return type in implementation of 'supportedInterfaceOrientations': 'UIInterfaceOrientationMask' (aka 'enum UIInterfaceOrientationMask') vs 'NSUInteger' (aka 'unsigned long')
            }
            alert.addTextField { (alertTextField1) in
                alertTextField1.placeholder = "Class Topic"
                self.topicTextField = alertTextField1
                //                /Users/michaelpeng/Desktop/ClassroomConnections/Pods/PKRevealController/Source/PKRevealController/PKRevealController.m:1363:1: Conflicting return type in implementation of 'supportedInterfaceOrientations': 'UIInterfaceOrientationMask' (aka 'enum UIInterfaceOrientationMask') vs 'NSUInteger' (aka 'unsigned long')
            }
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else if (indexPath.row < classes.count){
            let identification = classes[indexPath.row].id
            
            ide = identification
            
            
            print("id : \(identification)")
            
            ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").updateChildValues(["ID" : identification, "Title" : classes[indexPath.row].classTitle ])
            
            performSegue(withIdentifier: "teacherToTabView", sender: self)
        }
        print("\(indexPath.row) row")
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { (action, view, completionHandler) in
                                            // Update data source when user taps action
//                                            self.classes.remove(at: indexPath.row)
                                            
                                            
                                            self.removeEverything(index: indexPath.row)
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
    //        if segue.identifier == "teacherToTabView" {
    //            let destinationVC = segue.destination as! TeacherClassChatViewController
    //            destinationVC.classRoomCode = ide
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //    }
}


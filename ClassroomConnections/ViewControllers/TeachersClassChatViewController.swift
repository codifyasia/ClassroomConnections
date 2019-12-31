//
//  ClassChatViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class TeacherClassChatViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var classRoomCode : String = "stuff"

    
    var messages: [Message] = [Message]()
    
    override func viewDidLoad() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        ref = Database.database().reference()
//        var messageDictionary = ["Sender" : Auth.auth().currentUser!.email, "MessageBody" : "Welcome to my class", "SenderID" : Auth.auth().currentUser!.uid]
//        ref.child("Classroom")
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            
            self.classRoomCode = identity
            
            
//            self.ref.child("Classrooms").child(identity).child("Messages").child("Message1").setValue(messageDictionary) {
//                (error, reference) in
//
//                if error != nil {
//                    print(error!)
//                } else {
//                    print("Message saved succesfully")
//                }
//            }
            self.retrieveMessages()
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        print("retrieving")
        self.tableView.reloadData()
        
        
    }
    
    @IBAction func signOut(_ sender: Any) {
    do {
        try Auth.auth().signOut()
        performSegue(withIdentifier: "backwards2", sender: self)
        
    }catch let signOutError as NSError {
        print("Logout Error")
    }
        
    }
    func retrieveMessages() {
        //        let messageDB =
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            
            self.classRoomCode = identity
            let messageDB = self.ref.child("Classrooms").child(identity).child("Messages")
            
                    messageDB.observe(.childAdded) { (snapshot) in

                        let snapshotValue = snapshot.value as! Dictionary<String,Any>
                        let Text = snapshotValue["MessageBody"]!
                         let Sender = snapshotValue["Sender"]!
                         let SenderID = snapshotValue["SenderID"]!
                         let messageT = snapshotValue["messageType"]!

            
                        let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID as! String, messageType: messageT as! String)
            
                        self.messages.append(message)
            
            
                            self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            
                }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
            
        let messagesDB = Database.database().reference().child("Classrooms").child(classRoomCode).child("Messages")
        print(messageTextField.text!)
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextField.text!,
                                "SenderID": Auth.auth().currentUser?.uid]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully!")
            }
        }
        messageTextField.text = ""
    }
    
    @IBAction func QuestionButton(_ sender: Any) {
        
    }
    
}
        //
        //                self.ref.child("Classrooms").child(identity).child("Messages").child("Message \(index)").observeSingleEvent(of: .value, with: { (snapshot1) in
        //
        //
        //                    guard let value1 = snapshot1.value as? NSDictionary else {
        //                        print("No Data!!!")
        //                        return
        //                    }
        //
        //                    let Text = value1["MessageBody"]!
        //                    print(Text)
        //                    let Sender = value1["Sender"]!
        //                    let SenderID = value1["SenderID"]
        //
        //                        print("ooooga \(Sender) \(Text) \(SenderID!)")
        //
        //                        let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID! as! String)
        //                    self.messages.append(message)
        //
        //                    self.tableView.reloadData()
        //
        //
        //
        //                }) { (error) in
        //                    print("error:\(error.localizedDescription)")
        //                }
extension TeacherClassChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        cell.senderName.text = "Sender: " + messages[indexPath.row].sender
        
        if cell.senderName.text == ("Sender: " + Auth.auth().currentUser!.email!) {
            cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 0.3)
            cell.rightImage?.tintColor = UIColor.systemTeal
        }
        return cell
    }
}
extension TeacherClassChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("person selected row : " + String(indexPath.row) + " (starts from 0)")
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        print("person swiped row: " + String(indexPath.row) +)
//        
//    }
}

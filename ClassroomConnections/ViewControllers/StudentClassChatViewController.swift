//
//  ClassChatViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class StudentClassChatViewController: UIViewController {
    
    var ref: DatabaseReference!
    

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var classRoomCode: String = "stuff"
    
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
            
                        let snapshotValue = snapshot.value as! Dictionary<String,String>
                        let Text = snapshotValue["MessageBody"]!
                        let Sender = snapshotValue["Sender"]!
                        let SenderID = snapshotValue["SenderID"]!
            
                        let message = Message(sender: Sender, body: Text, senderID: SenderID)
            
                        self.messages.append(message)
            
            
                            self.tableView.reloadData()
            

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
extension StudentClassChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        cell.senderName.text = messages[indexPath.row].senderID
        return cell
    }
}
extension StudentClassChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("person selected row : " + String(indexPath.row) + " (starts from 0)")
    }
}

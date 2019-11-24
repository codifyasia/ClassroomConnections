//
//  ClassChatViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class TeacherClassChatViewController: UIViewController {
    
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
        let messageDictionary : NSDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : "Welcome to my class!", "SenderID" : Auth.auth().currentUser?.uid]
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            
            self.classRoomCode = identity
            
            
            self.ref.child("Classrooms").child(identity).child("Messages").child(Auth.auth().currentUser!.uid).setValue(messageDictionary) {
                (error, reference) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Message saved succesfully")
                }
            }
            self.retrieveMessages()
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        print("retrieving")
        self.tableView.reloadData()
        
        
    }

    func retrieveMessages() {
//        let messageDB =
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            
            self.classRoomCode = identity
            
            
            self.ref.child("Classrooms").child(identity).child("Messages").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot1) in
                
                
                guard let value1 = snapshot1.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                
                let Text = value1["MessageBody"]!
                print(Text)
                let Sender = value1["Sender"]!
                let SenderID = value1["SenderID"]
                
                    print("ooooga \(Sender) \(Text) \(SenderID!)")
                    
                    let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID! as! String)
                self.messages.append(message)
                
                self.tableView.reloadData()
                
                
                
            }) { (error) in
                print("error:\(error.localizedDescription)")
            }
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
        
    }
}
extension TeacherClassChatViewController: UITableViewDataSource {
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
extension TeacherClassChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("person selected row : " + String(indexPath.row) + " (starts from 0)")
    }
}

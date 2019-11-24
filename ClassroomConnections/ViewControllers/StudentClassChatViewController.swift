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
    
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var classRoomCode : String = "stuff"
    var ref: DatabaseReference!
    
    var messages: [Message] = [Message]()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        ref = Database.database().reference()
        retrieveMessages()
        
    }
    func retrieveMessages() {
        let messageDB = ref.child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotvalue = snapshot.value as! Dictionary<String, String>
            
            let Text = snapshotvalue["MessageBody"]!
            let Sender = snapshotvalue["Sender"]!
            let SenderID = snapshotvalue["SenderID"]
            
            let message = Message(sender: Sender, body: Text, senderID: SenderID!)
            self.messages.append(message)
            
            
        }
    }
}
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

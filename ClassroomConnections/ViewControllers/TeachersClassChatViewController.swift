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
    var questionRow : Int! = 0
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var classRoomCode : String = "stuff"
    
    
    var messages: [Message] = [Message]()
    
    var answerOn: Bool = false
    
    
    
    @IBOutlet weak var answerLabel: UIButton!
    var answerIndex: Int = 0
    var checkIndex: Int = 0
    
    override func viewDidLoad() {
        print("buh")
        answerLabel.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.register(UINib(nibName: "replyCell", bundle: nil), forCellReuseIdentifier: "ReusableCell1")
        tableView.register(UINib(nibName: "messageSelfCell", bundle: nil), forCellReuseIdentifier: "ReusableCell2")
        ref = Database.database().reference()
        //        var messageDictionary = ["Sender" : Auth.auth().currentUser!.email, "MessageBody" : "Welcome to my class", "SenderID" : Auth.auth().currentUser!.uid]
        //        ref.child("Classroom")
        
        //        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
        //
        //                guard let value = snapshot.value as? NSDictionary else {
        //                    print("No Data!!!")
        //                    return
        //                }
        //                let identity = value["ID"] as! String
        //                let eacherID = value["TeacherID"] as! String
        //                self.classRoomCode = identity
        //                self.teacherID = eacherID
        //                self.className.text =  value["Title"] as! String
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            self.className.text = value["Title"] as! String
            
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
    
    @IBAction func answerSwitch(_ sender: Any) {
        answerLabel.isHidden = true
        answerOn = false
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
                let messageT : String = snapshotValue["messageType"]! as! String
                let messageIndex : Int = snapshotValue["Index"] as! Int
//                let unique : String = snapshotValue["childID"] as! String
                
                let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID as! String, messageType: messageT as! String, num: 0)
                
                if (messageT == "Answer") {
                    self.messages.insert(message, at: messageIndex)
                }
                else {
                    self.messages.append(message)
                }
                
                
                self.tableView.reloadData()
                if (self.questionRow == 0) {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                } else {
                    let indexPath = IndexPath(row: self.questionRow, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if (messageTextField.text! == "") {
            return
        }
        let messagesDB = Database.database().reference().child("Classrooms").child(classRoomCode).child("Messages")
        print(messageTextField.text!)
        print("entered sending message")
        var keyValue = String(messagesDB.childByAutoId().key!)
        keyValue = String(keyValue.dropLast(1))
        if (answerOn) {
            let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                     "MessageBody": messageTextField.text!,
                                     "SenderID": Auth.auth().currentUser?.uid,
                                     "messageType" : "Answer", "Upvotes" : 0, "Index" : answerIndex, "childID" : keyValue ] as [String : Any]
            messagesDB.child(keyValue).setValue(messageDictionary)
        
            answerOn = false
            answerLabel.isHidden = true
        } else {
            print("message type is saved as normal")
            let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                     "MessageBody": messageTextField.text!,
                                     "SenderID": Auth.auth().currentUser?.uid,
                                     "messageType" : "Normal", "Index" : 0, "childID" : keyValue] as [String : Any]
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
        messageTextField.text = ""
    }
    
    
}

extension TeacherClassChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (messages[indexPath.row].messageType == "Answer") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell1", for: indexPath) as! replyCell
            cell.label.text = messages[indexPath.row].body
            cell.senderName.text = "Sender: " + messages[indexPath.row].sender
            
            if (messages[indexPath.row].senderID == Auth.auth().currentUser!.uid) {
                cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                cell.rightImage.image = UIImage(named : "synopsisscan")
                cell.rightImage?.tintColor = UIColor.systemRed
                
            } else {
                cell.messageBubble.backgroundColor = UIColor(red: 100.0*0.6/255.0, green: 96.0*0.6/255.0, blue: 255.0*0.6/255.0, alpha: 0.3)
                cell.rightImage?.tintColor = UIColor.systemIndigo
                cell.rightImage.image = UIImage(named : "study")
            }
            
            
            //cell.rightImage?.tintColor = UIColor.systemTeal
            
            return cell
        } else {
            if (messages[indexPath.row].senderID == Auth.auth().currentUser!.uid) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell2", for: indexPath) as! messageSelfCell
                //cell.senderName.isHidden = true //TAKE NOTICE OF THIS THIS ISS WHERE THE SENDER: ID IS DELTED THIS IS THE LINE THIS IS THE LINE I REPEAT THIS IS THE LINE
                
                cell.label.text = messages[indexPath.row].body
                cell.senderName.text = "Sender: " + messages[indexPath.row].sender
                
                cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                cell.rightImage?.tintColor = UIColor.systemRed
                
                if messages[indexPath.row].messageType == "Question" {
                    cell.rightImage.image = UIImage(named: "request")
                } else if messages[indexPath.row].messageType == "Normal" {
                    cell.rightImage.image = UIImage(named: "synopsisscan")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
                //                cell.senderName.isHidden = true
                cell.label.text = messages[indexPath.row].body
                cell.senderName.text = "Sender: " + messages[indexPath.row].sender
                cell.messageBubble.backgroundColor = UIColor(red: 100.0*0.6/255.0, green: 96.0*0.6/255.0, blue: 255.0*0.6/255.0, alpha: 0.3)
                cell.rightImage?.tintColor = UIColor.systemIndigo
                if messages[indexPath.row].messageType == "Question" {
                    cell.rightImage.image = UIImage(named: "request")
                } else if messages[indexPath.row].messageType == "Normal" {
                    cell.rightImage.image = UIImage(named: "study")
                }
                return cell
            }
        }
    }
    
}
extension TeacherClassChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = indexPath.row
        
        var message = messages[selected]
        
        if (message.messageType == "Question") {
            questionRow = selected
            let alert = UIAlertController(title: "Respond to Question", message: message.body, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            
            let answer = UIAlertAction(title: "Answer", style: .default) { (action) in
                //                if (self.questionOn) {
                //                    self.questionSwitch(nil)
                //                }
                self.answerOn = true
                self.answerLabel.isHidden = false
                self.answerIndex = indexPath.row+1
            }
            
            
            
            alert.addAction(answer)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        else if(message.messageType == "Answer") {
            questionRow = selected
            let alert = UIAlertController(title: "Respond To Answer", message: message.body, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            
            let answer = UIAlertAction(title: "Commend", style: .default) { (action) in
                //                if (self.questionOn) {
                //                    self.questionSwitch(nil)
                //                }
                self.checkIndex = indexPath.row+1
        
            }
            
            
            
            alert.addAction(answer)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        else {
            questionRow = 0
        }
    }
}

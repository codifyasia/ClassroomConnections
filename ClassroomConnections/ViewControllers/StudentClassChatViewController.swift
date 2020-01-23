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
    var teacherID : String = "teacherId"
    @IBOutlet weak var qSwitch: UISwitch!
    
    var messages: [Message] = [Message]()
    var messagesID : [String] = [String]()
    @IBOutlet weak var className: UILabel!
    
    //if question is on
    var questionOn : Bool = false
    var answerOn : Bool = false
    @IBOutlet weak var answerLabel: UIButton!
    var answerIndex : Int = 0
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        signOutButton.backgroundColor = .clear
        signOutButton.layer.cornerRadius = 5
        signOutButton.layer.borderWidth = 2
        signOutButton.layer.borderColor = UIColor.systemIndigo.cgColor
        answerLabel.backgroundColor = .clear
        answerLabel.layer.cornerRadius = 5
        answerLabel.layer.borderWidth = 2
        answerLabel.layer.borderColor = UIColor.systemIndigo.cgColor
        answerLabel.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self 
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.register(UINib(nibName: "replyCell", bundle: nil), forCellReuseIdentifier: "ReusableCell1")
        tableView.register(UINib(nibName: "messageSelfCell", bundle: nil), forCellReuseIdentifier: "ReusableCell2")
        ref = Database.database().reference()
        //        var messageDictionary = ["Sender" : Auth.auth().currentUser!.email, "MessageBody" : "Welcome to my class", "SenderID" : Auth.auth().currentUser!.uid]
        //        ref.child("Classroom")
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            let eacherID = value["TeacherID"] as! String
            self.classRoomCode = identity
            self.teacherID = eacherID
            self.className.text =  value["Title"] as! String

            
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
    
    @IBAction func questionSwitch(_ sender: UISwitch?) {
        if (sender == nil) {
            questionOn = false
        }
        else if (sender!.isOn) {
            questionOn = true
            print("question switch is on")
        }
        else {
            questionOn = false
            print("question switch is off")
        }
    }
    @IBAction func answerOffSwitch(_ sender: Any) {
        answerOn = false
        answerLabel.isHidden = true
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "backwards1", sender: self)
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
                
                let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID as! String, messageType: messageT as! String)
                
                if (messageT == "Answer") {
                    self.messages.insert(message, at: messageIndex)
                }
                else {
                    self.messages.append(message)
                }
                
                
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                
            }
            
        }
        
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let messagesDB = Database.database().reference().child("Classrooms").child(classRoomCode).child("Messages")
        print(messageTextField.text!)
        if (answerOn) {
            let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
            "MessageBody": messageTextField.text!,
            "SenderID": Auth.auth().currentUser?.uid,
            "messageType" : "Answer", "Upvotes" : 0, "Index" : answerIndex] as [String : Any]
//            let hi =
            messagesDB.childByAutoId().setValue(messageDictionary) {
                (error, reference) in
                
                if error != nil {
                    print(error!)
                }
                else {
                    print("Message saved successfully!")
                }
            }
            answerOn = false
            answerLabel.isHidden = true
        }
        else if (questionOn) {
            print("message type is saved as question")
            let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                     "MessageBody": messageTextField.text!,
                                     "SenderID": Auth.auth().currentUser?.uid,
                                     "messageType" : "Question", "Upvotes" : 0, "Index" : 0] as [String : Any]
            
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
        else {
            print("message type is saved as normal")
            let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                     "MessageBody": messageTextField.text!,
                                     "SenderID": Auth.auth().currentUser?.uid,
                                     "messageType" : "Normal", "Index" : 0] as [String : Any]
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
        
        print("checking the message type: the message type is" + messages[indexPath.row].messageType)
//        print(messages)
        if (messages[indexPath.row].messageType == "Answer") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell1", for: indexPath) as! replyCell

            cell.label.text = messages[indexPath.row].body
                   cell.senderName.text = "Sender: " + messages[indexPath.row].senderID

//
                   if cell.senderName.text == "Sender: " + Auth.auth().currentUser!.uid {
                       cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1)
                    cell.rightImage?.tintColor = UIColor.systemIndigo
                   } else if (cell.senderName.text == "Sender: " + self.teacherID) {
                    cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                    cell.rightImage?.tintColor = UIColor.systemRed
                   } else {
                    cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                    cell.rightImage?.tintColor = UIColor.systemIndigo

            }
            
//                    cell.rightImage?.tintColor = UIColor.systemIndigo

//                   cell.rightImage.image = UIImage(systemName: "exclamationmark.square")
                   return cell
        } else {
            
            if (messages[indexPath.row].senderID == Auth.auth().currentUser!.uid) {
                print("im gay boi")
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell2", for: indexPath) as! messageSelfCell
                cell.label.text = messages[indexPath.row].body
                cell.senderName.text = "Sender: " + messages[indexPath.row].senderID
                if cell.senderName.text == "Sender: " + Auth.auth().currentUser!.uid {
                    cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1)
                    cell.rightImage?.tintColor = UIColor.systemIndigo
                } else if (cell.senderName.text == "Sender: " + self.teacherID) {
                    cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                    cell.rightImage.image = UIImage(named: "synopsisscan")
                    cell.rightImage?.tintColor = UIColor.systemRed
                    return cell
                } else {
                 cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                 cell.rightImage?.tintColor = UIColor.systemIndigo
                    }
                cell.messageBubble.backgroundColor = UIColor.systemIndigo
                    cell.rightImage?.tintColor = UIColor.systemIndigo

                  if messages[indexPath.row].messageType == "Question" {
                        cell.rightImage.image = UIImage(named : "request")
                  } else if messages[indexPath.row].messageType == "Normal" {
                        cell.rightImage.image = UIImage(named: "study")
                  }
                 return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
                cell.label.text = messages[indexPath.row].body
                cell.senderName.text = "Sender: " + messages[indexPath.row].senderID
                 if cell.senderName.text == "Sender: " + Auth.auth().currentUser!.uid {
                     cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1)
                  cell.rightImage?.tintColor = UIColor.systemIndigo
                 } else if (cell.senderName.text == "Sender: " + self.teacherID) {
                    cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                    cell.rightImage.image = UIImage(named: "synopsisscan")
                    cell.rightImage?.tintColor = UIColor.systemRed
                    return cell
                 } else {
                    cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                    cell.rightImage?.tintColor = UIColor.systemIndigo
                }
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
extension StudentClassChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = indexPath.row
        
        let message = messages[selected]
        
        if (message.messageType == "Question") {
            let alert = UIAlertController(title: "Respond to Question", message: message.body, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            let upvote = UIAlertAction(title: "Upvote", style: .default) { (action) in
                self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").observeSingleEvent(of: .value, with: { (snapshot) in
    
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
                            
            }
            let answer = UIAlertAction(title: "Answer", style: .default) { (action) in
//                if (self.questionOn) {
//                    self.questionSwitch(nil)
//                }
                self.qSwitch.isOn = false
                self.answerOn = true
                self.answerLabel.isHidden = false
                self.answerIndex = indexPath.row+1
            }
            
           
            alert.addAction(answer)
            alert.addAction(upvote)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        
//        print(message.body)
//
//
//
//        print("person selected row : " + String(indexPath.row) + " (starts from 0)")
//        print(messages[indexPath.row].messageType)
    }

}

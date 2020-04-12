//
//  ClassChatViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class StudentClassChatViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    var questionRow : Int! = 0
    
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var classRoomCode: String = "stuff"
    var teacherID : String = "teacherId"
    @IBOutlet weak var qSwitch: UISwitch!
    
    var messages: [Message] = [Message]()
    var messagesID : [String] = [String]()
    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    var currentY : CGFloat = 0
    //if question is on
    var questionOn : Bool = false
    var answerOn : Bool = false
    @IBOutlet weak var answerLabel: UIButton!
    var answerIndex : Int = 0
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        currentY = bottomView.frame.origin.y
        messageTextField.delegate = self
        signOutButton.backgroundColor = .clear
        signOutButton.layer.cornerRadius = 5
//        signOutButton.layer.borderWidth = 2
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
            print("--------------------")
            print(value["Title"])
            print("--------------------")
            let identity = value["ID"] as! String
            let eacherID = value["TeacherID"] as! String
            let title = value["Title"] as! String
            print(title)
            print(Auth.auth().currentUser!.uid)
            self.className.text = title
            self.classRoomCode = identity
            self.teacherID = eacherID
            
            
            
            self.retrieveMessages()
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        print("retrieving")
        self.tableView.reloadData()
        
        
        
    }
    

    @objc func keyboradWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomView.frame.origin.y = self.view!.bounds.height - bottomView.frame.height
        self.tabBarController?.tabBar.isHidden = true
        print("textfield start")
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomView.frame.origin.y = currentY
        self.tabBarController?.tabBar.isHidden = false
        print("textfield finish")
    }
    
    func retrieveMessages() {
        
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            
            self.classRoomCode = identity
            let messageDB = self.ref.child("Classrooms").child(identity).child("Messages")
            
            messageDB.observe(.childChanged) { (snapshot) in
                print("something was changed in messageDB")
                messageDB.observeSingleEvent(of: .value) { (snapshot) in
                    guard let val = snapshot.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    let rowChanged = val["last_commended id"] as! Int
                    print(rowChanged)
                    self.messages[rowChanged].correct = true
                    self.tableView.reloadData()
                }
                
                
            }
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                print("something was added in messageDB")
                if (!snapshot.hasChildren()) {
                    return
                }
                let snapshotValue = snapshot.value as! Dictionary<String,Any>
                let Text = snapshotValue["MessageBody"]!
                let Sender = snapshotValue["Sender"]!
                let SenderID = snapshotValue["SenderID"]!
                let messageT : String = snapshotValue["messageType"]! as! String
                let messageIndex : Int = snapshotValue["Index"] as! Int
                let id : Int = snapshotValue["ID"] as! Int
                let correct1 : Bool = snapshotValue["correct"] as! Bool
                //                let unique : String = snapshotValue["childID"] as! String
                
                let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID as! String, messageType: messageT as! String, ID: id, correct: correct1, name: "")
                
                if (messageT == "Answer") {
                    self.messages.insert(message, at: messageIndex)
                }
                else {
                    self.messages.append(message)
                }

                self.tableView.reloadData()
                var indexPath : IndexPath
                if (self.questionRow == 0) {
                    indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                } else {
                    indexPath = IndexPath(row: self.questionRow, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                
                if (messageT != "Answer") {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                
            }
        }
        
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        print("message sending")
        
        if (messageTextField.text == "" || messageTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
            return
        }
        let messagesDB = Database.database().reference().child("Classrooms").child(classRoomCode).child("Messages")
        print(messageTextField.text!)
        
        var generatorNum : Int = 5
        ref.child("Classrooms").child(classRoomCode).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            
            generatorNum = value["Generator"] as! Int
            
            
            
            
            print(generatorNum+1)
            self.ref.child("Classrooms").child(self.classRoomCode).updateChildValues(["Generator" : generatorNum+1])
            
            let randomID = messagesDB.childByAutoId()
            var childId : String = randomID.key!
            if (self.answerOn) {
                
                let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                         "MessageBody": self.messageTextField.text!,
                                         "SenderID": Auth.auth().currentUser?.uid,
                                         "messageType" : "Answer", "Upvotes" : 0, "Index" : self.answerIndex, "ID" : generatorNum+1, "correct" : false] as [String : Any]
                
                
                messagesDB.child(String(generatorNum+1)).setValue(messageDictionary)
                self.answerOn = false
                self.answerLabel.isHidden = true
//                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            else if (self.questionOn) {
                print("message type is saved as question")
                let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                         "MessageBody": self.messageTextField.text!,
                                         "SenderID": Auth.auth().currentUser?.uid,
                                         "messageType" : "Question", "Upvotes" : 0, "Index" : 0, "ID" : generatorNum+1, "correct": false] as [String : Any]
                
                messagesDB.child(String(generatorNum+1)).setValue(messageDictionary) {
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
                                         "MessageBody": self.messageTextField.text!,
                                         "SenderID": Auth.auth().currentUser?.uid,
                                         "messageType" : "Normal", "Index" : 0, "ID" : generatorNum+1, "correct": false] as [String : Any]
                messagesDB.child(String(generatorNum+1)).setValue(messageDictionary) {
                    (error, reference) in
                    
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print("Message saved successfully!")
                    }
                }
            }
            self.messageTextField.text = ""
        }
        
        
        
    }
    
}

extension StudentClassChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (messages[indexPath.row].messageType == "Answer") {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell1", for: indexPath) as! replyCell
            
            
            
            cell.label.text = messages[indexPath.row].body
//            cell.senderName.text = "Sender: " + messages[indexPath.row].senderID
            
            //
            if messages[indexPath.row].senderID == Auth.auth().currentUser!.uid {
                cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1)
                cell.rightImage?.tintColor = UIColor.systemIndigo
            } else if (messages[indexPath.row].senderID == self.teacherID) {
                
                cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                cell.rightImage?.tintColor = UIColor.systemRed
            } else {
                cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                cell.rightImage?.tintColor = UIColor.systemIndigo
                
            }
            if (!messages[indexPath.row].correct) {
                cell.checkmark.isHidden = true
            }
            
            if (messages[indexPath.row].correct) {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
            cell.senderName.text = ""
            return cell
        } else {
             print("HELLO" + messages[indexPath.row].senderID + " " + Auth.auth().currentUser!.uid)
            if (messages[indexPath.row].senderID == Auth.auth().currentUser!.uid) {
                print("im gay boi")
               
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell2", for: indexPath) as! messageSelfCell
                cell.label.text = messages[indexPath.row].body
                cell.senderName.text = "Sender: " + messages[indexPath.row].senderID
                
                if messages[indexPath.row].senderID == Auth.auth().currentUser!.uid {
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
        
        print(message.messageType)
        
        if (message.messageType == "Question") {
            questionRow = selected
            let alert = UIAlertController(title: "Respond to Question", message: message.body, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
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
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        if (message.messageType == "Answer") {
            let mark = UIAlertAction(title: "Mark as Correct", style: .default) { (action) in
                //                if (self.questionOn) {
                //                    self.questionSwitch(nil)
                //                }
                self.qSwitch.isOn = false
                self.answerOn = true
                self.answerLabel.isHidden = false
                //self.messages[indexPath.row].num = 1
            }
            let alert = UIAlertController(title: "Respond to Question", message: message.body, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            alert.addAction(mark)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        else {
            questionRow = 0
        }
        
        //        print(message.body)
        //
        //
        //
        //        print("person selected row : " + String(indexPath.row) + " (starts from 0)")
        //        print(messages[indexPath.row].messageType)
    }
    
}

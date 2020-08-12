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
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var classRoomCode : String = "stuff"
    var currentY : CGFloat = 0
    
    
    var messages: [Message] = [Message]()
    
    var answerOn: Bool = false
    var tappable : Bool = true
    
    var bottomViewY : CGFloat = 0
    var tableViewH : CGFloat = 0
    
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var answerLabel: UIButton!
    var answerIndex: Int = 0
    var checkIndex: Int = 0
    
    //    var firstName : String = "error"
    //    var lastName : String = "error"
    
    
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround() 
        bottomViewY = bottomView.frame.origin.y
        tableViewH = tableView.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        currentY = bottomView.frame.origin.y
        answerLabel.isHidden = true
        messageTextField.delegate = self
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
            //            self.firstName = value["FirstName"] as! String
            //            self.lastName = value["LastName"] as! String
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
        //        print("retrieving")
        self.tableView.reloadData()
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let height = self.tabBarController?.tabBar.frame.size.height
            bottomConstraints.constant = -(keyboardSize.height-height!)
            self.updateViewConstraints()
            self.bottomView.frame.origin.y -= (keyboardSize.height - height!)
            self.tableView.frame.size.height -= (keyboardSize.height - height!)
            if messages.capacity != 0 {
                let lastIndexPath = tableView.indexPathsForVisibleRows?.last
                tableView.scrollToRow(at: lastIndexPath!, at: .bottom, animated: true)
            }
            
            
        }
        
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            bottomConstraints.constant = 0
            self.updateViewConstraints()
            self.bottomView.frame.origin.y = bottomViewY
            self.tableView.frame.size.height = tableViewH
            if messages.capacity != 0 {
                let lastIndexPath = tableView.indexPathsForVisibleRows?.last
                tableView.scrollToRow(at: lastIndexPath!, at: .bottom, animated: true)
                print(lastIndexPath?.row)
            }
            
        }
    }
    
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        tappable = false
    //        bottomView.frame.origin.y = self.view!.bounds.height - bottomView.frame.height
    //        let bottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    //        NSLayoutConstraint.activate([bottomConstraint])
    //        self.tabBarController?.tabBar.isHidden = true
    //
    //    }
    //
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        bottomView.frame.origin.y = currentY
    //        let bottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    //        NSLayoutConstraint.activate([bottomConstraint])
    //        self.tabBarController?.tabBar.isHidden = false
    //    }
    
    @IBAction func answerSwitch(_ sender: Any) {
        answerLabel.isHidden = true
        answerOn = false
    }
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "backwards2", sender: self)
            
        } catch let signOutError as NSError {
            print("Logout Error")
        }
        
    }
    func retrieveMessages() {
        //        let messageDB =
        //        messages = []
        self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            let identity = value["ID"] as! String
            
            self.classRoomCode = identity
            let messageDB = self.ref.child("Classrooms").child(identity).child("Messages")
            
            //            messageDB.queryOrderedByKey()
            
            messageDB.observe(.childChanged) { (snapshot) in
                
                self.tableView.reloadData()
                
                
            }
            messageDB.observe(.childAdded) { (snapshot) in
                
                if (!snapshot.hasChildren()) {
                    return
                }
                let snapshotValue = snapshot.value as! Dictionary<String,Any>
                let Text = snapshotValue["MessageBody"] as! String
                let Sender = snapshotValue["Sender"]!
                let SenderID = snapshotValue["SenderID"]!
                let messageT : String = snapshotValue["messageType"]! as! String
                let messageIndex : Int = snapshotValue["Index"] as! Int
                let id : Int = snapshotValue["ID"] as! Int
                let correct1 : Bool = snapshotValue["correct"] as! Bool
                let ans : Int = snapshotValue["Answers"] as! Int
                let first : String = snapshotValue["FirstName"] as! String
                let last : String = snapshotValue["LastName"] as! String
                //                let unique : String = snapshotValue["childID"] as! String
                
                //                self.ref.child("Classrooms").child(String(classRoomCode)).child("Messages").queryOrdered(byChild: <#T##String#>)
                //                self.ref.child("UserInfo").child(String(SenderID as! String)).observeSingleEvent(of: .value) { (snapshot2) in
                //
                //                    guard let value2 = snapshot2.value as? NSDictionary else {
                //                        print("No Data!!!")
                //                        return
                //                    }
                
                
                //                    let name1 = value2["LastName"] as! String
                
                //                    let name = self.firstName + " " + self.lastName
                //                    print("the name:\(name)")
                
                let message = Message(sender: Sender as! String, body: Text as! String, senderID: SenderID as! String, messageType: messageT as! String, ID: id, correct: correct1, name: first + " " + last, answers: ans)
                
                
                print("yote:" + String(Text))
                print(messageIndex)
                //                self.messages.append(message)
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
                    //                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                } else {
                    indexPath = IndexPath(row: self.questionRow, section: 0)
                    //                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                
                
                if (messageT != "Answer") {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            
            //            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if (messageTextField.text! == "") {
            return
        }
        let messagesDB = Database.database().reference().child("Classrooms").child(classRoomCode).child("Messages")
        
        var generatorNum : Int = 5
        ref.child("Classrooms").child(classRoomCode).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            
            generatorNum = value["Generator"] as! Int
            
            
            
            
            
            self.ref.child("Classrooms").child(self.classRoomCode).updateChildValues(["Generator" : generatorNum+1])
            
            
            
            
            self.ref.child("UserInfo").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot6) in
                
                guard let store = snapshot6.value as? NSDictionary else {
                    print("No Data!!!")
                    return
                }
                
                let firstName = store["FirstName"] as! String
                let lastName = store["LastName"] as! String
                if (self.answerOn) {
                    
                    //                print(String(self.messages[self.answerIndex-1].ID))
                    //                self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").child(String(self.messages[self.answerIndex-1].ID)).observeSingleEvent(of: .value) { (snapshot5) in
                    //                    guard let v1 = snapshot5.value as? NSDictionary else {
                    //                        print("No Data!!!")
                    //                        return
                    //                    }
                    //
                    //
                    //                    let ans = v1["Answers"] as! Int
                    //                    print(ans)
                    //
                    //
                    //                    self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").child(String(self.messages[self.answerIndex-1].ID)).updateChildValues(["Answers": ans+1])
                    //                    self.messages[self.answerIndex-1].answers = ans+1
                    //
                    //                    let b = self.answerIndex+ans
                    
                    
                    
                    
                    
                    
                    self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").child(String(self.messages[self.answerIndex-1].ID)).observeSingleEvent(of: .value) { (snapshot5) in
                        guard let v1 = snapshot5.value as? NSDictionary else {
                            print("No Data!!!")
                            return
                        }
                        
                        
                        let ans = v1["Answers"] as! Int
                        
                        
                        
                        self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").child(String(self.messages[self.answerIndex-1].ID)).updateChildValues(["Answers": ans+1])
                        self.messages[self.answerIndex-1].answers = ans+1
                        
                        let b = self.answerIndex+ans as! Int
                        
                        print("Answers:"+String(ans) + "Index" + String(self.answerIndex))
                        print("b:" + String(b))
                        
                        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                                 "MessageBody": self.messageTextField.text!,
                                                 "SenderID": Auth.auth().currentUser?.uid,
                                                 "messageType" : "Answer", "Upvotes" : 0, "Index" : b, "ID" : generatorNum+1, "correct": false, "Answers": 0, "FirstName" : firstName, "LastName": lastName  ] as [String : Any]
                        messagesDB.child(String(generatorNum+1)).setValue(messageDictionary)
                        
                        self.answerOn = false
                        self.answerLabel.isHidden = true
                        self.messageTextField.text = ""
                        
                    }
                } else {
                    //                print("message type is saved as normal")
                    let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                             "MessageBody": self.messageTextField.text!,
                                             "SenderID": Auth.auth().currentUser?.uid,
                                             "messageType" : "Normal", "Index" : 0, "ID" : generatorNum+1, "correct": false, "Answers": 0, "FirstName" : firstName, "LastName": lastName  ] as [String : Any]
                    messagesDB.child(String(generatorNum+1)).setValue(messageDictionary) {
                        (error, reference) in
                        
                        if error != nil {
                            print(error!)
                        }
                        else {
                            //                        print("Message saved successfully!")
                        }
                        
                    }
                    self.messageTextField.text = ""
                }
            }
            
        }
    }
    
    
}

extension TeacherClassChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print(messages[indexPath.row].name)
        if (messages[indexPath.row].messageType == "Answer") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell1", for: indexPath) as! replyCell
            cell.senderName.isHidden = false
            cell.senderName.text = messages[indexPath.row].name
            cell.label.text = messages[indexPath.row].body
            //            cell.senderName.text = "Sender: " + messages[indexPath.row].sender
            
            if (messages[indexPath.row].senderID == Auth.auth().currentUser!.uid) {
                cell.messageBubble.backgroundColor =  UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
                cell.rightImage.image = UIImage(named : "synopsisscan")
                cell.rightImage?.tintColor = UIColor.systemRed
                
            } else {
                cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1)
                cell.rightImage?.tintColor = UIColor.systemIndigo
                cell.rightImage.image = UIImage(named : "study")
            }
            
            //            print("\(messages[indexPath.row].body) + \(messages[indexPath.row].correct)")
            
            if (messages[indexPath.row].correct) {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
            
            
            //cell.rightImage?.tintColor = UIColor.systemTeal
            
            return cell
        } else {
            if (messages[indexPath.row].senderID == Auth.auth().currentUser!.uid) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell2", for: indexPath) as! messageSelfCell
                cell.senderName.isHidden = false
                cell.senderName.text = messages[indexPath.row].name
                //cell.senderName.isHidden = true //TAKE NOTICE OF THIS THIS ISS WHERE THE SENDER: ID IS DELTED THIS IS THE LINE THIS IS THE LINE I REPEAT THIS IS THE LINE
                
                cell.label.text = messages[indexPath.row].body
                //                cell.senderName.text = "Sender: " + messages[indexPath.row].sender
                
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
                cell.senderName.isHidden = false
                cell.senderName.text = messages[indexPath.row].name
                cell.label.text = messages[indexPath.row].body
                //                cell.senderName.text = "Sender: " + messages[indexPath.row].sender
                cell.messageBubble.backgroundColor = UIColor(red: 100.0/255.0, green: 96.0/255.0, blue: 255.0/255.0, alpha: 1)
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
        if tappable {
            
            var message = messages[selected]
            //            print(message.ID)
            
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
                if (!self.messages[selected].correct) {
                    questionRow = selected
                    let alert = UIAlertController(title: "Respond To Answer", message: message.body, preferredStyle: .actionSheet)
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                        
                    }
                    
                    let answer = UIAlertAction(title: "Commend", style: .default) { (action) in
                        
                        
                        
                        
                        //                        print("----switching checkmark to visible------")
                        self.checkIndex = self.questionRow+1
                        self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").updateChildValues(["last_commended id": self.questionRow])
                        self.ref.child("Classrooms").child(self.classRoomCode).child("Messages").child(String(message.ID)).updateChildValues(["correct": true])
                        
                        self.messages[self.questionRow].correct = true
                        self.tableView.reloadData()
                        
                        
                    }
                    
                    
                    
                    alert.addAction(answer)
                    alert.addAction(cancel)
                    present(alert, animated: true)
                }
                
            }
            else {
                questionRow = 0
            }
        }
        else {
            tappable = true
        }
    }
}

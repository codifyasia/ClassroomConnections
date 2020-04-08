//
//  StudentConflictCalendar.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class StudentConflictCalendar: UIViewController {
    var ref : DatabaseReference!
    var day: String = ""
    var ClassID: String!
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thurs: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var Submit: UIButton!
    @IBOutlet weak var submittedMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getClassID()
        mon.layer.cornerRadius = mon.frame.size.height / 5
        tues.layer.cornerRadius = tues.frame.size.height / 5
        wed.layer.cornerRadius = wed.frame.size.height / 5
        thurs.layer.cornerRadius = thurs.frame.size.height / 5
        fri.layer.cornerRadius = fri.frame.size.height / 5
        Submit.layer.cornerRadius = Submit.frame.size.height / 5

        // Do any additional setup after loading the view.
    }
    
    @IBAction func monPressed(_ sender: Any) {
        day = "monday"
        resetAllButtonColors()
        mon.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
        
    }
    
    @IBAction func tuesPressed(_ sender: Any) {
        day = "tuesday"
        resetAllButtonColors()
        tues.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
    }
    
    @IBAction func wedPressed(_ sender: Any) {
        day = "wednesday"
        resetAllButtonColors()
        wed.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
    }
    
    @IBAction func thursPressed(_ sender: Any) {
        day = "thursday"
        resetAllButtonColors()
        thurs.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
    }
    
    @IBAction func friPressed(_ sender: Any) {
        day = "friday"
        resetAllButtonColors()
        fri.backgroundColor = UIColor(red: (88.0 * 0.75)/255.0, green: (86.0*0.75)/255.0, blue: (214.0*0.75)/255.0, alpha: 1.0)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        var numForADay : Int = 0
        if (day == "") {
            return
        }
        ref.child("Classrooms").child(ClassID).child("Students").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in uid in classrooms in students in submitpressed")
                return
            }
            var didStudentAlreadySubmit = value["SubmitStatus"] as! Bool
            if (didStudentAlreadySubmit == false)
            {
                self.ref.child("Classrooms").child(self.ClassID).child("Calendar").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    guard let value = snapshot.value as? NSDictionary else {
                        print("no data in calendar")
                        return
                    }
//                    var bing = ""
                    numForADay = value[self.day] as! Int
//                    if (self.day == "monday") {
//                        bing = "Monday"
//                    }
//                    else if (self.day == "tuesday") {
//                        bing = "Tuesday"
//                    }
//                    else if (self.day == "wednesday") {
//                        bing = "Wednesday"
//                    }
//                    else if (self.day == "thursday") {
//                        bing = "Thursday"
//                    }
//                    else if (self.day == "friday") {
//                        bing = "Friday"
//                    }
                    self.ref.child("Classrooms").child(self.ClassID).child("Calendar").updateChildValues([self.day : numForADay + 1])
                    //self.ref.child("Classrooms").child(self.ClassID).child("Calendar").child(bing).updateChildValues([bing : numForADay + 1])
                    self.ref.child("Classrooms").child(self.ClassID).child("Students").child(Auth.auth().currentUser!.uid).updateChildValues(["SubmitStatus" : true, "id" : Auth.auth().currentUser!.uid])
                    self.Submit.isHidden = true
                    self.submittedMessage.isHidden = false
                    
                }) { (error) in
                    print("error:\(error.localizedDescription)")
                }
            }
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    func resetAllButtonColors() {
        mon.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        tues.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        fri.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        thurs.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        wed.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    
    func getClassID() {
        ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in uid in classrooms in students in updatesubmitbutton status")
                return
            }
            self.ClassID = value["ID"] as? String
            self.checkIfResetSubmissions()
            print("uid: " + Auth.auth().currentUser!.uid)
            print("classid: " + self.ClassID)
            self.ref.child("Classrooms").child(self.ClassID).child("Students").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                guard let value = snapshot.value as? NSDictionary else {
                    print("no data in uid in classrooms in students in updatesubmitbutton status")
                    return
                }
                var SubmittedStatus = value["SubmitStatus"] as! Bool
                if (SubmittedStatus == true) {
                    self.Submit.isHidden = true
                } else {
                    self.submittedMessage.isHidden = true
                }
                
            }) { (error) in
                print("error:\(error.localizedDescription)")
            }
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }

    }
    
    func checkIfResetSubmissions() {

        print("inside auto update lavbels")
        let messageDB = self.ref.child("Classrooms").child(ClassID).child("Students")
        messageDB.observe(.childChanged) { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in uid in classrooms in students in updatesubmitbutton status")
                return
            }
            if (snapshot.key == Auth.auth().currentUser!.uid) {
                var SubmittedStatus = value["SubmitStatus"] as! Bool
                print(SubmittedStatus)
                if (SubmittedStatus == false) {
                    self.Submit.isHidden = false
                    self.submittedMessage.isHidden = true
                }
            }
            
        }
    }


}

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
        updateSubmitButtonStatus()

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
                    
                    numForADay = value[self.day] as! Int
                    self.ref.child("Classrooms").child(self.ClassID).child("Calendar").updateChildValues([self.day : numForADay + 1])
                    self.ref.child("Classrooms").child(self.ClassID).child("Students").child(Auth.auth().currentUser!.uid).updateChildValues(["SubmitStatus" : true])
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
    
    func updateSubmitButtonStatus() {
        print("uid: " + Auth.auth().currentUser!.uid)
        print("classid: " + ClassID)
        ref.child("Classrooms").child(self.ClassID).child("Students").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
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
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }

    }
    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

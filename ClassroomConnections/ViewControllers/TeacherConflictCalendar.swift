//
//  TeacherConflictCalendar.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 11/24/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit
import Firebase

class TeacherConflictCalendar: UIViewController {
    var ref : DatabaseReference!
    var ClassID: String!
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thurs: UIButton!
    @IBOutlet weak var thursLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var fri: UIButton!
    var numStudents : Int = 0
    var numVoters: Int = 0
    var monValue: Double = 0
    var tuesValue: Double = 0
    var wedValue: Double = 0
    var thursValue: Double = 0
    var friValue: Double = 0
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        ref = Database.database().reference()
        ClassID = "dlkgjdgldrkjgd"
        print("going into class id")
        getClassID()
        
        mon.layer.cornerRadius = mon.frame.size.height / 5
        tues.layer.cornerRadius = tues.frame.size.height / 5
        wed.layer.cornerRadius = wed.frame.size.height / 5
        thurs.layer.cornerRadius = thurs.frame.size.height / 5
        fri.layer.cornerRadius = fri.frame.size.height / 5
        resetButton.layer.cornerRadius = fri.frame.size.height / 5
        
        print(monValue)
        print(tuesValue)
        print(wedValue)
        print(thursValue)
        print(friValue)
        //autoUpdateLabels()
        // Do any additional setup after loading the view.
    }
    
    func resetAllButtonColors() {
        mon.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        tues.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        fri.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        thurs.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        wed.backgroundColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }
    func resetDayLabels() {
        monLabel.text = (String)((Int)(monValue * 100)) + "%"
        tuesLabel.text = (String)((Int)(tuesValue * 100)) + "%"
        wedLabel.text = (String)((Int)(wedValue * 100)) + "%"
        thursLabel.text = (String)((Int)(thursValue * 100)) + "%"
        friLabel.text = (String)((Int)(friValue * 100)) + "%"
        
        
        self.mon.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.monValue))/255.0), green: CGFloat((86.0*(1-self.monValue))/255.0), blue: CGFloat((214.0*(1-self.monValue))/255.0), alpha: 1.0)
        self.tues.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.tuesValue))/255.0), green: CGFloat((86.0*(1-self.tuesValue))/255.0), blue: CGFloat((214.0*(1-self.tuesValue))/255.0), alpha: 1.0)
        self.wed.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.wedValue))/255.0), green: CGFloat((86.0*(1-self.wedValue))/255.0), blue: CGFloat((214.0*(1-self.wedValue))/255.0), alpha: 1.0)
        self.thurs.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.thursValue))/255.0), green: CGFloat((86.0*(1-self.thursValue))/255.0), blue: CGFloat((214.0*(1-self.thursValue))/255.0), alpha: 1.0)
        self.fri.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.friValue))/255.0), green: CGFloat((86.0*(1-self.friValue))/255.0), blue: CGFloat((214.0*(1-self.friValue))/255.0), alpha: 1.0)
    }
    func getClassID() {
        ref.child("UserInfo").child(Auth.auth().currentUser!.uid).child("current").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in uid in classrooms in students in updatesubmitbutton status")
                return
            }
            self.ClassID = value["ID"] as? String
            self.autoUpdateLabels()
            self.ref.child("Classrooms").child(self.ClassID).child("Students").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                guard let value = snapshot.value as? NSDictionary else {
                    print("no data in uid in classrooms in students in updatesubmitbutton status")
                    return
                }
                print("Int(snapshot.childrenCount): " + String(Int(snapshot.childrenCount)))
                self.numStudents = Int(snapshot.childrenCount)
            }) { (error) in
                print("error:\(error.localizedDescription)")
            }
            self.ref.child("Classrooms").child(self.ClassID).child("Calendar").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                guard let value = snapshot.value as? NSDictionary else {
                    print("no data in uid in classrooms in students in updatesubmitbutton status")
                    return
                }
                self.numVoters = value["numVoted"] as! Int

                if (self.numVoters != 0)
                {
                self.monValue = Double((value["monday"] as! Double) / Double(self.numVoters))
                self.tuesValue = Double((value["tuesday"] as! Double) / Double(self.numVoters))
                self.wedValue = Double((value["wednesday"] as! Double) / Double(self.numVoters))
                self.thursValue = Double((value["thursday"] as! Double) / Double(self.numVoters))
                self.friValue = Double((value["friday"] as! Double) / Double(self.numVoters))
                }
           
                self.resetDayLabels()
                
                self.mon.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.monValue))/255.0), green: CGFloat((86.0*(1-self.monValue))/255.0), blue: CGFloat((214.0*(1-self.monValue))/255.0), alpha: 1.0)
                self.tues.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.tuesValue))/255.0), green: CGFloat((86.0*(1-self.tuesValue))/255.0), blue: CGFloat((214.0*(1-self.tuesValue))/255.0), alpha: 1.0)
                self.wed.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.wedValue))/255.0), green: CGFloat((86.0*(1-self.wedValue))/255.0), blue: CGFloat((214.0*(1-self.wedValue))/255.0), alpha: 1.0)
                self.thurs.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.thursValue))/255.0), green: CGFloat((86.0*(1-self.thursValue))/255.0), blue: CGFloat((214.0*(1-self.thursValue))/255.0), alpha: 1.0)
                self.fri.backgroundColor = UIColor(red: CGFloat((88.0 * (1-self.friValue))/255.0), green: CGFloat((86.0*(1-self.friValue))/255.0), blue: CGFloat((214.0*(1-self.friValue))/255.0), alpha: 1.0)
                
            }) { (error) in
                print("error:\(error.localizedDescription)")
            }
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
    }

    @IBAction func resetPressed(_ sender: Any) {
        print("reset pressed")
        ref.child("Classrooms").child(self.ClassID).child("Calendar").updateChildValues(["numVoted": 0, "monday" : 0, "tuesday": 0, "wednesday": 0, "thursday": 0, "friday": 0])

        resetAllButtonColors()
        setLabelsZero()

        ref.child("Classrooms").child(self.ClassID).child("Students").observeSingleEvent(of: .value) { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let value = rest.value as? NSDictionary else {
                        print("No Data!!!")
                        return
                    }
                    let id = value["id"] as! String
                    self.ref.child("Classrooms").child(self.ClassID).child("Students").child(id).updateChildValues(["SubmitStatus" : false])
                    
                }
        }

    }
    func setLabelsZero() {
        monLabel.text = (String)(0) + "%"
        tuesLabel.text = (String)((0)) + "%"
        wedLabel.text = (String)(0) + "%"
        thursLabel.text = (String)(0) + "%"
        friLabel.text = (String)(0) + "%"
    }
    func autoUpdateLabels () {
        print("inside auto update lavbels")
        let messageDB = self.ref.child("Classrooms").child(ClassID).child("Calendar")
        messageDB.observe(.childChanged) { (snapshot) in
            self.ref.child("Classrooms").child(self.ClassID).child("Calendar").observeSingleEvent(of: .value) { snapshot in
                  guard let value = snapshot.value as? NSDictionary else {
                      return
                  }
                self.numVoters = value["numVoted"] as! Int
                  if (self.numVoters != 0)
                  {
                  self.monValue = Double((value["monday"] as! Double) / Double(self.numVoters))
                  self.tuesValue = Double((value["tuesday"] as! Double) / Double(self.numVoters))
                  self.wedValue = Double((value["wednesday"] as! Double) / Double(self.numVoters))
                  self.thursValue = Double((value["thursday"] as! Double) / Double(self.numVoters))
                  self.friValue = Double((value["friday"] as! Double) / Double(self.numVoters))
                    self.resetDayLabels()
                  }
                print("**************")
                print(self.monValue)
                print(self.tuesValue)
                print(self.wedValue)
                print(self.thursValue)
                print(self.friValue)
                print("**************")

                       
            }
        }

    }
}


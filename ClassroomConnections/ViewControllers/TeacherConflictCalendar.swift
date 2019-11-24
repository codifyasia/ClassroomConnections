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
    @IBOutlet weak var tues: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thurs: UIButton!
    @IBOutlet weak var fri: UIButton!
    var numStudents : Int = 0
    var monValue: Double = 0
    var tuesValue: Double = 0
    var wedValue: Double = 0
    var thursValue: Double = 0
    var friValue: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getClassID()
        updateDays()
        processDays()
        mon.layer.cornerRadius = mon.frame.size.height / 5
        tues.layer.cornerRadius = tues.frame.size.height / 5
        wed.layer.cornerRadius = wed.frame.size.height / 5
        thurs.layer.cornerRadius = thurs.frame.size.height / 5
        fri.layer.cornerRadius = fri.frame.size.height / 5
        

        // Do any additional setup after loading the view.
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
    
    func updateDays() {
        ref.child("Classrooms").child(ClassID).child("Calendar").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in uid in classrooms in students in updatesubmitbutton status")
                return
            }
            self.numStudents = Int(snapshot.childrenCount)
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        ref.child("Classrooms").child(ClassID).child("Calendar").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in uid in classrooms in students in updatesubmitbutton status")
                return
            }
            self.monValue = Double((value["monday"] as! Int) / self.numStudents)
            self.tuesValue = Double((value["tuesday"] as! Int) / self.numStudents)
            self.wedValue = Double((value["wednesday"] as! Int) / self.numStudents)
            self.thursValue = Double((value["thursday"] as! Int) / self.numStudents)
            self.friValue = Double((value["friday"] as! Int) / self.numStudents)
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
    }
    func processDays() {
        let dict = [monValue, tuesValue, wedValue, thursValue, friValue]
        for i in 0..<5 {
            
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

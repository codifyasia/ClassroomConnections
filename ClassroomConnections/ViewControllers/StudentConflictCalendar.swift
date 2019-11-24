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
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
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
    }
    
    @IBAction func tuesPressed(_ sender: Any) {
        day = "tuesday"
    }
    
    @IBAction func wedPressed(_ sender: Any) {
        day = "wednesday"
    }
    
    @IBAction func thursPressed(_ sender: Any) {
        day = "thursday"
    }
    
    @IBAction func friPressed(_ sender: Any) {
        day = "friday"
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        var numForADay : Int = 0
        ref.child("Classrooms").child(ClassID).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("no data in calendar")
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
                    self.ref.child("Classrooms").child(self.ClassID).child(Auth.auth().currentUser!.uid).updateChildValues(["SubmitStatus" : true])
                    
                }) { (error) in
                    print("error:\(error.localizedDescription)")
                }
            }
            
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

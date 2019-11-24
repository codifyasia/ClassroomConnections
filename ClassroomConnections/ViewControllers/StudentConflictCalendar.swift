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
        ref.child("PlayerStats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!!!!")
                return
            }
            
            self.name = value["Username"] as! String
            self.helloLabel.text = "Hello \(self.name)!"
            
            let distanceTraveled = value["TotalDistance"] as! Double
            let goalDistance = value["DistanceGoal"] as! Double     
            
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

//
//  ClassChatViewController.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit

class ClassChatViewController: UIViewController {
    
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "buh!"),
        Message(sender: "2@3.COM", body: "BOOH")
    ]
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate= self
        
    }
}
extension ClassChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].body
        return cell
    }
    
    
}
extension ClassChatViewController: UITableViewDelegate {
    
}

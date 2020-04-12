//
//  gayCell.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 1/14/20.
//  Copyright © 2020 CodifyAsia. All rights reserved.
//

import UIKit

class messageSelfCell: UITableViewCell {
    
    //    @IBOutlet weak var upvoteImage: UIImageView!
    //    @IBOutlet weak var label: UILabel!
    //    @IBOutlet weak var senderName: UILabel!
    //    @IBOutlet weak var messageBubble: UIView!
    //    @IBOutlet weak var upvoteAmount: UILabel!
    //    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var senderName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 3
        senderName.isHidden = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //        senderName.isHidden = true
        // Configure the view for the selected state
    }
    
}

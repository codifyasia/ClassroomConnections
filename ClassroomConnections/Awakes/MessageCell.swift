//
//  MessageCell.swift
//  ClassroomConnections
//
//  Created by Ricky Wang on 11/23/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var upvoteImage: UIImageView!
    @IBOutlet weak var upvoteAmount: UILabel!
    @IBOutlet weak var label: UILabel!
//
    @IBOutlet weak var rightImage: UIImageView!
    //    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    override func awakeFromNib() {
        senderName.isHidden = true
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
        // Configure the view for the selected state
    }
    
}

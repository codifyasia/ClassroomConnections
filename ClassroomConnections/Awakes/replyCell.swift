//
//  questionCell.swift
//  ClassroomConnections
//
//  Created by Michael Peng on 12/22/19.
//  Copyright © 2019 CodifyAsia. All rights reserved.
//

import UIKit

class replyCell: UITableViewCell {


    @IBOutlet weak var upvoteImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    
    @IBOutlet weak var upvoteAmount: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

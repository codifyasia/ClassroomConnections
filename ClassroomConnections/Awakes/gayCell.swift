//
//  gayCell.swift
//  ClassroomConnections
//
//  Created by Gavin Wong on 1/14/20.
//  Copyright © 2020 CodifyAsia. All rights reserved.
//

import UIKit

class gayCell: UITableViewCell {
    
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
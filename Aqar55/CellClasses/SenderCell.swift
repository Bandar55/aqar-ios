//
//  SenderCell.swift
//  AQAR55
//
//  Created by lion on 04/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var lbl_senderMsg: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

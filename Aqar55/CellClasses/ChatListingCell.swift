//
//  ChatListingCell.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class ChatListingCell: UITableViewCell {

    @IBOutlet weak var imgView_useImage: UIImageView!
    
    @IBOutlet weak var lbl_UserTitle: UILabel!
    
    @IBOutlet weak var lbl_deatil: UILabel!
    
    @IBOutlet weak var lbl_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}

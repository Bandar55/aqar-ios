//
//  NotificationsCell.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var lbl_NotificationContent: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

//
//  BusinessFooterCell.swift
//  AQAR55
//
//  Created by lion on 04/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class BusinessFooterCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblProfessionalID: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}

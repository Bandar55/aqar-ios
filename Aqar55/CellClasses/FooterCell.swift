//
//  FooterCell.swift
//  AQAR55
//
//  Created by lion on 04/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class FooterCell: UITableViewCell {

    @IBOutlet weak var btnChat: UIButton!
    
    @IBOutlet weak var lblcategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

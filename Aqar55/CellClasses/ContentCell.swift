//
//  ContentCell.swift
//  AQAR55
//
//  Created by lion on 04/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {

    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

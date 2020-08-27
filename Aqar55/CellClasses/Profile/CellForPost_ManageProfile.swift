//
//  CellForPost&ManageProfile.swift
//  Aqar55
//
//  Created by Callsoft on 04/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class CellForPost_ManageProfile: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblUpdateDays: UILabel!
    
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

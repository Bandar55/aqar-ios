//
//  AddressCell.swift
//  AQAR55
//
//  Created by lion on 04/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    
    @IBOutlet weak var lblOfficeAddress: UILabel!
    
    @IBOutlet weak var lblOfficeNo: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblWebsite: UILabel!
    
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var btnGmail: UIButton!
    
    @IBOutlet weak var btnTwitter: UIButton!
    
    @IBOutlet weak var btnLinkedIn: UIButton!
    
    @IBOutlet weak var btnOther: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

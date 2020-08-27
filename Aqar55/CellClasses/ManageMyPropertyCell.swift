//
//  ManageMyPropertyCell.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class ManageMyPropertyCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imgView_property: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_chat: UIButton!
    @IBOutlet weak var lbl_Cost: UILabel!
    @IBOutlet weak var lbl_PricePerSqr: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnUpdateProperty: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lblPricePerSqareMeter: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}

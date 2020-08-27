//
//  CellForProfessionalAndBusiness.swift
//  Aqar55
//
//  Created by Callsoft on 28/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class CellForProfessionalAndBusiness: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblIDs: UILabel!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var btnChat: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var btnLikeDislike: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    
    @IBOutlet weak var btnCall: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

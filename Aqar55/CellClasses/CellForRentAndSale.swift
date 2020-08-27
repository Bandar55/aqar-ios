//
//  CellForRentAndSale.swift
//  Aqar55
//
//  Created by Callsoft on 28/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class CellForRentAndSale: UITableViewCell {

   
    
    @IBOutlet var btnChat: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var imgProperty: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblPropertyType: UILabel!
    
    @IBOutlet weak var lblPricePerMeter: UILabel!
    
    @IBOutlet weak var lblSquareMeter: UILabel!
    
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

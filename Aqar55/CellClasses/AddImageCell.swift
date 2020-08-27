//
//  AddImageController.swift
//  AQAR55
//
//  Created by lion on 05/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class AddImageCell: UICollectionViewCell {
    
    //Mark: - Outlets
    @IBOutlet weak var property_img: UIImageView!
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var btn_playback: UIButton!
    
    @IBOutlet weak var lbl_propertyContent: UILabel!
    
    @IBOutlet weak var txtField_propertyContent: UITextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        lbl_propertyContent.adjustsFontSizeToFitWidth = true
        txtField_propertyContent.adjustsFontSizeToFitWidth = true
    }

}

//
//  SortByController.swift
//  Aqar55
//
//  Created by Callsoft on 27/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit


protocol SortControllerDelegate{
    
    func sortedParameter(singleParamStr:String)
}


class SortByController: UIViewController {

    
    @IBOutlet weak var btnPriceLowToHigh: UIButton!
    
    @IBOutlet weak var btnPriceHighToLow: UIButton!
    
    @IBOutlet weak var btnSizeLowToHigh: UIButton!
    
    @IBOutlet weak var btnSizeHighToLow: UIButton!
    
    var delegate:SortControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_priceLowToHigh(_ sender: Any) {
        
        self.delegate?.sortedParameter(singleParamStr: "lowtohighPrice")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_priceHighToLow(_ sender: Any) {
        
        self.delegate?.sortedParameter(singleParamStr: "hightolowPrice")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_sizeLowToHigh(_ sender: Any) {
        
        self.delegate?.sortedParameter(singleParamStr: "lowtohighSize")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_sizeHighToLow(_ sender: Any) {
        
        self.delegate?.sortedParameter(singleParamStr: "hightolowSize")
        self.dismiss(animated: true, completion: nil)
    }
    
}

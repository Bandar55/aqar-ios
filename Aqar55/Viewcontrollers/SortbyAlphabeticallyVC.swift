//
//  SortbyAlphabeticallyVC.swift
//  Aqar55
//
//  Created by Dacall soft on 25/04/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

protocol SortAlphabeticallyDelegate {
    
    func sortedByAlpha(status:String)
}


class SortbyAlphabeticallyVC: UIViewController {

    
    @IBOutlet weak var btnAlphabetically: UIButton!
    
    @IBOutlet weak var btnCategory: UIButton!
    
    var delegate:SortAlphabeticallyDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tap_alphabeticallyBtn(_ sender: Any) {
        
        self.delegate?.sortedByAlpha(status: "sortByName")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_categoryBtn(_ sender: Any) {
        
        self.delegate?.sortedByAlpha(status: "sortByCategory")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

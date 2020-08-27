//
//  ImageViewerVC.swift
//  Aqar55
//
//  Created by Dacall soft on 28/05/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ImageViewerVC: UIViewController {

    
    @IBOutlet weak var imgMedia: UIImageView!
    
    var imgStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
           
            let fullImgStr = "\(self.imgStr)"
            
            let urlStr = URL(string: fullImgStr)
            
            if urlStr != nil{
                
                self.imgMedia.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
            }
        }
        
    }
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

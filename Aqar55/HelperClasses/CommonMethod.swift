//
//  CommonMethod.swift
//  Chilidate
//
//  Created by Amit Singh on 16/12/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import UIKit
import KYDrawerController


class CommonMethod: NSObject {

    var currentLanguage = ""
    var languageForApi = ""

    static let shared : CommonMethod = {
        
        let instance = CommonMethod()
        return instance
        
    }()
    
    func isIphone5s() -> Bool{
        
        if kScreenHeight == 568.0{
            return true
        }else{
            return false
        }
    }
    

    class func paddingTextfield(txtField:UITextField)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtField.frame.height))
        txtField.leftView = paddingView
        txtField.leftViewMode = .always
    }
    
    
    class func getDictionaryFromXMLFile(_ filename: String, fileExtension `extension`: String) -> [AnyHashable: Any] {
        
        let configFileURL: URL? = Bundle.main.url(forResource: filename, withExtension: `extension`)
        let xmlString = try? String(contentsOf: configFileURL!, encoding: String.Encoding.utf8)
        let xmlDoc: [AnyHashable: Any]? = try? XMLReader.dictionary(forXMLString: xmlString)
        return xmlDoc!
    }
    
    class func appDelegate()->AppDelegate{
        
        return UIApplication.shared.delegate as! AppDelegate
    }

}

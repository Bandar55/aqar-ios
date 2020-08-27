//
//  Constants.swift
//  Chilidate
//
//  Created by Amit Singh on 18/12/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import Foundation
import UIKit


 let isForSignup = true
 let kScreenWidth = UIScreen.main.bounds.width
 let kScreenHeight = UIScreen.main.bounds.height
 let kAppColorTheme = UIColor(red: 161/255, green: 26/255, blue: 99/255, alpha: 1.0)
 let kGenderColorGray = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
 let kObjAppDelegate = UIApplication.shared.delegate as! AppDelegate

 let kAuthToken = ""
 let kNoInternetConnection = "No Internet Connection!"
 let kServerNotResponding = "Server not Responding"
 let kUnknownError = "Unknown error"
 let kAppName = "VanvuverDriver"

 let kGoogleApiKey = "AIzaSyDdbYAwMXiGJaxPrBIfqw2W4yxjR8MV4-A"

 let kBaseUrl = ""

struct ApiName {
    
    static let kSignup                   = "register"
 
}


enum MyError: Error {
    case runtimeError(String)
}

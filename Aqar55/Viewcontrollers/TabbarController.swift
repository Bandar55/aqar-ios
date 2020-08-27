//
//  TabbarController.swift
//  Chilidate
//
//  Created by Amit Singh on 30/12/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    
    let imageArr = ["slidebar_iii","commentssectionnew","notificationiconbell","doticonold"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarSetUp()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBarSetUp(){
        
        
        for (index, _) in (self.tabBar.items?.enumerated())!{
            print(index)
            
            let tabItem2  = self.tabBar.items![index]
            tabItem2.selectedImage = UIImage(named:imageArr[index])?.withRenderingMode(.alwaysOriginal)
            tabItem2.image=UIImage(named:imageArr[index])?.withRenderingMode(.alwaysOriginal)
            
        }
        
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
//        if item.tag == 0{
//            UITabBar.appearance().tintColor = UIColor(red: 139/255.0, green: 137/255.0, blue: 243/255.0, alpha: 1.0)
//        }
//
//        if item.tag == 1{
//            UITabBar.appearance().tintColor = UIColor(red: 138/255.0, green: 196/255.0, blue: 237/255.0, alpha: 1.0)
//        }
//
//        if item.tag == 2{
//            UITabBar.appearance().tintColor = UIColor(red: 190/255.0, green: 128/255.0, blue: 244/255.0, alpha: 1.0)
//        }
//
//        if item.tag == 3{
//            UITabBar.appearance().tintColor = UIColor(red: 115/255.0, green: 207/255.0, blue: 176/255.0, alpha: 1.0)
//        }
        
    }
    
}

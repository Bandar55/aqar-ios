//
//  TakeATourController.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class TakeTourController: UIViewController {
   
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var pageControllerRef:UIPageControl!
    
  
    var takeTourArr = NSArray()
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        self.apiCallForGetTakeAndTourContent()
    }
    
  
    
    @IBAction func btnNextAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupOptionController") as! SignupOptionController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




extension TakeTourController{
    func initialSetup(){
        pageControllerRef.customPageControl(dotFillColor: UIColor.red, dotBorderColor: UIColor.darkGray, dotBorderWidth: 1.0)
    }
}


extension TakeTourController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return takeTourArr.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: "TakeATourCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TakeATourCollectionViewCell")
        
        let collectionViewItem = collectionView.dequeueReusableCell(withReuseIdentifier: "TakeATourCollectionViewCell", for: indexPath) as! TakeATourCollectionViewCell
        
        let dict = takeTourArr.object(at: indexPath.section) as? NSDictionary ?? [:]
        
        collectionViewItem.lblHeading.text = dict.object(forKey: "title") as? String ?? ""
        collectionViewItem.contentTxtView.text = dict.object(forKey: "description") as? String ?? ""
        
        
        pageControllerRef.customPageControl(dotFillColor: UIColor(red: 245.0/255, green: 0.0/255, blue: 22.0/255, alpha: 1.0), dotBorderColor: UIColor(red: 158.0/255, green: 158.0/255, blue: 160.0/255, alpha: 1.0), dotBorderWidth: 1)
        return collectionViewItem
        
    }
    
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height - 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControllerRef.currentPage = indexPath.section
        pageControllerRef.customPageControl(dotFillColor: UIColor(red: 245.0/255, green: 0.0/255, blue: 22.0/255, alpha: 1.0), dotBorderColor: UIColor(red: 158.0/255, green: 158.0/255, blue: 160.0/255, alpha: 1.0), dotBorderWidth: 1)
    }
}


extension UIPageControl {
    //TODO: Custom page controller
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
}


//MARK:- Webservices
//MARK:-
extension TakeTourController{
    
    func apiCallForGetTakeAndTourContent(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetTakeTourContent as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let dataArr = receivedData.object(forKey: "data") as? NSArray{
                            
                            self.takeTourArr = dataArr
                            
                            self.pageControllerRef.numberOfPages = self.takeTourArr.count
                            
                            self.collectionView.reloadData()
                        }
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
}

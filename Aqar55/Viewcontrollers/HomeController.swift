//
//  HomeController.swift
//  Aqar55
//
//  Created by Callsoft on 27/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import KYDrawerController
import GooglePlaces


class HomeModel:NSObject{
    
    var text = ""
    var color = UIColor()
    var isBottomViewHidden = false
    var bottomViewColor = UIColor()
    
    init(text:String,color:UIColor,isBottomViewHidden:Bool,bottomViewColor:UIColor) {
        
        self.text = text
        self.color = color
        self.isBottomViewHidden = isBottomViewHidden
        self.bottomViewColor = bottomViewColor
    }
    
}


class HomeController: UIViewController {

    @IBOutlet weak var btnHouse: UIButton!
    @IBOutlet weak var btnAppartment: UIButton!
    @IBOutlet weak var btnOffice: UIButton!
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    
    @IBOutlet weak var view_houseApart: UIView!
    
    @IBOutlet var imgSelectedTab: [UIImageView]!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var myMapView: GMSMapView!
    
    @IBOutlet var btnCategory: [UIButton]!
    @IBOutlet weak var txtKeywordSearch: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var subCatCollectionView: UICollectionView!
    
    @IBOutlet weak var viewTotalPropertyHolder: UIView!
    
    @IBOutlet weak var lblTotalProperties: UILabel!
    
    
    @IBOutlet weak var totalPropertiesTopConstraint: NSLayoutConstraint!
    
    
    let latArray = ["28.7041","29.0588","27.0238","26.8467","31.1048","31.1048"]
    let longArray = ["77.1025","76.0856","74.2179","80.9462","77.1734","77.1734"]
    
    let textArr = ["All","Sale","Rent","Professional","Business"]
    
    let colorArr = [UIColor(red: 17/255, green: 0/255, blue: 254/255, alpha: 1.0),
                    UIColor(red: 244/255, green: 0/255, blue: 13/255, alpha: 1.0),
                    UIColor(red: 0/255, green: 166/255, blue: 0/255, alpha: 1.0),
                    UIColor(red: 239/255, green: 105/255, blue: 0/255, alpha: 1.0),
                    UIColor(red: 141/255, green: 0/255, blue: 242/255, alpha: 1.0)]


    var finalArray = [HomeModel]()
    var selectedIndexTab = 0
    
    let connection = webservices()
    
    ////for location
    
    var locationManager : CLLocationManager = CLLocationManager()
    var strAddress = ""
    var AddressLat:Double = 0.0
    var AddressLong:Double = 0.0
    var gmsPlace:GMSPlace?
    var arrPlaces = NSMutableArray(capacity: 100)
    var arrPlacesIDs = NSMutableArray(capacity: 100)
    
    var propertyDataArr = NSArray()
    
    var globalUserType = ""
    
    var globalIndexID = ""
    
    let customInfoWindow = Bundle.main.loadNibNamed("MarkerView", owner: self, options: nil)?.first as! MarkerView
    var locationMarker : GMSMarker? = GMSMarker()
    
    //MarkerViewBusiness
    let customInfoWindowProperty = Bundle.main.loadNibNamed("MarkerViewBusiness", owner: self, options: nil)?.first as! MarkerViewBusiness
    
    var propertyCategoryArr = NSMutableArray()
    
    var selectedGlobalSubType = ""
    
    var searchByLocation = false
    
    var subCategorySelectionArr = NSMutableArray()
    
    var myLocationBackupLat = 0.0
    var myLocationBackupLong = 0.0
    
    var globalSubcategoryForList = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "NotFirstTime")
        
        subCategorySelectionArr.removeAllObjects()
        
        if UIScreen.main.bounds.height >= 736{
            
            constraintTop.constant = 0
            
        }else{
            
            constraintTop.constant = 15
        }
        
        myMapView.delegate = self
        
        imgSelectedTab[0].isHidden = true
        
        CommonMethod.paddingTextfield(txtField: txtKeywordSearch)

        txtKeywordSearch.leftView = UIImageView(image: UIImage(named: "search_button"))
        txtKeywordSearch.leftViewMode = .always
        
        subCatCollectionView.dataSource = self
        subCatCollectionView.delegate = self
        
        
        
       // showMarker()
        
//        if finalArray.count > 0{
//            finalArray.removeAll()
//        }
//        for i in 0 ..< textArr.count{
//            if i == 0{
//                self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:false, bottomViewColor: colorArr[i]))
//            }else{
//                self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:true, bottomViewColor: colorArr[i]))
//            }
//        }
//
//
//        self.collectionView.reloadData()
        
        self.apiCallForUpdatePropertyDays()
        
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        txtKeywordSearch.addDoneOnKeyboard(withTarget: self, action: #selector(doneButtonClicked))
        
        UserDefaults.standard.set(false, forKey: "PreventViewWillAppear")
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.redirectOnChat), name: NSNotification.Name(rawValue: "NotificationForRedirectionOnChat"), object: nil)
        
        totalPropertiesTopConstraint.constant = 15.0
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.bool(forKey: "PreventViewWillAppear"){
            
            //do nothing via search controller back
            print("nothing")
            
            if self.selectedIndexTab == 0{
                
                self.totalPropertiesTopConstraint.constant = 15.0
            }
            else{
                
                self.totalPropertiesTopConstraint.constant = 67.5
            }
            
        }
        else{
            
            self.subCategorySelectionArr.removeAllObjects()
            
            self.selectedIndexTab = 0
            
            totalPropertiesTopConstraint.constant = 15.0
            
            self.view_houseApart.isHidden = true
            
            if finalArray.count > 0{
                finalArray.removeAll()
            }
            
            for i in 0 ..< textArr.count{
                
                if i == 0{
                    self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:false, bottomViewColor: colorArr[i]))
                }else{
                    self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:true, bottomViewColor: colorArr[i]))
                }
            }
            
            self.collectionView.reloadData()
            
            self.apiCallForFetchPropertyListing(type: "")
            
        }
        
        UserDefaults.standard.set(false, forKey: "PreventViewWillAppear")
        
    }
    
    
    func shareProperty(propertyTitle:String,propertyType:String){
        
      //  let title = "I just used the Aqar55 App and saw the property \(propertyTitle) for \(propertyType). Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareProfile(userName:String,profileType:String){
        
       // let title = "I just used the Aqar55 App and saw the profile of \(userName) as \(profileType) user. Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func redirectOnChat(){
        
        let data = UserDefaults.standard.value(forKey: "MsgData") as! NSData
        let chatData = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
        
        print(chatData)
        
        let receiverId = chatData.object(forKey: "sender") as? String ?? ""
        let roomId = chatData.object(forKey: "roomid") as? String ?? ""
        let name = chatData.object(forKey: "fullName") as? String ?? ""
        
        let descTxt = chatData.object(forKey: "desc") as? String ?? ""
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
        
      //  vc.propertyID =  propertyId
        vc.receiverID = receiverId
        vc.roomID = roomId
        vc.headerName = name
        
        vc.descriptionStr = descTxt
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showMarker()
    {
        
        myMapView.clear()
        
        self.customInfoWindow.removeFromSuperview()
        self.customInfoWindowProperty.removeFromSuperview()
        
        for i in 0..<self.propertyDataArr.count{
            
            let dict = propertyDataArr.object(at: i) as? NSDictionary ?? [:]
            
            var latCordinate = dict.object(forKey: "lat") as? String ?? ""
            var longCordinate = dict.object(forKey: "long") as? String ?? ""
            
            latCordinate = latCordinate.trimmingCharacters(in: .whitespaces)
            longCordinate = longCordinate.trimmingCharacters(in: .whitespaces)
            
            print(latCordinate)
            print(longCordinate)
            
            if latCordinate != "" && longCordinate != ""{
                
                let latiDouble = Double(latCordinate)!
                let longiDouble = Double(longCordinate)!
                
                if i == 0{
                    
                    
                    if self.searchByLocation == true{
                        
                        self.searchByLocation = false
                        
                        let camera = GMSCameraPosition.camera(withLatitude: latiDouble, longitude: longiDouble, zoom: 7.0)
                        myMapView.camera = camera
                        myMapView.animate(to: camera)
                        
                    }
                  
                }
                
                let position = CLLocationCoordinate2DMake(latiDouble,longiDouble)
                
                let marker = GMSMarker(position: position)
                
                marker.userData = i
                
                let propertyType = dict.object(forKey: "Type") as? String ?? ""
                
                if self.selectedIndexTab == 0{
                    
                    if propertyType == "sale"{
                        
                        let viewData = Bundle.main.loadNibNamed("MarkerCategorised", owner: self, options: nil)?.first as! MarkerCategorised
                        
//                        viewData.imgViewMarker.image = UIImage(named: "orangeBlank")
//
//                        viewData.lblContent.textColor = UIColor(red:0.94, green:0.74, blue:0.55, alpha:1.0)
                        
                        viewData.imgViewMarker.image = UIImage(named: "redBlank")
                        
                        viewData.lblContent.textColor = UIColor(red:0.96, green:0.30, blue:0.32, alpha:1.0)
                        
                        let totalPriceSale = dict.object(forKey: "totalPriceSale") as? String ?? ""
                        
                        let currency = dict.object(forKey: "currency") as? String ?? ""
                        
                        self.globalUserType = "sale"
                        
                        viewData.lblContent.text = "\(currency) \(totalPriceSale)"
                        
                        marker.iconView = viewData
                        
                        marker.map = myMapView
                        
                    }
                    else if propertyType == "rent"{
                        
                        self.globalUserType = "rent"
                        
                        let viewData = Bundle.main.loadNibNamed("MarkerCategorised", owner: self, options: nil)?.first as! MarkerCategorised
                        
                        let totalPriceRent = dict.object(forKey: "totalPriceRent") as? String ?? ""
                        
                        let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                        
                        let currency = dict.object(forKey: "currency") as? String ?? ""
                        
                        viewData.lblContent.text = "\(currency) \(totalPriceRent) \(rentTime)"
                        
                        if rentTime == "daily"{
                            
//                            viewData.imgViewMarker.image = UIImage(named: "purpleBlank")
//
//                            viewData.lblContent.textColor = UIColor(red:0.75, green:0.55, blue:0.93, alpha:1.0)
                            
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        else if rentTime == "weekly"{
                            
//                            viewData.imgViewMarker.image = UIImage(named: "redBlank")
//
//                            viewData.lblContent.textColor = UIColor(red:0.96, green:0.30, blue:0.32, alpha:1.0)
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        else if rentTime == "monthly"{
                            
//                            viewData.imgViewMarker.image = UIImage(named: "orangeBlank")
//
//                            viewData.lblContent.textColor = UIColor(red:0.94, green:0.74, blue:0.55, alpha:1.0)
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        else if rentTime == "yearly"{
                            
//                            viewData.imgViewMarker.image = UIImage(named: "blueBlank")
//
//                            viewData.lblContent.textColor = UIColor(red:0.49, green:0.49, blue:0.94, alpha:1.0)
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        
                        marker.iconView = viewData
                        
                        marker.map = myMapView
                        
                    }
                    else if propertyType == "professional"{
                        
                        let subCategory = dict.object(forKey: "subCategory") as? String ?? ""
                        
                        let viewData = Bundle.main.loadNibNamed("ProfessionalMarker", owner: self, options: nil)?.first as! ProfessionalMarker
                        
                        viewData.imgMarker.image = UIImage(named: "blue_map_icon")
                        viewData.lblCategory.text = subCategory
                        
                        let lat = dict.object(forKey: "lat") as? String ?? ""
                        let long = dict.object(forKey: "long") as? String ?? ""
                        
                        viewData.lblDistance.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: lat, longitude: long)
                        
                        marker.iconView = viewData
                        
                        marker.map = myMapView
                        
                    }
                    else if propertyType == "business"{
                        
                        let subCategory = dict.object(forKey: "subCategory") as? String ?? ""
                        
                        let viewData = Bundle.main.loadNibNamed("ProfessionalMarker", owner: self, options: nil)?.first as! ProfessionalMarker
                        
                        viewData.imgMarker.image = UIImage(named: "map_red")
                        viewData.lblCategory.text = subCategory
                        
                        let lat = dict.object(forKey: "lat") as? String ?? ""
                        let long = dict.object(forKey: "long") as? String ?? ""
                        
                        viewData.lblDistance.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: lat, longitude: long)
                        
                        marker.iconView = viewData
                        
                        marker.map = myMapView
                    }
                }
                else if self.selectedIndexTab == 1{
                    
                    let viewData = Bundle.main.loadNibNamed("MarkerCategorised", owner: self, options: nil)?.first as! MarkerCategorised
                    
//                    viewData.imgViewMarker.image = UIImage(named: "orangeBlank")
//
//                    viewData.lblContent.textColor = UIColor(red:0.94, green:0.74, blue:0.55, alpha:1.0)
                    
                    viewData.imgViewMarker.image = UIImage(named: "redBlank")
                    
                    viewData.lblContent.textColor = UIColor(red:0.96, green:0.30, blue:0.32, alpha:1.0)
                    
                    let totalPriceSale = dict.object(forKey: "totalPriceSale") as? String ?? ""
                    
                    let currency = dict.object(forKey: "currency") as? String ?? ""
                    
                    viewData.lblContent.text = "\(currency) \(totalPriceSale)"
                    
                    marker.iconView = viewData
                    
                    marker.map = myMapView
                    
                }
                else if self.selectedIndexTab == 2{
                    
                    let viewData = Bundle.main.loadNibNamed("MarkerCategorised", owner: self, options: nil)?.first as! MarkerCategorised
                    
                    let totalPriceRent = dict.object(forKey: "totalPriceRent") as? String ?? ""
                    
                    let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                    
                    let currency = dict.object(forKey: "currency") as? String ?? ""
                    
                    viewData.lblContent.text = "\(currency) \(totalPriceRent) \(rentTime)"
                    
                    if rentTime == "daily"{
                        
//                        viewData.imgViewMarker.image = UIImage(named: "purpleBlank")
//
//                        viewData.lblContent.textColor = UIColor(red:0.75, green:0.55, blue:0.93, alpha:1.0)
                        
                        viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                        
                        viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                        
                    }
                    else if rentTime == "weekly"{
                        
//                        viewData.imgViewMarker.image = UIImage(named: "redBlank")
//
//                        viewData.lblContent.textColor = UIColor(red:0.96, green:0.30, blue:0.32, alpha:1.0)
                        
                        viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                        
                        viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                        
                    }
                    else if rentTime == "monthly"{
                        
//                        viewData.imgViewMarker.image = UIImage(named: "orangeBlank")
//
//                        viewData.lblContent.textColor = UIColor(red:0.94, green:0.74, blue:0.55, alpha:1.0)
                        
                        viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                        
                        viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                        
                    }
                    else if rentTime == "yearly"{
                        
//                        viewData.imgViewMarker.image = UIImage(named: "blueBlank")
//
//                        viewData.lblContent.textColor = UIColor(red:0.49, green:0.49, blue:0.94, alpha:1.0)
                        
                        viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                        
                        viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                    }
                    
                    marker.iconView = viewData
                    
                    marker.map = myMapView
                    
                }
                else if self.selectedIndexTab == 3{
                    
                    let subCategory = dict.object(forKey: "subCategory") as? String ?? ""
                    
                    let viewData = Bundle.main.loadNibNamed("ProfessionalMarker", owner: self, options: nil)?.first as! ProfessionalMarker
                    
                    viewData.imgMarker.image = UIImage(named: "blue_map_icon")
                    viewData.lblCategory.text = subCategory
                    
                    let lat = dict.object(forKey: "lat") as? String ?? ""
                    let long = dict.object(forKey: "long") as? String ?? ""
                    
                    viewData.lblDistance.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: lat, longitude: long)
                    
                    marker.iconView = viewData
                    
                    marker.map = myMapView
                    
                }
                else if self.selectedIndexTab == 4{
                    
                    let subCategory = dict.object(forKey: "subCategory") as? String ?? ""
                    
                    let viewData = Bundle.main.loadNibNamed("ProfessionalMarker", owner: self, options: nil)?.first as! ProfessionalMarker
                    
                    viewData.imgMarker.image = UIImage(named: "map_red")
                    viewData.lblCategory.text = subCategory
                    
                    let lat = dict.object(forKey: "lat") as? String ?? ""
                    let long = dict.object(forKey: "long") as? String ?? ""
                    
                    viewData.lblDistance.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: lat, longitude: long)
                    
                    marker.iconView = viewData
                    
                    marker.map = myMapView
                    
                }
            }
            
        }
        
//        let camera = GMSCameraPosition.camera(withLatitude: Double(latArray[0])!, longitude: Double(longArray[1])!, zoom: 7.0)
//        myMapView.camera = camera
//        myMapView.animate(to: camera)
        
    }
    
    //MARK:- Button's Action
    
    @IBAction func btnBottomBarButtonAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListController") as! ListController
            
            var catStr = ""
            
            if self.selectedIndexTab == 0{
                
                catStr = ""
            }
            else if self.selectedIndexTab == 1{
                
                catStr = "sale"
            }
            else if self.selectedIndexTab == 2{
                
                catStr = "rent"
            }
            else if self.selectedIndexTab == 3{
                
                catStr = "professional"
            }
            else if self.selectedIndexTab == 4{
                
                catStr = "business"
            }
            
            vc.preSelectedIndex = self.selectedIndexTab
            vc.preSelectedType = catStr
            vc.preSelectedSubType = self.globalSubcategoryForList
            
            vc.propertyDataArr = self.propertyDataArr
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        if sender.tag == 1{
            
            if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListingController") as! ChatListingController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                
                self.makeRootToLoginSignup()
            }
            
        }
        if sender.tag == 2{
            
            if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsController") as! NotificationsController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                
                self.makeRootToLoginSignup()
            }
            
        }
        if sender.tag == 3{
            
            if let drawerController = navigationController?.parent as? KYDrawerController{
                drawerController.drawerWidth = kScreenWidth - 30
                drawerController.drawerDirection = .left
                drawerController.setDrawerState(.opened, animated: true)
            }
            
        }
    }
    
 
  
    
    @IBAction func btnCategoryAction(_ sender: UIButton) {
        
        for i in 0 ..< 3{
            
            if i == sender.tag{
                imgSelectedTab[i].isHidden = false
            }else{
                imgSelectedTab[i].isHidden = true
            }
        }
        
        
        var categoryStr = ""
        var type = ""
        if sender.tag == 0{
            
            categoryStr = "House"
        }
        else if sender.tag == 1{
            
            categoryStr = "Apartments"
        }
        else if sender.tag == 2{
            
            categoryStr = "Office"
        }
        
        if self.selectedIndexTab == 1{
            
            type = "sale"
        }
        else if self.selectedIndexTab == 2{
            
            type = "rent"
        }
        
        
        self.apiCallForGetPropertyBasedOnSubCategory(typeStr: type, categoryStr: categoryStr)
        
    }
    
    @IBAction func btnAddPropertyAction(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyController") as! PostPropertyController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            alertWithAction()
        }
        
    }
    
    
    @IBAction func tap_searchByLocationBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

    
    @IBAction func btnFilterAction(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "PreventViewWillAppear")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        
        vc.delegate = self
        
        vc.professionalDelegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_setteliteViewBtn(_ sender: Any) {
        
        myMapView.mapType = .satellite
        
    }
    
    @IBAction func tap_normalMapBtn(_ sender: Any) {
        
        myMapView.mapType = .normal
        
        if myLocationBackupLat != 0.0 && myLocationBackupLong != 0.0{
            
            let camera = GMSCameraPosition.camera(withLatitude: myLocationBackupLat, longitude: myLocationBackupLong, zoom: 12.0)
            myMapView.camera = camera
            
        }
        
    }
    
    
    @objc func doneButtonClicked(_ sender: Any) {
        
        txtKeywordSearch.resignFirstResponder()
        
         if txtKeywordSearch.text != ""{
        
            self.selectedIndexTab = 0
        
            if finalArray.count > 0{
                finalArray.removeAll()
            }
            for i in 0 ..< textArr.count{
                if i == 0{
                    self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:false, bottomViewColor: colorArr[i]))
                }else{
                    self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:true, bottomViewColor: colorArr[i]))
                }
            }
        
            self.collectionView.reloadData()
            
            self.apiCallForKeywordSearch(searchedTxt: txtKeywordSearch.text!)
       
        }
        
    }
    
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func makeRootToLoginSignup(){
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupOptionController") as! SignupOptionController
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
        print("Logout Tapped")
        
    }
    
    
    func getDistanceFromCurrentToAll(currentLocationLat:Double,currentLocationLong:Double,latitude:String,longitude:String) -> String{
        
        print(currentLocationLat)
        print(currentLocationLong)
        print(latitude)
        print(longitude)
        
        if currentLocationLat == 0.0 || currentLocationLong == 0.0{
            
            return "0 KM"
        }
        
        let lati = latitude.trimmingCharacters(in: .whitespaces)
        let longi = longitude.trimmingCharacters(in: .whitespaces)
        
        if lati == "" || longi == ""{
            
            return "0 KM"
        }
        
        let doubleLat = Double(lati)
        let doubleLong = Double(longi)
                    
        let coordinate₀ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
        
        let coordinate₁ = CLLocation(latitude: doubleLat!, longitude: doubleLong!)
                    
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        let distanceInKm = distanceInMeters / 1000
                    
        var integerDistance = Int()
                    
        if distanceInKm < 1.0 && distanceInKm > 0.0{
                        
            integerDistance = 1
        }
        else{
                        
            integerDistance = Int(distanceInKm)
        }
 
        return "\(integerDistance) KM"
        
    }
    
    
    @objc func callOnNumber(sender:UIButton){
        
        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let countryCode = dict.object(forKey: "countryCode") as? String ?? ""
        
        let phoneNo = dict.object(forKey: "mobileNumber") as? String ?? ""
        
        if let url = URL(string: "tel://\(countryCode)\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10, *) {
                
                UIApplication.shared.open(url)
                
            } else {
                
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
}



extension HomeController:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        if marker.userData != nil{
            
            return UIView()
        }
        else{
            
            let index = marker.userData as! Int
            
            let dict = propertyDataArr.object(at: index) as? NSDictionary ?? [:]
            
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            if type == "professional" || type == "business"{
                
                let fullname = dict.object(forKey: "fullName") as? String ?? ""
                let category = dict.object(forKey: "category") as? String ?? ""
                let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
                let description = dict.object(forKey: "description") as? String ?? ""
                
                if imgStr == ""{
                    
                    customInfoWindow.imgUser.image = UIImage(named: "userPlaceholder")
                }
                else{
                    
                    let urlStr = URL(string: imgStr)
                    customInfoWindow.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
                    
                }
                
                customInfoWindow.lblDetail.text = description
                customInfoWindow.lblName.text = fullname
                customInfoWindow.lblCategory.text = category
                
                let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
                
                if likeStatus == "yes"{
                    
                    customInfoWindow.btnLike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                }
                else{
                    
                   customInfoWindow.btnLike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
                }
                
                
                if type == "professional"{
                    
                   let professionalID = dict.object(forKey: "professionalId") as? String ?? ""
                    
                    customInfoWindow.lblId.text = "Pro.Id.-\(professionalID)"
                }
                
                if type == "business"{
                    
                    let businessId = dict.object(forKey: "businessId") as? String ?? ""
                    
                    customInfoWindow.lblId.text = "BussinessId:\(businessId)"
                }
                
                
                customInfoWindow.infoWindowBtn.tag = index
                customInfoWindow.infoWindowBtn.addTarget(self, action: #selector(self.tap_infoWindowBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindow.btnCall.tag = index
                customInfoWindow.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindow.btnShare.tag = index
                customInfoWindow.btnShare.addTarget(self, action: #selector(self.tap_ShareBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindow.btnChat.tag = index
                customInfoWindow.btnChat.addTarget(self, action: #selector(self.tap_ChatBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                return customInfoWindow
                
            }
            else if type == "sale" || type == "rent"{
                
                let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
                
                if likeStatus == "yes"{
                    
                    customInfoWindowProperty.btnLike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                }
                else{
                    
                    customInfoWindowProperty.btnLike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
                }
                
                
                customInfoWindowProperty.lblTitle.text = dict.object(forKey: "title") as? String ?? ""
                customInfoWindowProperty.lblCategory.text = dict.object(forKey: "category") as? String ?? ""
                
                let plotSize = dict.object(forKey: "plotSize") as? String ?? ""
                let plotSizeUnit = dict.object(forKey: "plotSizeUnit") as? String ?? ""
                
                customInfoWindowProperty.lblDetails.text = "\(plotSize)\(plotSizeUnit)"
                
                if type == "sale"{
                    
                    let totalPrice = dict.object(forKey: "totalPriceSale") as? String ?? ""
                    
                    let currency = dict.object(forKey: "currency") as? String ?? ""
                    
                    customInfoWindowProperty.lblPrice.text = "\(currency) \(totalPrice)"
                    
                  //  let pricePerMeter = dict.object(forKey: "pricePerMeter") as? String ?? ""
                    
                   // cell.lblSquareMeter.text = "SAR \(pricePerMeter) M2"
                }
                else{
                    
                    let totalPrice = dict.object(forKey: "totalPriceRent") as? String ?? ""
                    
                    let currency = dict.object(forKey: "currency") as? String ?? ""
                    
                    let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                    
                    customInfoWindowProperty.lblPrice.text = "\(currency) \(totalPrice) \(rentTime)"
                }
                
                let imageArr = dict.object(forKey: "imagesFile") as? NSArray ?? []
                if imageArr.count == 0{
                    
                    customInfoWindowProperty.imgProperty.image = UIImage(named: "defaultProperty")
                }
                else{
                    
                    let dict = imageArr.object(at: 0) as? NSDictionary ?? [:]
                    let imageStr = dict.object(forKey: "image") as? String ?? ""
                    
                    if imageStr != ""{
                        
                        let urlStr = URL(string: imageStr)
                        customInfoWindowProperty.imgProperty.setImageWith(urlStr, placeholderImage: UIImage(named: "defaultProperty"))
                    }
                    else{
                        
                        customInfoWindowProperty.imgProperty.image = UIImage(named: "defaultProperty")
                    }
                }
                
                customInfoWindowProperty.btnInfoWindow.tag = index
                customInfoWindowProperty.btnInfoWindow.addTarget(self, action: #selector(self.tap_infoWindowForProperty(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindowProperty.btnLike.tag = index
                customInfoWindowProperty.btnLike.addTarget(self, action: #selector(self.tap_likeProperty(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindowProperty.btnCall.tag = index
                customInfoWindowProperty.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindowProperty.btnShare.tag = index
                customInfoWindowProperty.btnShare.addTarget(self, action: #selector(self.tap_ShareBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                customInfoWindowProperty.btnChat.tag = index
                customInfoWindowProperty.btnChat.addTarget(self, action: #selector(self.tap_ChatBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                return customInfoWindowProperty
            }
            
            else{
                
                 return UIView()
            }
           
        }
       
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
        customInfoWindow.removeFromSuperview()
        customInfoWindowProperty.removeFromSuperview()
        
        let index = marker.userData as! Int
        
        let dict = propertyDataArr.object(at: index) as? NSDictionary ?? [:]
        
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        if type == "professional" || type == "business"{
            
            locationMarker = marker
            guard let location = locationMarker?.position else {
                return false
            }
            
            ///////
            
            let fullname = dict.object(forKey: "fullName") as? String ?? ""
            let category = dict.object(forKey: "category") as? String ?? ""
            let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
            let description = dict.object(forKey: "description") as? String ?? ""
            
            if imgStr == ""{
                
                customInfoWindow.imgUser.image = UIImage(named: "userPlaceholder")
            }
            else{
                
                let urlStr = URL(string: imgStr)
                customInfoWindow.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
                
            }
            
            customInfoWindow.lblDetail.text = description
            customInfoWindow.lblName.text = fullname
            customInfoWindow.lblCategory.text = category
            
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            if likeStatus == "yes"{
                
                customInfoWindow.btnLike.setImage(UIImage(named: "like_icon_new"), for: .normal)
            }
            else{
                
                customInfoWindow.btnLike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
            }
            
            if type == "professional"{
                
                let professionalID = dict.object(forKey: "professionalId") as? String ?? ""
                
                customInfoWindow.lblId.text = "Pro.Id.-\(professionalID)"
            }
            
            if type == "business"{
                
                let businessId = dict.object(forKey: "businessId") as? String ?? ""
                
                customInfoWindow.lblId.text = "BussinessId:\(businessId)"
            }
            
            
            customInfoWindow.infoWindowBtn.tag = index
            customInfoWindow.infoWindowBtn.addTarget(self, action: #selector(self.tap_infoWindowBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            
            customInfoWindow.btnLike.tag = index
            customInfoWindow.btnLike.addTarget(self, action: #selector(self.tap_likeBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindow.btnShare.tag = index
            customInfoWindow.btnShare.addTarget(self, action: #selector(self.tap_ShareBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindow.btnCall.tag = index
            customInfoWindow.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindow.btnChat.tag = index
            customInfoWindow.btnChat.addTarget(self, action: #selector(self.tap_ChatBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            //////
            
            customInfoWindow.center = mapView.projection.point(for: location)
            customInfoWindow.center.y = customInfoWindow.center.y - sizeForOffset(view: customInfoWindow) - 15
            customInfoWindow.center.x = customInfoWindow.center.x
            self.myMapView.addSubview(customInfoWindow)
            
            return true
            
        }
        else if type == "sale" || type == "rent"{
            
            locationMarker = marker
            guard let location = locationMarker?.position else {
                return false
            }
            
            
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            if likeStatus == "yes"{
                
                customInfoWindowProperty.btnLike.setImage(UIImage(named: "like_icon_new"), for: .normal)
            }
            else{
                
                customInfoWindowProperty.btnLike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
            }
            
            
            customInfoWindowProperty.lblTitle.text = dict.object(forKey: "title") as? String ?? ""
            customInfoWindowProperty.lblCategory.text = dict.object(forKey: "category") as? String ?? ""
            
            let plotSize = dict.object(forKey: "plotSize") as? String ?? ""
            let plotSizeUnit = dict.object(forKey: "plotSizeUnit") as? String ?? ""
            
            customInfoWindowProperty.lblDetails.text = "\(plotSize)\(plotSizeUnit)"
            
            if type == "sale"{
                
                let totalPrice = dict.object(forKey: "totalPriceSale") as? String ?? ""
                
                let currency = dict.object(forKey: "currency") as? String ?? ""
                
                customInfoWindowProperty.lblPrice.text = "\(currency) \(totalPrice)"
                
                //  let pricePerMeter = dict.object(forKey: "pricePerMeter") as? String ?? ""
                
                // cell.lblSquareMeter.text = "SAR \(pricePerMeter) M2"
            }
            else{
                
                let totalPrice = dict.object(forKey: "totalPriceRent") as? String ?? ""
                
                let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                
                let currency = dict.object(forKey: "currency") as? String ?? ""
                
                customInfoWindowProperty.lblPrice.text = "\(currency) \(totalPrice) \(rentTime)"
            }
            
            let imageArr = dict.object(forKey: "imagesFile") as? NSArray ?? []
            if imageArr.count == 0{
                
                customInfoWindowProperty.imgProperty.image = UIImage(named: "defaultProperty")
            }
            else{
                
                let dict = imageArr.object(at: 0) as? NSDictionary ?? [:]
                let imageStr = dict.object(forKey: "image") as? String ?? ""
                
                if imageStr != ""{
                    
                    let urlStr = URL(string: imageStr)
                    customInfoWindowProperty.imgProperty.setImageWith(urlStr, placeholderImage: UIImage(named: "defaultProperty"))
                }
                else{
                    
                    customInfoWindowProperty.imgProperty.image = UIImage(named: "defaultProperty")
                }
            }
            
            customInfoWindowProperty.btnInfoWindow.tag = index
            customInfoWindowProperty.btnInfoWindow.addTarget(self, action: #selector(self.tap_infoWindowForProperty(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindowProperty.btnLike.tag = index
            customInfoWindowProperty.btnLike.addTarget(self, action: #selector(self.tap_likeProperty(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindowProperty.btnShare.tag = index
            customInfoWindowProperty.btnShare.addTarget(self, action: #selector(self.tap_ShareBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindowProperty.btnCall.tag = index
            customInfoWindowProperty.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindowProperty.btnChat.tag = index
            customInfoWindowProperty.btnChat.addTarget(self, action: #selector(self.tap_ChatBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            customInfoWindowProperty.center = mapView.projection.point(for: location)
            customInfoWindowProperty.center.y = customInfoWindowProperty.center.y - sizeForOffset(view: customInfoWindowProperty) - 40
            customInfoWindowProperty.center.x = customInfoWindowProperty.center.x
            self.myMapView.addSubview(customInfoWindowProperty)
            
            return true
        }
        else{
            
            return false
            
        }
      
    }
    
    
    @objc func tap_infoWindowBtn(sender:UIButton){
        
        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalNameController") as! ProfessionalNameController
        
        let idOfUserAsNormal = dict.object(forKey: "userId") as? String ?? ""
        
        if type == "professional"{
            
            vc.headerTitle = "Professional Name"
            vc.userType = "Professional"
        }
        
        if type == "business"{
            
            vc.headerTitle = "Business Name"
            vc.userType = "Business"
        }
        
        vc.IdAsNormal = idOfUserAsNormal
        vc.dataDict = dict
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func tap_likeBtn(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            let id = dict.object(forKey: "_id") as? String ?? ""
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            var sendLikeDislikeStatus = false
            
            if likeStatus == "yes"{
                
                sendLikeDislikeStatus = false
            }
            else{
                
                sendLikeDislikeStatus = true
            }
            
            self.apiCallForLikeDislike(type: type, status: sendLikeDislikeStatus, propertyId: "", profileId: id, seprationType: "UserProfile")
            
        }
        else{
            
            self.makeRootToLoginSignup()
        }
        
    }
    
    
//    @objc func tap_CallBtn(sender:UIButton){
//
//        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
//        let type = dict.object(forKey: "Type") as? String ?? ""
//
//        if type == "sale" || type == "rent"{
//
//
//        }
//        else{
//
//
//        }
//    }
    
    @objc func tap_ChatBtn(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
            let receiverId = dict.object(forKey: "userId") as? String ?? ""
            
            let propertyId = dict.object(forKey: "_id") as? String ?? ""
            
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            var headerName = ""
            
            if type == "sale" || type == "rent"{
            
                headerName = dict.object(forKey: "title") as? String ?? ""
                
            }
            else{
            
                headerName = dict.object(forKey: "fullName") as? String ?? ""
            }
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
            
            vc.receiverID = receiverId
            
            vc.propertyID = propertyId
            
            vc.headerName = headerName
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        else{
            
            self.makeRootToLoginSignup()
        }
       
    }
    
    @objc func tap_ShareBtn(sender:UIButton){
        
        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        if type == "sale" || type == "rent"{
            
            let propertyTitle = dict.object(forKey: "title") as? String ?? ""
            
            self.shareProperty(propertyTitle: propertyTitle, propertyType: type)
        }
        else{
            
            let name = dict.object(forKey: "fullName") as? String ?? ""
            
            self.shareProfile(userName: name, profileType: type)
        }
    }
    
    @objc func tap_likeProperty(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            let id = dict.object(forKey: "_id") as? String ?? ""
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            var sendLikeDislikeStatus = false
            
            if likeStatus == "yes"{
                
                sendLikeDislikeStatus = false
            }
            else{
                
                sendLikeDislikeStatus = true
            }
            
             self.apiCallForLikeDislike(type: type, status: sendLikeDislikeStatus, propertyId: id, profileId: "", seprationType: "Property")
            
        }
        else{
            
            self.makeRootToLoginSignup()
        }
        
    }
    
    
    @objc func tap_infoWindowForProperty(sender:UIButton){
        
        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyTitleController") as! PropertyTitleController
        
        let propertyId = dict.object(forKey: "_id") as? String ?? ""
        
        let profId = dict.object(forKey: "professionalUserId") as? String ?? ""
        
        vc.propertyType = type
        vc.propertyId = propertyId
        
        vc.profUserID = profId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.customInfoWindowProperty.removeFromSuperview()
        self.customInfoWindow.removeFromSuperview()
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                return
            }
            
            customInfoWindow.center = myMapView.projection.point(for: location)
            customInfoWindow.center.y = customInfoWindow.center.y - sizeForOffset(view: customInfoWindow) - 15
            customInfoWindow.center.x = customInfoWindow.center.x
            
            
            customInfoWindowProperty.center = myMapView.projection.point(for: location)
            customInfoWindowProperty.center.y = customInfoWindowProperty.center.y - sizeForOffset(view: customInfoWindowProperty) - 40
            customInfoWindowProperty.center.x = customInfoWindowProperty.center.x
            
        }
        
    }
    
    
    func sizeForOffset(view: UIView) -> CGFloat {
        return  96.0
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat{
        return 110.0
    }
    
}



extension HomeController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView{
            
            return self.finalArray.count
            
        }
        else{
            
            return self.propertyCategoryArr.count
        }
       
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.collectionView{
            
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForUpperOption
            
            cell.lblTitle.textColor = finalArray[indexPath.row].color
            cell.lblTitle.text = finalArray[indexPath.item].text
            
            cell.bottomView.backgroundColor = finalArray[indexPath.row].bottomViewColor
            cell.bottomView.isHidden = finalArray[indexPath.row].isBottomViewHidden
            
            return cell
        }
        else{
            
            let cell = self.subCatCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCatCollectionViewCell", for: indexPath) as! SubCatCollectionViewCell
            
            if self.subCategorySelectionArr.object(at: indexPath.item) as? String ?? "" == "0"{
                
                cell.tickIcon.isHidden = true
                
            }
            else{
                
                cell.tickIcon.isHidden = false
            }
            
            if self.selectedIndexTab == 1{
                
                cell.layer.borderColor = UIColor(red:0.95, green:0.08, blue:0.15, alpha:1.0).cgColor
                cell.lblCatName.textColor = UIColor(red:0.95, green:0.08, blue:0.15, alpha:1.0)
            }
            else if self.selectedIndexTab == 2{
                
                cell.layer.borderColor = UIColor(red:0.12, green:0.66, blue:0.13, alpha:1.0).cgColor
                cell.lblCatName.textColor = UIColor(red:0.12, green:0.66, blue:0.13, alpha:1.0)
            }
            else if self.selectedIndexTab == 3{
                
                cell.layer.borderColor = UIColor(red:0.93, green:0.41, blue:0.12, alpha:1.0).cgColor
                cell.lblCatName.textColor = UIColor(red:0.93, green:0.41, blue:0.12, alpha:1.0)
            }
            else if self.selectedIndexTab == 4{
                
                cell.layer.borderColor = UIColor(red:0.55, green:0.14, blue:0.93, alpha:1.0).cgColor
                cell.lblCatName.textColor = UIColor(red:0.55, green:0.14, blue:0.93, alpha:1.0)
            }
            
            let name = propertyCategoryArr.object(at: indexPath.item) as? String ?? ""
            cell.lblCatName.text = name
            
            return cell
        }
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView{
            
            selectedIndexTab = indexPath.row
            
            if indexPath.row == 0 {
                
                view_houseApart.isHidden = true
                
                self.totalPropertiesTopConstraint.constant = 15.0
                
            }else{
                
                view_houseApart.isHidden = false
                
                self.totalPropertiesTopConstraint.constant = 67.5
            }
            
            for i in 0 ..< textArr.count{
                
                if i == indexPath.row {
                    self.finalArray[indexPath.row].bottomViewColor = colorArr[indexPath.row]
                    self.finalArray[indexPath.row].isBottomViewHidden = false
                }else{
                    self.finalArray[i].bottomViewColor = colorArr[indexPath.row]
                    self.finalArray[i].isBottomViewHidden = true
                }
            }
            
            self.collectionView.reloadData()
            
            var type = ""
            
            if indexPath.row == 0{
                
                type = ""
                selectedGlobalSubType = ""
            }
            else if indexPath.row == 1{
                
                self.apiCallForGetCategoryList()
                
                type = "sale"
                selectedGlobalSubType = "sale"
                
            }
            else if indexPath.row == 2{
                
                self.apiCallForGetCategoryList()
                
                type = "rent"
                selectedGlobalSubType = "rent"
            }
            else if indexPath.row == 3{
                
                self.apiCallForFetchCategory()
                
                type = "professional"
                selectedGlobalSubType = "professional"
            }
            else if indexPath.row == 4{
                
                self.apiCallForFetchCategory()
                
                type = "business"
                selectedGlobalSubType = "business"
                
            }
            
            self.apiCallForFetchPropertyListing(type: type)
            
        }
        else{
            
            let count = self.subCategorySelectionArr.count
            
            self.subCategorySelectionArr.removeAllObjects()
            
            for _ in 0..<count{
                
                self.subCategorySelectionArr.add("0")
            }
            
            self.subCategorySelectionArr.replaceObject(at: indexPath.item, with: "1")
            
            self.subCatCollectionView.reloadData()
            
            var categoryStr = ""
            
            categoryStr = self.propertyCategoryArr.object(at: indexPath.row) as? String ?? ""
            
            self.globalSubcategoryForList = categoryStr
            
            self.apiCallForGetPropertyBasedOnSubCategory(typeStr: selectedGlobalSubType, categoryStr: categoryStr)
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 90.0, height: 40.0)
    }
}



//MARK:- LocationManager Delegate
//MARK:-
extension HomeController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.myLocationBackupLat = currentLocation.coordinate.latitude
            self.myLocationBackupLong = currentLocation.coordinate.longitude
            
            let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 12.0)
            myMapView.camera = camera
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        NSLog("error = %@", error.localizedDescription)
        
    }
    
    func locationAuthorizationStatus(status:CLAuthorizationStatus)
    {
        
        switch status
        {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location AuthorizedWhenInUse/AuthorizedAlways")
            self.myMapView.isMyLocationEnabled = true
            
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                self.locationManager.headingFilter = 100
            }
            
        case .denied, .notDetermined, .restricted:
            print("Location Denied/NotDetermined/Restricted")
            self.myMapView.isMyLocationEnabled = false
            self.locationManager.stopUpdatingLocation()
            
        }
        
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
        {
            
        }
        
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
        {
            
        }
        
        func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
        {
            print("Now monitoring :  \(manager.location?.coordinate) for \(region.identifier) radius: \(region.identifier)")
        }
        
        func locationManager(_ manager: CLLocationManager,
                             monitoringDidFailFor region: CLRegion?, withError error: Error)
        {
            print("monitoringDidFailForRegion \(region!.identifier) \(error.localizedDescription) \(error.localizedDescription)")
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didDetermineState state: CLRegionState, for region: CLRegion)
        {
            var stateName = ""
            switch state {
            case .inside:
                stateName = "Inside"
            case .outside:
                stateName = "Outside"
            case .unknown:
                stateName = "Unknown"
            }
            print("didDetermineState \(stateName) \(region.identifier)")
            
        }
    }
}


//MARK:- SearchController Delegate
//MARK:-
extension HomeController:FilterDataDelegate{
    
    
    func dataForFilter(id: String, category: String, purpuse: String, availabilty: String, bedroom: String, bathroom: String, kitchen: String, buildMin: String, buildMax: String, budgetMin: String, budgetMax: String, year: String, hasPhoto: Bool, hasvideo: Bool, switchBalcony: Bool, switchGarden: Bool, switchParking: Bool, switchKitchen: Bool, selectedType: String, switchLift: Bool, switchDuplex: Bool, switchStore: Bool, switchAirConditioning: Bool, switchFurnitured: Bool) {
        
        if selectedType == "sale" || selectedType == "rent"{
        
        if selectedType == "sale"{
        
            selectedIndexTab = 1
        
            self.apiCallForGetCategoryList()
        
            selectedGlobalSubType = "sale"
        
        }
        else if selectedType == "rent"{
        
            selectedIndexTab = 2
        
            self.apiCallForGetCategoryList()
        
            selectedGlobalSubType = "rent"
        
        }
        
        self.view_houseApart.isHidden = false
        
        if collectionView == self.collectionView{
        
            for i in 0 ..< textArr.count{
        
                if i == selectedIndexTab {
                    
                    self.finalArray[i].bottomViewColor = colorArr[i]
                    self.finalArray[i].isBottomViewHidden = false
                    
                }else{
                    
                    self.finalArray[i].bottomViewColor = colorArr[i]
                    self.finalArray[i].isBottomViewHidden = true
                }
        }
        
            self.collectionView.reloadData()
        
        }
        
        
            self.apiCallForSaleAndRentFilter(id: id, category: category, purpuse: purpuse, availabilty: availabilty, bedroom: bedroom, bathroom: bathroom, kitchen: kitchen, buildMin: buildMin, buildMax: buildMax, budgetMin: budgetMin, budgetMax: budgetMax, year: year, hasPhoto: hasPhoto, hasvideo: hasvideo, switchBalcony: switchBalcony, switchGarden: switchGarden, switchParking: switchParking, switchKitchen: switchKitchen, selectedType: selectedType, switchList: switchLift, switchDuplex: switchDuplex, switchFurnished: switchFurnitured, switchAirConditioner: switchAirConditioning, switchStore: switchStore)
            
            
           // self.apiCallForSaleAndRentFilter(id: id, category: category, purpuse: purpuse, availabilty: availabilty, bedroom: bedroom, bathroom: bathroom, kitchen: kitchen, buildMin: buildMin, buildMax: buildMax, budgetMin: budgetMin, budgetMax: budgetMax, year: year, hasPhoto: hasPhoto, hasvideo: hasvideo, switchBalcony: switchBalcony, switchGarden: switchGarden, switchParking: switchParking, switchKitchen: switchKitchen, selectedType: selectedType)
        
        }
        
    }
    
    
//    func dataForFilter(id: String, category: String, purpuse: String, availabilty: String, bedroom: String, bathroom: String, kitchen: String, buildMin: String, buildMax: String, budgetMin: String, budgetMax: String, year: String, hasPhoto: Bool, hasvideo: Bool, switchBalcony: Bool, switchGarden: Bool, switchParking: Bool, switchKitchen: Bool, selectedType: String) {
//
//
//        if selectedType == "sale" || selectedType == "rent"{
//
//            if selectedType == "sale"{
//
//                selectedIndexTab = 1
//
//                self.apiCallForGetCategoryList()
//
//                selectedGlobalSubType = "sale"
//
//            }
//            else if selectedType == "rent"{
//
//                selectedIndexTab = 2
//
//                self.apiCallForGetCategoryList()
//
//                selectedGlobalSubType = "rent"
//
//            }
//
//            self.view_houseApart.isHidden = false
//
//            if collectionView == self.collectionView{
//
//                for i in 0 ..< textArr.count{
//
//                    if i == selectedIndexTab {
//                        self.finalArray[i].bottomViewColor = colorArr[i]
//                        self.finalArray[i].isBottomViewHidden = false
//                    }else{
//                        self.finalArray[i].bottomViewColor = colorArr[i]
//                        self.finalArray[i].isBottomViewHidden = true
//                    }
//                }
//
//                self.collectionView.reloadData()
//
//            }
//
//
//            self.apiCallForSaleAndRentFilter(id: id, category: category, purpuse: purpuse, availabilty: availabilty, bedroom: bedroom, bathroom: bathroom, kitchen: kitchen, buildMin: buildMin, buildMax: buildMax, budgetMin: budgetMin, budgetMax: budgetMax, year: year, hasPhoto: hasPhoto, hasvideo: hasvideo, switchBalcony: switchBalcony, switchGarden: switchGarden, switchParking: switchParking, switchKitchen: switchKitchen, selectedType: selectedType)
//
//        }
//
//    }
    
    
    
}



extension HomeController:FilterBussinessAndProfessionalDelegate{
    
    func professionalBusinessData(name: String, id: String, professionalCategory: String, professionalSubcategory: String, location: String, lat: String, long: String, specalities: String, areaCovered: String, spokenLanguage: String, selectedType: String) {
        
        if selectedType == "professional" || selectedType == "business"{
            
            if selectedType == "professional"{
                
                self.apiCallForFetchCategory()
                
                selectedGlobalSubType = "professional"
                
                selectedIndexTab = 3
            }
            else if selectedType == "business"{
                
                self.apiCallForFetchCategory()
                
                selectedIndexTab = 4
                selectedGlobalSubType = "business"
            }
            
            if collectionView == self.collectionView{
                
                for i in 0 ..< textArr.count{
                    
                    if i == selectedIndexTab {
                        self.finalArray[i].bottomViewColor = colorArr[i]
                        self.finalArray[i].isBottomViewHidden = false
                    }else{
                        self.finalArray[i].bottomViewColor = colorArr[i]
                        self.finalArray[i].isBottomViewHidden = true
                    }
                }
                
                self.collectionView.reloadData()
                
            }
            
            self.apiCallForFilterBussinessAndProfessional(type: selectedType, fullName: name, id: id, location: location, lat: lat, long: long, category: professionalCategory, subcategory: professionalSubcategory, specailities: specalities, areaCovered: areaCovered, spokenLanguage: spokenLanguage)
            
        }
        
    }
    
}




//MARK:- Webservices
//MARK:-
extension HomeController{
    
    func apiCallForFetchPropertyListing(type:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":type,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
        self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForPropertyListing as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            self.lblTotalProperties.text = "Total Properties Count : \(self.propertyDataArr.count)"
                            
                            self.showMarker()
                            
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    ////api for keyword search
    
    func apiCallForKeywordSearch(searchedTxt:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["searchText":searchedTxt]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForPropertySearchByKeywords as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            self.lblTotalProperties.text = "Total Properties Count : \(self.propertyDataArr.count)"
                            
                            self.showMarker()
                            
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    ////
    
    func apiCallForGetPropertyBasedOnSubCategory(typeStr:String,categoryStr:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":typeStr,"category":categoryStr,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetpropertyCategory as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            self.lblTotalProperties.text = "Total Properties Count : \(self.propertyDataArr.count)"
                            
                            if self.propertyDataArr.count == 0{
                                
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: "No data found.", controller: self)
                            }
                            
                            self.showMarker()
                            
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                        CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                        
                    }
                }
                else{
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForUpdatePropertyDays(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForUpdatePropertyDays as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForGetCategoryList(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetPropertyCategoryListing as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSArray{
                            
                            self.propertyCategoryArr.removeAllObjects()
                            
                            self.subCategorySelectionArr.removeAllObjects()
                            
                            for i in 0..<data.count{
                                
                                let dict = data.object(at: i) as? NSDictionary ?? [:]
                                
                                let name = dict.object(forKey: "name") as? String ?? ""
                                
                                self.propertyCategoryArr.add(name)
                                
                                self.subCategorySelectionArr.add("0")
                                
                            }
                            
                            self.subCatCollectionView.reloadData()
                            
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else{
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForFetchCategory(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetCategoryList as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let dataArr = receivedData.object(forKey: "data") as? NSArray ?? []
                        
                        self.propertyCategoryArr.removeAllObjects()
                        
                        self.subCategorySelectionArr.removeAllObjects()
                        
                        
                        if dataArr.count != 0{
                            
                            for i in 0..<dataArr.count{
                                
                                let dict = dataArr.object(at: i) as? NSDictionary ?? [:]
                                let name = dict.object(forKey: "name") as? String ?? ""
                                self.propertyCategoryArr.add(name)
                                
                                self.subCategorySelectionArr.add("0")
                            }
                        }
                        
                        self.subCatCollectionView.reloadData()
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    
    
    func apiCallForSaleAndRentFilter(id: String, category: String, purpuse: String, availabilty: String, bedroom: String, bathroom: String, kitchen: String, buildMin: String, buildMax: String, budgetMin: String, budgetMax: String, year: String, hasPhoto: Bool, hasvideo: Bool, switchBalcony: Bool, switchGarden: Bool, switchParking: Bool, switchKitchen: Bool, selectedType: String, switchList: Bool, switchDuplex: Bool, switchFurnished: Bool, switchAirConditioner: Bool, switchStore: Bool){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var param:[String:Any] = [:]
            
            if selectedType == "sale"{
                
//                param = ["type":selectedType,"propertyId":id,"category":category,"purpose":purpuse,"available":availabilty,"bedrooms":bedroom,"bathrooms":bathroom,"kitchens":kitchen,"plotSizeMin":buildMin,"plotSizeMax":buildMax,"totalPriceMin":budgetMin,"totalPriceMax":budgetMax,"yearBuilt":year,"balcony":switchBalcony,"garden":switchGarden,"parking":switchParking,"modularKitchen":switchKitchen,"photos":hasPhoto,"videos":hasvideo,"store":switchStore,"lift":switchList,"duplex":switchDuplex,"furnished":switchFurnished,"aircondition":switchAirConditioner,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""] as [String : Any]
                
                 param = ["type":selectedType,"propertyId":id,"category":category,"purpose":purpuse,"available":availabilty,"bedrooms":bedroom,"bathrooms":bathroom,"kitchens":kitchen,"plotSizeMin":buildMin,"plotSizeMax":buildMax,"totalPriceMin":budgetMin,"totalPriceMax":budgetMax,"yearBuilt":year,"balcony":"\(switchBalcony)","garden":"\(switchGarden)","parking":"\(switchParking)","modularKitchen":"\(switchKitchen)","photos":"\(hasPhoto)","videos":"\(hasvideo)","store":"\(switchStore)","lift":"\(switchList)","duplex":"\(switchDuplex)","furnished":"\(switchFurnished)","aircondition":"\(switchAirConditioner)","userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""] as [String : Any]
                
                
            }
            else{
                
//                  param = ["type":selectedType,"propertyId":id,"category":category,"purpose":purpuse,"available":availabilty,"bedrooms":bedroom,"bathrooms":bathroom,"kitchens":kitchen,"rentTime":buildMin,"totalPriceMin":budgetMin,"totalPriceMax":budgetMax,"yearBuilt":year,"balcony":switchBalcony,"garden":switchGarden,"parking":switchParking,"modularKitchen":switchKitchen,"photos":hasPhoto,"videos":hasvideo,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","store":switchStore,"lift":switchList,"duplex":switchDuplex,"furnished":switchFurnished,"aircondition":switchAirConditioner] as [String : Any]
                
                 param = ["type":selectedType,"propertyId":id,"category":category,"purpose":purpuse,"available":availabilty,"bedrooms":bedroom,"bathrooms":bathroom,"kitchens":kitchen,"rentTime":buildMin,"totalPriceMin":budgetMin,"totalPriceMax":budgetMax,"yearBuilt":year,"balcony":"\(switchBalcony)","garden":"\(switchGarden)","parking":"\(switchParking)","modularKitchen":"\(switchKitchen)","photos":"\(hasPhoto)","videos":"\(hasvideo)","userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","store":"\(switchStore)","lift":"\(switchList)","duplex":"\(switchDuplex)","furnished":"\(switchFurnished)","aircondition":"\(switchAirConditioner)"] as [String : Any]
            }
            
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForFilterRentSale as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            self.lblTotalProperties.text = "Total Properties Count : \(self.propertyDataArr.count)"
                            
                            self.showMarker()
                            
                            if data.count == 0{
                                
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                            }
                        }
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                    }
                }
                else{
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
                
            }
            
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    //// filter bussiness and professional
    
    func apiCallForFilterBussinessAndProfessional(type:String,fullName:String,id:String,location:String,lat:String,long:String,category:String,subcategory:String,specailities:String,areaCovered:String,spokenLanguage:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var idKey = ""
            
            if type == "professional"{
                
                idKey = "professionalId"
            }
            else{
                
                idKey = "businessId"
            }
            
            let param = ["type":type,"fullName":fullName,"\(idKey)":id,"category":category,"subCategory":subcategory,"specialities":specailities,"lat":lat,"long":long,"area":areaCovered,"speakLanguage":spokenLanguage,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForFilterBusinessAndProfessional as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            self.lblTotalProperties.text = "Total Properties Count : \(self.propertyDataArr.count)"
                            
                            self.showMarker()
                            
                            if data.count == 0{
                                
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: "No data found for your request", controller: self)
                            }
                        }
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                    }
                }
                else{
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    
    //*******************
    
    func apiCallForLikeDislike(type:String,status:Bool,propertyId:String,profileId:String,seprationType:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var param:[String:Any] = [:]
            
            if type == "sale" || type == "rent"{
                
                param = ["type":type,"propertyId":propertyId,"liked":status,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
                
            }
            else{
                
                param = ["type":type,"profbusinessId":profileId,"liked":status,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            }
            
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForLikeDislike as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        var propertyType = ""
                        
                        if self.selectedIndexTab == 0{
                            
                            propertyType = ""
                        }
                        else if self.selectedIndexTab == 1{
                            
                            propertyType = "sale"
                        }
                        else if self.selectedIndexTab == 2{
                            
                            propertyType = "rent"
                        }
                        else if self.selectedIndexTab == 3{
                            
                            propertyType = "professional"
                        }
                        else if self.selectedIndexTab == 4{
                            
                            propertyType = "business"
                        }
                        
                        self.apiCallForFetchPropertyListing(type: propertyType)
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    ////api for search by google place
    
    func apiCallForSearchByPlace(lat:String,long:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var type = ""
            
            if self.selectedIndexTab == 0{
                
                type = ""
                selectedGlobalSubType = ""
            }
            else if self.selectedIndexTab == 1{
                
                type = "sale"
                selectedGlobalSubType = "sale"
                
            }
            else if self.selectedIndexTab == 2{
                
                type = "rent"
                selectedGlobalSubType = "rent"
            }
            else if self.selectedIndexTab == 3{
                
                type = "professional"
                selectedGlobalSubType = "professional"
            }
            else if self.selectedIndexTab == 4{
                
                type = "business"
                selectedGlobalSubType = "business"
                
            }
            
            let param = ["lat":lat,"long":long,"type":type,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForSearchByPlace as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                UserDefaults.standard.set(false, forKey: "PreventViewWillAppear")
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            let camera = GMSCameraPosition.camera(withLatitude: Double(lat)!, longitude: Double(long)!, zoom: 7.0)
                            self.myMapView.camera = camera
                            self.myMapView.animate(to: camera)
                            
                            self.propertyDataArr = data
                            
                            self.lblTotalProperties.text = "Total Properties Count : \(self.propertyDataArr.count)"
                            
                            self.showMarker()
                            
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}


extension HomeController:SearchByLocationDelegate{
    
    func searchByLocationData(lat: String, long: String, address: String) {
        
        if lat != "" && long != ""{
            
            let lati = lat.trimmingCharacters(in: .whitespaces)
            let longi = long.trimmingCharacters(in: .whitespaces)
            
            let doubleLat = Double(lati)!
            let doubleLong = Double(longi)!
            
            let camera = GMSCameraPosition.camera(withLatitude: doubleLat, longitude: doubleLong, zoom: 7.0)
            self.myMapView.camera = camera
            self.myMapView.animate(to: camera)
        }
        
       self.searchByLocation = true
       self.apiCallForSearchByPlace(lat: lat, long: long)
        
    }

}

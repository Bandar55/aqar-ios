//
//  ListController.swift
//  Aqar55
//
//  Created by Callsoft on 06/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import KYDrawerController
import IQKeyboardManager

class ListController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var btnCategory: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
  
    @IBOutlet weak var txtKeywordSearch: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    
    var selectedIndexTab = 0
    let textArr = ["All","Sale","Rent","Professional","Business"]
    
    let colorArr = [UIColor(red: 17/255, green: 0/255, blue: 254/255, alpha: 1.0),
                    UIColor(red: 244/255, green: 0/255, blue: 13/255, alpha: 1.0),
                    UIColor(red: 0/255, green: 166/255, blue: 0/255, alpha: 1.0),
                    UIColor(red: 239/255, green: 105/255, blue: 0/255, alpha: 1.0),
                    UIColor(red: 141/255, green: 0/255, blue: 242/255, alpha: 1.0)]
    
    var finalArray = [HomeModel]()
    
    let connection = webservices()
    var propertyDataArr = NSArray()
 
    var selectedGlobalType = ""
    
    
    ////Listed PropertyOf Map CategoryWise from last
    
    var isValidForOnlySingleTime = true
    var preSelectedIndex = 0
    var preSelectedType = ""
    var preSelectedSubType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblPlaceholder.isHidden = true
        tableView.tableFooterView = UIView()
        
        constraintTop.constant = 15
        self.tableView.register(UINib(nibName: "CellForRentAndSale", bundle: nil), forCellReuseIdentifier: "CellForRentAndSale")
        self.tableView.register(UINib(nibName: "CellForProfessionalAndBusiness", bundle: nil), forCellReuseIdentifier: "CellForProfessionalAndBusiness")

        CommonMethod.paddingTextfield(txtField: txtKeywordSearch)
        
        txtKeywordSearch.leftView = UIImageView(image: UIImage(named: "search_button"))
        txtKeywordSearch.leftViewMode = .always
        
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
        
        self.selectedGlobalType = ""
        
        txtKeywordSearch.addDoneOnKeyboard(withTarget: self, action: #selector(doneButtonClicked))
        
        
        UserDefaults.standard.set(false, forKey: "PreventList")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.bool(forKey: "PreventList"){
            
            //do nothing
        }
        else{
            
            if isValidForOnlySingleTime{
                
                //setup for api call based on category and subcategory
                
                self.selectedIndexTab = preSelectedIndex
                
                for i in 0 ..< textArr.count{
                    
                    if i == preSelectedIndex {
                        
                        self.finalArray[preSelectedIndex].bottomViewColor = colorArr[preSelectedIndex]
                        self.finalArray[preSelectedIndex].isBottomViewHidden = false
                        
                    }else{
                        
                        self.finalArray[i].bottomViewColor = colorArr[preSelectedIndex]
                        self.finalArray[i].isBottomViewHidden = true
                    }
                }
                
                self.collectionView.reloadData()
                
                if self.propertyDataArr.count != 0{
                    
                    self.lblPlaceholder.isHidden = true
                    self.tableView.isHidden = false
                }
                else{
                    
                    self.lblPlaceholder.isHidden = false
                    self.tableView.isHidden = true
                }
                
                self.tableView.reloadData()
                
            }
            else{
                
                if self.selectedIndexTab == 0{
                    
                    selectedGlobalType = ""
                }
                else if self.selectedIndexTab == 1{
                    
                    selectedGlobalType = "sale"
                }
                else if self.selectedIndexTab == 2{
                    
                    selectedGlobalType = "rent"
                }
                else if self.selectedIndexTab == 3{
                    
                    selectedGlobalType = "professional"
                }
                else if self.selectedIndexTab == 4{
                    
                    selectedGlobalType = "business"
                }
                
                self.apiCallForFetchPropertyListing(type: selectedGlobalType)
                
            }
            
        }
        
        UserDefaults.standard.set(false, forKey: "PreventList")
        
    }
    
    
    @IBAction func btnUpperOptionAction(_ sender: UIButton) {
        
        selectedIndexTab = sender.tag
        
        UIView.animate(withDuration: 0.3) {
            
            self.bottomView.frame.origin.x = self.btnCategory[sender.tag].frame.origin.x
            self.bottomView.backgroundColor = self.btnCategory[sender.tag].titleLabel?.textColor
        }
        
        if sender.tag == 1 || sender.tag == 2{
            
        }
        
        if sender.tag == 3 || sender.tag == 4{
            
            
        }
        self.tableView.reloadData()
    }
    
    @IBAction func btnAddPropertyAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyController") as! PostPropertyController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnFilterAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func tap_searchByLocationBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.delegate = self
        
        vc.controllerPurpuse = "List"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnSortByAction(_ sender: Any) {
        
        if selectedIndexTab == 0 || selectedIndexTab == 1 || selectedIndexTab == 2{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SortByController") as! SortByController
            
            vc.delegate = self
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SortbyAlphabeticallyVC") as! SortbyAlphabeticallyVC
            
            vc.delegate = self
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
      
    }

    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBottomBarButtonAction(_ sender: UIButton) {
        
        if sender.tag == 0{
          //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListController") as! ListController
           // self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.popViewController(animated: true)
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
            
            ///call api for keyword search
            
            self.apiCallForKeywordSearch(searchedTxt: txtKeywordSearch.text!)
            
        }
    }

}

extension ListController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return propertyDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedIndexTab == 0{
            
            ////*****************
            ////write here the code for all property
            
            let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            if type == "sale" || type == "rent"{
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForRentAndSale", for: indexPath) as! CellForRentAndSale
                
                cell.btnChat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)
                cell.btnDelete.isHidden = true
                
                cell.btnLikeDislike.tag = indexPath.row
                cell.btnLikeDislike.addTarget(self, action: #selector(self.tapSaleAndRentLikeBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.btnShare.tag = indexPath.row
                cell.btnShare.addTarget(self, action: #selector(self.tap_shareBtn(sender:)), for: UIControl.Event.touchUpInside)

                cell.btnCall.tag = indexPath.row
                cell.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.btnChat.tag = indexPath.row
                cell.btnChat.addTarget(self, action: #selector(self.btnChatAction(sender:)), for: UIControl.Event.touchUpInside)
                
                if likeStatus == "yes"{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                }
                else{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
                }
                
                cell.lblTitle.text = dict.object(forKey: "title") as? String ?? ""
                cell.lblPropertyType.text = dict.object(forKey: "category") as? String ?? ""
                let plotSize = dict.object(forKey: "plotSize") as? String ?? ""
                let plotSizeUnit = dict.object(forKey: "plotSizeUnit") as? String ?? ""
                
                cell.lblPricePerMeter.text = "\(plotSize)\(plotSizeUnit)"
                
                if type == "sale"{
  
                    let totalPrice = dict.object(forKey: "totalPriceSale") as? String ?? ""
                    
                    let currency = dict.object(forKey: "currency") as? String ?? ""
                    
                    cell.lblPrice.text = "\(currency) \(totalPrice)"
                    
                    let pricePerMeter = dict.object(forKey: "pricePerMeter") as? String ?? ""
                    
                    cell.lblSquareMeter.text = "\(currency) \(pricePerMeter)M2"
                    
                }
                else if type == "rent"{
                    
                    let totalPrice = dict.object(forKey: "totalPriceRent") as? String ?? ""
                    
                    let currency = dict.object(forKey: "currency") as? String ?? ""
                    
                    let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                    
                    cell.lblPrice.text = "\(currency) \(totalPrice) \(rentTime)"
                    
                    cell.lblSquareMeter.text = "      "
                }
                
                let imageArr = dict.object(forKey: "imagesFile") as? NSArray ?? []
                if imageArr.count == 0{
                    
                    cell.imgProperty.image = UIImage(named: "defaultProperty")
                }
                else{
                    
                    let dict = imageArr.object(at: 0) as? NSDictionary ?? [:]
                    let imageStr = dict.object(forKey: "image") as? String ?? ""
                    
                    if imageStr != ""{
                        
                        let urlStr = URL(string: imageStr)
                        cell.imgProperty.setImageWith(urlStr, placeholderImage: UIImage(named: "defaultProperty"))
                    }
                    else{
                        
                        cell.imgProperty.image = UIImage(named: "defaultProperty")
                    }
                }
                
                cell.selectionStyle = .none
                return cell
                
            }
            else{
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForProfessionalAndBusiness", for: indexPath) as! CellForProfessionalAndBusiness
                
                cell.btnDelete.isHidden = true
                
                cell.btnLikeDislike.tag = indexPath.row
                cell.btnLikeDislike.addTarget(self, action: #selector(self.tapProfessionalAndBussinessLikeBtn(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.btnShare.tag = indexPath.row
                cell.btnShare.addTarget(self, action: #selector(self.tap_shareBtn(sender:)), for: UIControl.Event.touchUpInside)

                cell.btnCall.tag = indexPath.row
                cell.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.btnChat.tag = indexPath.row
                cell.btnChat.addTarget(self, action: #selector(self.btnChatAction(sender:)), for: UIControl.Event.touchUpInside)
                
                let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
                
                let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
                
                if likeStatus == "yes"{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                }
                else{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
                }
                
                
                
                let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
                
                if imgStr == ""{
                    
                    cell.imgUser.image = UIImage(named: "userPlaceholder")
                }
                else{
                    
                    let urlStr = URL(string: imgStr)
                    cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
                }
                
                if type == "professional"{
                    
                    cell.lblName.text = dict.object(forKey: "fullName") as? String ?? ""
                    cell.lblCategory.text = "Category:\(dict.object(forKey: "category") as? String ?? "")"
                    cell.lblIDs.text = "Professional ID:\(dict.object(forKey: "professionalId") as? String ?? "")"
                    
                    cell.lblDetails.text = "Details:\(dict.object(forKey: "description") as? String ?? "No Description found")"
                    
                }
                else{
                    
                    cell.lblName.text = dict.object(forKey: "fullName") as? String ?? ""
                    cell.lblCategory.text = "Category:\(dict.object(forKey: "category") as? String ?? "")"
                    cell.lblIDs.text = "Business ID:\(dict.object(forKey: "businessId") as? String ?? "")"
                    
                    cell.lblDetails.text = "Details:\(dict.object(forKey: "description") as? String ?? "No Description found")"
                    
                }
                
                cell.selectionStyle = .none
                return cell
                
            }

        }
        else if selectedIndexTab == 1 || selectedIndexTab == 2{
            
            ////*****************
            ////write here the code for sale and rent
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForRentAndSale", for: indexPath) as! CellForRentAndSale
            
            
            cell.btnLikeDislike.tag = indexPath.row
            cell.btnLikeDislike.addTarget(self, action: #selector(self.tapSaleAndRentLikeBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action: #selector(self.tap_shareBtn(sender:)), for: UIControl.Event.touchUpInside)

            cell.btnCall.tag = indexPath.row
            cell.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnChat.tag = indexPath.row
            cell.btnChat.addTarget(self, action: #selector(self.btnChatAction(sender:)), for: UIControl.Event.touchUpInside)
            
           // cell.btnChat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)
            cell.btnDelete.isHidden = true
            
            let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            if likeStatus == "yes"{
                
                cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
            }
            else{
                
                cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
            }
            
            
            cell.lblTitle.text = dict.object(forKey: "title") as? String ?? ""
            cell.lblPropertyType.text = dict.object(forKey: "category") as? String ?? ""
            
            let plotSize = dict.object(forKey: "plotSize") as? String ?? ""
            let plotSizeUnit = dict.object(forKey: "plotSizeUnit") as? String ?? ""
            
            cell.lblPricePerMeter.text = "\(plotSize)\(plotSizeUnit)"
            
            if type == "sale"{
                
                let totalPrice = dict.object(forKey: "totalPriceSale") as? String ?? ""
                
                let currency = dict.object(forKey: "currency") as? String ?? ""
                
                cell.lblPrice.text = "\(currency) \(totalPrice)"
                
                let pricePerMeter = dict.object(forKey: "pricePerMeter") as? String ?? ""
                
                cell.lblSquareMeter.text = "\(currency) \(pricePerMeter) M2"
            }
            else{
                
                let totalPrice = dict.object(forKey: "totalPriceRent") as? String ?? ""
                
                let currency = dict.object(forKey: "currency") as? String ?? ""
                
                let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                
                cell.lblPrice.text = "\(currency) \(totalPrice) \(rentTime)"
                
                cell.lblSquareMeter.text = "     "
            }
            
            let imageArr = dict.object(forKey: "imagesFile") as? NSArray ?? []
            if imageArr.count == 0{
                
                cell.imgProperty.image = UIImage(named: "defaultProperty")
            }
            else{
                
                let dict = imageArr.object(at: 0) as? NSDictionary ?? [:]
                let imageStr = dict.object(forKey: "image") as? String ?? ""
                
                if imageStr != ""{
                    
                    let urlStr = URL(string: imageStr)
                    cell.imgProperty.setImageWith(urlStr, placeholderImage: UIImage(named: "defaultProperty"))
                }
                else{
                    
                    cell.imgProperty.image = UIImage(named: "defaultProperty")
                }
            }
            
            cell.selectionStyle = .none
            return cell
            
        }
        else{
            
            ////*****************
            ////write here the code for professional and business
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForProfessionalAndBusiness", for: indexPath) as! CellForProfessionalAndBusiness
            
            cell.btnLikeDislike.tag = indexPath.row
            cell.btnLikeDislike.addTarget(self, action: #selector(self.tapProfessionalAndBussinessLikeBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action: #selector(self.tap_shareBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnCall.tag = indexPath.row
            cell.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnChat.tag = indexPath.row
            cell.btnChat.addTarget(self, action: #selector(self.btnChatAction(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnDelete.isHidden = true
            
            cell.btnChat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)
            
            let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
            
            let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
            
            if likeStatus == "yes"{
                
                cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
            }
            else{
                
                cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
            }
            
            
            let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
            
            if imgStr == ""{
                
                cell.imgUser.image = UIImage(named: "userPlaceholder")
            }
            else{
                
                let urlStr = URL(string: imgStr)
                cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
            }
            
            
            if selectedIndexTab == 3{
                
                cell.lblName.text = dict.object(forKey: "fullName") as? String ?? ""
                cell.lblCategory.text = "Category:\(dict.object(forKey: "category") as? String ?? "")"
                cell.lblIDs.text = "Professional ID:\(dict.object(forKey: "professionalId") as? String ?? "")"
                
                cell.lblDetails.text = "Details:\(dict.object(forKey: "description") as? String ?? "No Description found")"
                
            }
            
            if selectedIndexTab == 4{
                
                cell.lblName.text = dict.object(forKey: "fullName") as? String ?? ""
                cell.lblCategory.text = "Category:\(dict.object(forKey: "category") as? String ?? "")"
                cell.lblIDs.text = "Business ID:\(dict.object(forKey: "businessId") as? String ?? "")"
                
                cell.lblDetails.text = "Details:\(dict.object(forKey: "description") as? String ?? "No Description found")"
                
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        if type == "sale" || type == "rent"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyTitleController") as! PropertyTitleController
            
            let propertyId = dict.object(forKey: "_id") as? String ?? ""
            
            let profId = dict.object(forKey: "professionalUserId") as? String ?? ""
            
            vc.propertyType = type
            vc.propertyId = propertyId
            
            vc.profUserID = profId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalNameController") as! ProfessionalNameController

            let idOfUserAsNormal = dict.object(forKey: "userId") as? String ?? ""

            if type == "professional"{

                vc.headerTitle = "Professional Name"

                vc.userType = "Professional"
            }
            else{

                vc.headerTitle = "Business Name"

                vc.userType = "Business"
            }

            vc.IdAsNormal = idOfUserAsNormal
            vc.dataDict = dict

            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
    
    @objc func btnChatAction(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            let receiverId = dict.object(forKey: "userId") as? String ?? ""
            
            let propertyId = dict.object(forKey: "_id") as? String ?? ""
            
            var headerName = ""
            
            let descTxt = dict.object(forKey: "description") as? String ?? ""
            
            let type = dict.object(forKey: "Type") as? String ?? ""
            
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
            
            vc.descriptionStr = descTxt
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            makeRootToLoginSignup()
        }
    }
    
    
    @objc func tap_shareBtn(sender:UIButton){
        
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
    
    
    @objc func callOnNumber(sender:UIButton){
        
        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let phoneNo = dict.object(forKey: "mobileNumber") as? String ?? ""
        
        let countryCode = dict.object(forKey: "countryCode") as? String ?? ""
        
        if let url = URL(string: "tel://\(countryCode)\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10, *) {
                
                UIApplication.shared.open(url)
                
            } else {
                
                UIApplication.shared.openURL(url)
            }
        }
        
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
    
    
    @objc func tapSaleAndRentLikeBtn(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let dict = propertyDataArr.object(at:sender.tag) as? NSDictionary ?? [:]
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
    
    
    @objc func tapProfessionalAndBussinessLikeBtn(sender:UIButton){
        
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
    
    
    func shareProperty(propertyTitle:String,propertyType:String){
        
       // let title = "I just used the Aqar55 App and saw the property \(propertyTitle) for \(propertyType). Highly recommend that you try it too."
        
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
    
}


extension ListController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.finalArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForUpperOption
        
        cell.lblTitle.textColor = finalArray[indexPath.row].color
        cell.lblTitle.text = finalArray[indexPath.item].text
        
        cell.bottomView.backgroundColor = finalArray[indexPath.row].bottomViewColor
        cell.bottomView.isHidden = finalArray[indexPath.row].isBottomViewHidden
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isValidForOnlySingleTime = false
        
        selectedIndexTab = indexPath.row
        
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
        
       // self.tableView.reloadData()
        
        var propertyType = ""
        
        if indexPath.row == 0{
            
            propertyType = ""
        }
        else if indexPath.row == 1{
            
            propertyType = "sale"
        }
        else if indexPath.row == 2{
            
            propertyType = "rent"
        }
        else if indexPath.row == 3{
            
            propertyType = "professional"
        }
        else if indexPath.row == 4{
            
            propertyType = "business"
        }
        
        self.apiCallForFetchPropertyListing(type: propertyType)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90.0, height: 40.0)
    }
}



//MARK:- SortController Delegate
//MARK:-
extension ListController:SortControllerDelegate{
    
    func sortedParameter(singleParamStr: String) {
        
        var propertyType = ""
        
        if self.selectedIndexTab == 0{
            
            propertyType = ""
        }
        else if  self.selectedIndexTab == 1{
            
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
        
        self.apiCallForSortData(type: propertyType, sortedType: singleParamStr)
    }
    
}


//MARK:- SortBy Alphabetically delegate
//MARK:-
extension ListController:SortAlphabeticallyDelegate{
    
    func sortedByAlpha(status: String) {
        
        var propertyType = ""
        
        if self.selectedIndexTab == 3{
            
            propertyType = "professional"
        }
        else if self.selectedIndexTab == 4{
            
            propertyType = "business"
        }
        
        self.apiCallForSortData(type: propertyType, sortedType: status)
        
    }
    
}


//MARK:- Webservices
//MARK:-
extension ListController{
    
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
                        
                        //reload Tableview here
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            if self.propertyDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView.isHidden = false
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                            
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
    
    
    
    func apiCallForSortData(type:String,sortedType:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":type,"\(sortedType)":true,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""] as [String : Any]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForSortProperty as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            if self.propertyDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView.isHidden = false
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                            
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
                            
                            if self.propertyDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView.isHidden = false
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                            
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
                        
                       // self.apiCallForFetchPropertyListing(type: propertyType)
                        
                        self.apiCallForFetchPropertyListingCommonData(type: propertyType)
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
    
    
    ////api for search by google place
    
    func apiCallForSearchByPlace(lat:String,long:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var type = ""
            
            if self.selectedIndexTab == 0{
                
                type = ""
               
            }
            else if self.selectedIndexTab == 1{
                
                type = "sale"
               
            }
            else if self.selectedIndexTab == 2{
                
                type = "rent"
               
            }
            else if self.selectedIndexTab == 3{
                
                type = "professional"
               
            }
            else if self.selectedIndexTab == 4{
                
                type = "business"
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
                            
                            self.propertyDataArr = data
                            
                            if self.propertyDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView.isHidden = false
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                            
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
    
    
    ////////
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
                            
                            if self.propertyDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView.isHidden = false
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                            
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
    
    
    ///////after like and dislike getting only common record from listing
    
    func apiCallForFetchPropertyListingCommonData(type:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":type,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForPropertyListing as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        //reload Tableview here
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            let combineDataArr = NSMutableArray()
                            
                            for i in 0..<self.propertyDataArr.count{
                                
                                let dict = self.propertyDataArr.object(at: i) as? NSDictionary ?? [:]
                                
                                let id = dict.object(forKey: "_id") as? String ?? ""
                                
                                for j in 0..<data.count{
                                    
                                    let metchedDict = data.object(at: j) as? NSDictionary ?? [:]
                                    
                                    let metchedId = metchedDict.object(forKey: "_id") as? String ?? ""
                                    
                                    if id == metchedId{
                                        
                                        combineDataArr.add(metchedDict)
                                        
                                       // break
                                    }
                                    
                                }
                                
                            }
                            
                            
                            self.propertyDataArr = combineDataArr
                            
                            if self.propertyDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView.isHidden = false
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView.isHidden = true
                            }
                            
                            self.tableView.reloadData()
                            
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


extension ListController:SearchByLocationDelegate{
    
    func searchByLocationData(lat: String, long: String, address: String) {
        
        self.apiCallForSearchByPlace(lat: lat, long: long)
    }
    
}

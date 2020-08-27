//
//  BusinessProfileController.swift
//  AQAR55
//
//  Created by lion on 04/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Foundation
import AVFoundation

class BusinessProfileController: UIViewController {

    @IBOutlet weak var imgThumbnailRef: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtFieldStateRef: UITextField!
    @IBOutlet weak var txtFieldCityRef: UITextField!
    
    @IBOutlet weak var txtFieldZipCodeRef: UITextField!
    @IBOutlet weak var txtFieldArea: UITextField!
    
    @IBOutlet weak var txtFieldWebsiteRef: UITextField!
    @IBOutlet weak var txtFieldBusinessID: UITextField!
    
    @IBOutlet weak var txtFieldEmilId: UITextField!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager : CLLocationManager = CLLocationManager()
    var latCordinate = String()
    var longCordinate = String()
    var headerTitle = ""
    var dataDict = NSMutableDictionary()
    var arrImages = NSMutableArray()
    var arrContent = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var mediaTag = Int()
    let validation:Validation = Validation.validationManager() as! Validation
    var userInfoModelItem = UserInfoDataModel()
    
    var updateUIFuncWillCalled = false
    
    var userInfoDict = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if updateUIFuncWillCalled == true{
            
            updateUI()
        }
        else{
            
            //fetch data from normal profile of user while creating business and professional profile.
            
            setDataFromNoralProfile()
        }
      
        imagePicker.delegate = self
        
        lblTitle.text = headerTitle
        
        if headerTitle == "My Professional Profile"{
            
            lblAddress.text = "Professional Address"
            
            lblPhone.text = "Professional Phone"
        }

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "IMAGEDATA_ARR")
        UserDefaults.standard.removeObject(forKey: "VIDEO_DATA")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        checkValidation()
       
    }
    
    @IBAction func btnAddLocationByMapAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationController") as! AddLocationController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tap_addImageBtn(_ sender: Any) {
        
        self.mediaTag = 1
        
        showImagePicker()
    }
    
    
    @IBAction func tap_addVideoBtn(_ sender: Any) {
        
        self.mediaTag = 2
        
        showVideoPicker()
    }
    
    
    
    @IBAction func btnLocationsTapped(_ sender: UIButton) {
        
        print("show aleart...")
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please pick address detail from google map", controller: self)
    }
    
    @objc func buttonDelClicked(sender:UIButton){
        
        self.arrImages.removeObject(at: sender.tag)
        collectionView.reloadData()
    }
}


extension BusinessProfileController:SavedAddressDelegate{
    
    func savedAddress(country: String, state: String, city: String, locality: String, zipCode: String, address: String, lat:String, long:String) {
        
        self.txtFieldStateRef.text = state
        self.txtFieldCityRef.text = city
        self.txtFieldZipCodeRef.text = zipCode
        self.txtFieldArea.text = locality
        self.latCordinate = lat
        self.longCordinate = long
        print(country)
        print(address)
        configureMap()
    }
    
}



extension BusinessProfileController:GMSMapViewDelegate{
    
    func configureMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(latCordinate) ?? 0.0, longitude: Double(longCordinate) ?? 0.0, zoom: 12.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        
        self.mapView.clear()
        let marker = GMSMarker()
        marker.icon = UIImage(named:"map_loc")
        marker.position = CLLocationCoordinate2D(latitude: Double(latCordinate) ?? 0.0, longitude: Double(longCordinate) ?? 0.0)
        marker.isDraggable = true
        marker.map = self.mapView
    }

}



extension BusinessProfileController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: "ManageProfileCollectionViewCellAndXib", bundle: nil), forCellWithReuseIdentifier: "ManageProfileCollectionViewCellAndXib")
        let cell : ManageProfileCollectionViewCellAndXib = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageProfileCollectionViewCellAndXib", for: indexPath) as! ManageProfileCollectionViewCellAndXib
         cell.property_img.image = UIImage(data: arrImages.object(at: indexPath.item) as! Data)
        cell.btnDeleteRef.tag = indexPath.row
        cell.btnDeleteRef.addTarget(self, action: #selector(buttonDelClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 78, height: 78)
    }
    
}

//MARK:- Custom Method
//MARK:-
extension BusinessProfileController{
    
    func setDataFromNoralProfile(){
        
        if self.userInfoDict.count != 0 &&  headerTitle == "My Professional Profile"{
            
            self.txtFieldBusinessID.text = userInfoDict.object(forKey: "mobileNumber") as? String ?? ""
            self.txtFieldWebsiteRef.text = userInfoDict.object(forKey: "website") as? String ?? ""
            
            self.txtFieldEmilId.text = userInfoDict.object(forKey: "email") as? String ?? ""
        }
        
    }

    
    func camera(){
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImagePicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }else {
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }
        
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        
        if let urlString = urlString {
            
            if let url = NSURL(string: urlString) {
                
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func validateUrl (urlString: NSString) -> Bool {
        
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFieldStateRef.text == ""{
            
            mess = "Please select your state"
        }
//        else if txtFieldCityRef.text == ""{
//
//            mess = "Please select your city"
//        }
//        else if txtFieldZipCodeRef.text == ""{
//
//            mess = "Please select your zip code"
//        }
//        else if txtFieldArea.text == ""{
//
//            mess = "Please select your area"
//        }
        else if txtFieldBusinessID.text == ""{
            
            mess = "Please enter your phone number"
        }
        else if txtFieldEmilId.text == ""{
            
            mess = "Please enter your email"
        }
        else if !validation.validateEmail(txtFieldEmilId.text!){
            
            mess = "Please enter valid email"
        }
//        else if txtFieldWebsiteRef.text != "" && !verifyUrl(urlString: txtFieldWebsiteRef.text!){
//
//            mess = "Please enter valid website url"
//        }
        else if txtFieldWebsiteRef.text != "" && !validateUrl(urlString: txtFieldWebsiteRef.text! as NSString){
            
            mess = "Please enter valid website url"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialHandlesController") as! SocialHandlesController
           // UserDefaults.standard.set(arrImages, forKey: "IMAGEDATA_ARR")
            
            vc.arrOfAdditionalImage = self.arrImages
            
            vc.headerTitle = headerTitle
            vc.userInfoModelItem = userInfoModelItem
            
            vc.dataDict = dataSaveForProceed(state:txtFieldStateRef.text!,city:txtFieldCityRef.text!,zipcode:txtFieldZipCodeRef.text!,area:txtFieldArea.text!,mobileNumber:txtFieldBusinessID.text!,website:txtFieldWebsiteRef.text!,email:txtFieldEmilId.text!)
            
            vc.updateUIFuncWillCalled = self.updateUIFuncWillCalled
            
            vc.userInfoDict = self.userInfoDict
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    func dataSaveForProceed(state:String,city:String,zipcode:String,area:String,mobileNumber:String,website:String,email:String)->NSMutableDictionary{

        
        dataDict.addEntries(from: ["state":state])
        dataDict.addEntries(from: ["city":city])
        dataDict.addEntries(from: ["zipcode":zipcode])
        dataDict.addEntries(from: ["area":area])
        dataDict.addEntries(from: ["mobileNumber":mobileNumber])
        dataDict.addEntries(from: ["website":website])
        dataDict.addEntries(from: ["email":email])
        dataDict.addEntries(from: ["lat":self.latCordinate])
        dataDict.addEntries(from: ["long":self.longCordinate])
        return dataDict
    }
    
    func updateUI(){
        
        self.txtFieldStateRef.text = userInfoModelItem.state
        self.txtFieldCityRef.text = userInfoModelItem.city
        self.txtFieldZipCodeRef.text = userInfoModelItem.zipcode
        self.txtFieldArea.text = userInfoModelItem.area
        self.latCordinate = userInfoModelItem.lat
        self.longCordinate = userInfoModelItem.long
        self.txtFieldBusinessID.text = userInfoModelItem.mobileNumber
        self.txtFieldWebsiteRef.text = userInfoModelItem.website
        self.txtFieldEmilId.text = userInfoModelItem.email
        
        
       // DispatchQueue.global(qos: .background).async {
            
            let imageArr = self.userInfoModelItem.imagesFile
            for i in 0..<imageArr.count{
                
                let dict = imageArr.object(at: i) as? NSDictionary ?? [:]
                
                let imageStr = dict.object(forKey: "image") as? String ?? ""
                
                do {
                    
                    let imageData = try Data(contentsOf: URL(string: imageStr) as! URL)
                    self.arrImages.add(imageData)
                    self.collectionView.reloadData()
                    
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
            
       // }
        
        DispatchQueue.global(qos: .background).async {
            
            let videoDataArr = self.userInfoModelItem.videosFile
    
            print(videoDataArr)
            
            if videoDataArr.count != 0{
                
                let dict = videoDataArr.object(at: 0) as? NSDictionary ?? [:]
                
                let videoStr = dict.object(forKey: "video") as? String ?? ""
                
                if videoStr != ""{
                    
                    do {
                        
                        let imageData = try Data(contentsOf: URL(string: videoStr) as! URL)
                        
                        UserDefaults.standard.set(imageData, forKey: "VIDEO_DATA")
                        
                        let urlStr = URL(string: videoStr)
                        
                        if self.getThumbnailImage(forUrl: urlStr!) != nil{
                            
                            let image = self.getThumbnailImage(forUrl: urlStr!) as! UIImage
                            self.imgThumbnailRef.image = image
                            
                        }
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                }
              
            }
            
        }
        
        configureMap()
    }
    
    
}

//MARK:- UiImage Picker Delegate
//MARK:-
extension BusinessProfileController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if mediaTag == 1{
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageData = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
        self.arrImages.add(imageData)
        self.collectionView.reloadData()
        }else{
            
            guard let videoURL = info[.mediaURL] as? NSURL else {
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Video file can not be picked", controller: self)
                
                dismiss(animated: true, completion: nil)
                
                fatalError("Expected a dictionary containing an video file, but was provided the following: \(info)")
                
            }
            
            do {
                
                let imageData = try Data(contentsOf: videoURL as URL)
                UserDefaults.standard.set(imageData, forKey: "VIDEO_DATA")
               // self.videoDataArr.add(imageData)
                
            } catch {
                
                print("Unable to load data: \(error)")
            }
            
            if getThumbnailImage(forUrl: videoURL as URL) != nil {
                
                print("success")
                let image = getThumbnailImage(forUrl: videoURL as URL) as! UIImage
                self.imgThumbnailRef.image = image
                
            }
            else{
                print("Thumbnail nahi mila...")
               
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }

}

//MARK:- Custom Method
//MARK:-
extension BusinessProfileController{
    
    func videoLibrary() {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showVideoPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            
            self.videoLibrary()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}


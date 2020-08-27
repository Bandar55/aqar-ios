//
//  AddLocationByMapController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class AddLocationByMapController: UIViewController {

    
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblState: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblAreaLocality: UILabel!
    
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtApartmentNo: UITextField!
    
    @IBOutlet weak var txtBuildingNo: UITextField!
    
    @IBOutlet weak var txtAreaLocality: UITextField!
    
    
    var latCordinate = ""
    var longCordinate = ""
    
    let connection = webservices()
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.controllerPurpuse == "Edit"{
            
            self.setDataForEditItem()
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnAddLocationByMapAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationController") as! AddLocationController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyPopupController") as! PostPropertyPopupController
//        vc.objAddLocationByMap = self
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
        checkValidation()
        
    }
    
    
    @IBAction func tap_countryBtn(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select all location by map", controller: self)
    }
    
    @IBAction func tap_stateBtn(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select all location by map", controller: self)
    }
    
    @IBAction func tap_cityBtn(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select all location by map", controller: self)
    }
    
    
    @IBAction func tap_localityBtn(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select all location by map", controller: self)
    }
    
    @IBAction func tap_addressBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationController") as! AddLocationController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension AddLocationByMapController:SavedAddressDelegate{
   
    func savedAddress(country: String, state: String, city: String, locality: String, zipCode: String, address: String, lat:String, long:String) {
        
        self.lblCountry.text = country
        self.lblState.text = state
        self.lblCity.text = city
        //self.lblAreaLocality.text = locality
        self.txtZipCode.text = zipCode
        
        self.txtAddress.text = address
        
        self.txtAreaLocality.text = locality
        
        self.latCordinate = lat
        self.longCordinate = long
        
    }
 
}



extension AddLocationByMapController{
    
    func checkValidation(){
        
        var mess = ""
        
        if self.txtAddress.text == ""{
            
            mess = "Please enter address"
        }
        else if txtZipCode.text == ""{
            
            mess = "Please enter zip code"
        }
        else if txtAreaLocality.text == ""{
            
            mess = "Please enter Area/Locality"
        }
//        else if txtApartmentNo.text == ""{
//
//            mess = "Please enter apartment no."
//        }
//        else if txtBuildingNo.text == ""{
//
//            mess = "Please enter building no."
//        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            /////fetching data for all controller to post property
            
            retrieveData()
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func retrieveData(){
        
        //firstPageData
        
        let firstPageDataDict = UserDefaults.standard.value(forKey: "PropertyInitialDetail") as! NSMutableDictionary
        
        let title = firstPageDataDict.value(forKey: "PropertyTitle") as? String ?? ""
        let category = firstPageDataDict.value(forKey: "PropertyCategory") as? String ?? ""
        let purpuse = firstPageDataDict.value(forKey: "Purpuse") as? String ?? ""
        let availavleFor = firstPageDataDict.value(forKey: "AvailableFor") as? String ?? ""
        let noOfBathroom = firstPageDataDict.value(forKey: "NoOfBathrooms") as? String ?? ""
        let noOfBedroom = firstPageDataDict.value(forKey: "NoOfBedrooms") as? String ?? ""
        let noOfKitchen = firstPageDataDict.value(forKey: "NoOfKitchens") as? String ?? ""
        let floor = firstPageDataDict.value(forKey: "FloorType") as? String ?? ""
        
        let propertyStatus = firstPageDataDict.value(forKey: "PropertyStatus") as? String ?? ""
        
        //secondPageData
        
        let secondPageData = UserDefaults.standard.value(forKey: "PropertySecondPageData") as! NSMutableDictionary
        
        let builtSize = secondPageData.value(forKey: "BuiltSize") as? String ?? ""
        let builtSizeUnit = secondPageData.value(forKey: "BuiltUnit") as? String ?? ""
        let plotSize = secondPageData.value(forKey: "PlotSize") as? String ?? ""
        let plotSizeUnit = secondPageData.value(forKey: "PlotSizeUnit") as? String ?? ""
        let year = secondPageData.value(forKey: "BuiltYear") as? String ?? ""
        let streetView = secondPageData.value(forKey: "StreetView") as? String ?? ""
        let streetWidth = secondPageData.value(forKey: "StreetWidth") as? String ?? ""
        let streetWidthUnit = secondPageData.value(forKey: "StreetWidthUnit") as? String ?? ""
        let description = secondPageData.value(forKey: "PropertyDescription") as? String ?? ""
        let noOfBuilding = secondPageData.value(forKey: "NoOfBuilding") as? String ?? ""
        let noOfShowroom = secondPageData.value(forKey: "NoOfShowroom") as? String ?? ""
        
        let revenue = secondPageData.value(forKey: "Revenue") as? String ?? ""
        
        let balconyStatus = secondPageData.value(forKey: "BalconySwitch") as? String ?? ""
        let gardenStatus = secondPageData.value(forKey: "GardenSwitch") as? String ?? ""
        let parkingStatus = secondPageData.value(forKey: "ParkingSwitch") as? String ?? ""
        let kitchenStatus = secondPageData.value(forKey: "KitchenSwitch") as? String ?? ""
        
        let liftStatus = secondPageData.value(forKey: "LiftSwitch") as? String ?? ""
        let duplexStatus = secondPageData.value(forKey: "DuplexSwitch") as? String ?? ""
        let airConditioningStatus = secondPageData.value(forKey: "AirConditioningSwitch") as? String ?? ""
        let storeStatus = secondPageData.value(forKey: "StoreSwitch") as? String ?? ""
        let furnishingStatus = secondPageData.value(forKey: "FurnishingSwitch") as? String ?? ""
        
        let measurementLength = secondPageData.value(forKey: "MeasurementLength") as? String ?? ""
        let measurementWidth = secondPageData.value(forKey: "MeasurementWidth") as? String ?? ""
        let measurementLengthUnit = secondPageData.value(forKey: "MeasurementLengthUnit") as? String ?? ""
        let measurementWidthUnit = secondPageData.value(forKey: "MeasurementWidthUnit") as? String ?? ""
        
        
        //thirdPageData
        
        let specificationData = UserDefaults.standard.value(forKey: "SpecificationPageData") as! NSMutableDictionary
        
        let indoorStr = specificationData.value(forKey: "IndoorStr") as? String ?? ""
        let outdoorStr = specificationData.value(forKey: "OutdoorStr") as? String ?? ""
        let furnishingStr = specificationData.value(forKey: "FurnishingStr") as? String ?? ""
        let parkingStr = specificationData.value(forKey: "ParkingStr") as? String ?? ""
        let viewsStr = specificationData.value(forKey: "ViewsStr") as? String ?? ""
        
        
        ////getting images
        
        let imagesDict = UserDefaults.standard.value(forKey: "PropertyImages") as! NSMutableDictionary
        
        let imagesArr = (imagesDict.value(forKey: "PropertyImageArr") as! NSArray).mutableCopy() as! NSMutableArray
      //  let imagesCaptionArr = imagesDict.value(forKey: "PropertyImagesCaptionArr") as! NSMutableArray
        
        
        ////getting videos
        
        let videoDict = UserDefaults.standard.value(forKey: "PropertyVideo") as! NSMutableDictionary
        
        let videoArr = (videoDict.value(forKey: "PropertyVideoArr") as! NSArray).mutableCopy() as! NSMutableArray
     //   let videoCaptionArr = videoDict.value(forKey: "PropertyVideoCaptionArr") as! NSMutableArray
        
        
        if UserDefaults.standard.value(forKey: "PropertyType") as? String ?? "" == "Sale"{
            
            //gettingPriceForSale
            
            let priceDict = UserDefaults.standard.value(forKey: "PriceForSale") as! NSMutableDictionary
            
            let sizeForPrice = priceDict.value(forKey: "SizeForPrice") as? String ?? ""
            let pricePerMeter = priceDict.value(forKey: "PricePerMeter") as? String ?? ""
            let totalPrice = priceDict.value(forKey: "TotalPrice") as? String ?? ""
            
            
            ////setting param

            
            let param = ["title":title,"type":"sale","category":category,"purpose":purpuse,"available":availavleFor,"bedrooms":noOfBedroom,"bathrooms":noOfBathroom,"kitchens":noOfKitchen,"floor":floor,"builtSize":builtSize,"builtSizeUnit":builtSizeUnit,"plotSize":plotSize,"plotSizeUnit":plotSizeUnit,"yearBuilt":year,"streetView":streetView,"streetWidth":streetWidth,"streetWidthUnit":streetWidthUnit,"description":description,"extrabuildingNo":noOfBuilding,"extrashowroomNo":noOfShowroom,"revenue":revenue,"sizem2":sizeForPrice,"pricePerMeter":pricePerMeter,"totalPriceSale":totalPrice,"indoor":indoorStr,"outdoor":outdoorStr,"furnish":furnishingStr,"parkingOption":parkingStr,"views":viewsStr,"country":lblCountry.text!,"state":lblState.text!,"city":lblCity.text!,"area":txtAreaLocality.text!,"zipcode":txtZipCode.text!,"address":txtAddress.text!,"apartmentNo":txtApartmentNo.text!,"buildingNo":txtBuildingNo.text!,"lat":latCordinate,"long":longCordinate,"balcony":balconyStatus,"garden":gardenStatus,"parking":parkingStatus,"modularKitchen":kitchenStatus,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","store":storeStatus,"lift":liftStatus,"duplex":duplexStatus,"furnished":furnishingStatus,"aircondition":airConditioningStatus,"length":measurementLength,"lengthUnit":measurementLengthUnit,"width":measurementWidth,"widthUnit":measurementWidthUnit,"status":propertyStatus] as [String : Any]
            
            
            if self.controllerPurpuse == "Edit"{
                
                let propertyId = editItemDict.object(forKey: "_id") as? String ?? ""
                
                  let param1 = ["propertyId":propertyId,"title":title,"type":"sale","category":category,"purpose":purpuse,"available":availavleFor,"bedrooms":noOfBedroom,"bathrooms":noOfBathroom,"kitchens":noOfKitchen,"floor":floor,"builtSize":builtSize,"builtSizeUnit":builtSizeUnit,"plotSize":plotSize,"plotSizeUnit":plotSizeUnit,"yearBuilt":year,"streetView":streetView,"streetWidth":streetWidth,"streetWidthUnit":streetWidthUnit,"description":description,"extrabuildingNo":noOfBuilding,"extrashowroomNo":noOfShowroom,"revenue":revenue,"sizem2":sizeForPrice,"pricePerMeter":pricePerMeter,"totalPriceSale":totalPrice,"indoor":indoorStr,"outdoor":outdoorStr,"furnish":furnishingStr,"parkingOption":parkingStr,"views":viewsStr,"country":lblCountry.text!,"state":lblState.text!,"city":lblCity.text!,"area":txtAreaLocality.text!,"zipcode":txtZipCode.text!,"address":txtAddress.text!,"apartmentNo":txtApartmentNo.text!,"buildingNo":txtBuildingNo.text!,"lat":latCordinate,"long":longCordinate,"balcony":balconyStatus,"garden":gardenStatus,"parking":parkingStatus,"modularKitchen":kitchenStatus,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","store":storeStatus,"lift":liftStatus,"duplex":duplexStatus,"furnished":furnishingStatus,"aircondition":airConditioningStatus,"length":measurementLength,"lengthUnit":measurementLengthUnit,"width":measurementWidth,"widthUnit":measurementWidthUnit,"status":propertyStatus] as [String : Any]
                
                 self.apiCallForEditProperty(param: param1, imageDataArr: imagesArr, videoDataArr: videoArr)
            }
            else{
                
                self.apiCallForPostProperty(param: param, imageDataArr: imagesArr, videoDataArr: videoArr)
            }
            
          
        }
        else{
            
            //gettingPriceForRent
            
            let priceDict = UserDefaults.standard.value(forKey: "PriceForRent") as! NSMutableDictionary
            
            let pricePlanTime = priceDict.value(forKey: "PaymentPlanTime") as? String ?? ""
            let priceForTime = priceDict.value(forKey: "PriceForTime") as? String ?? ""
            
            let defaultDailyPrice = priceDict.value(forKey: "DefaultDailyPrice") as? String ?? ""
            let defaultWeeklyPrice = priceDict.value(forKey: "DefaultWeeklyPrice") as? String ?? ""
            let defaultMonthlyPrice = priceDict.value(forKey: "DefaultMonthlyPrice") as? String ?? ""
            let defaultYearlyPrice = priceDict.value(forKey: "DefalutYearlyPrice") as? String ?? ""
            
            let param = ["title":title,"type":"rent","category":category,"purpose":purpuse,"available":availavleFor,"bedrooms":noOfBedroom,"bathrooms":noOfBathroom,"kitchens":noOfKitchen,"floor":floor,"builtSize":builtSize,"builtSizeUnit":builtSizeUnit,"plotSize":plotSize,"plotSizeUnit":plotSizeUnit,"yearBuilt":year,"streetView":streetView,"streetWidth":streetWidth,"streetWidthUnit":streetWidthUnit,"description":description,"extrabuildingNo":noOfBuilding,"extrashowroomNo":noOfShowroom,"revenue":revenue,"rentTime":pricePlanTime,"totalPriceRent":priceForTime,"indoor":indoorStr,"outdoor":outdoorStr,"furnish":furnishingStr,"parkingOption":parkingStr,"views":viewsStr,"country":lblCountry.text!,"state":lblState.text!,"city":lblCity.text!,"area":txtAreaLocality.text!,"zipcode":txtZipCode.text!,"address":txtAddress.text!,"apartmentNo":txtApartmentNo.text!,"buildingNo":txtBuildingNo.text!,"lat":latCordinate,"long":longCordinate,"balcony":balconyStatus,"garden":gardenStatus,"parking":parkingStatus,"modularKitchen":kitchenStatus,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","store":storeStatus,"lift":liftStatus,"duplex":duplexStatus,"furnished":furnishingStatus,"aircondition":airConditioningStatus,"length":measurementLength,"lengthUnit":measurementLengthUnit,"width":measurementWidth,"widthUnit":measurementWidthUnit,"defaultDailyPrice":defaultDailyPrice,"defaultWeeklyPrice":defaultWeeklyPrice,"defaultMonthlyPrice":defaultMonthlyPrice,"defaultyearlyPrice":defaultYearlyPrice,"status":propertyStatus] as [String : Any]
            
            
            if self.controllerPurpuse == "Edit"{
               
                let propertyId = editItemDict.object(forKey: "_id") as? String ?? ""
                
                let param1 = ["propertyId":propertyId,"title":title,"type":"rent","category":category,"purpose":purpuse,"available":availavleFor,"bedrooms":noOfBedroom,"bathrooms":noOfBathroom,"kitchens":noOfKitchen,"floor":floor,"builtSize":builtSize,"builtSizeUnit":builtSizeUnit,"plotSize":plotSize,"plotSizeUnit":plotSizeUnit,"yearBuilt":year,"streetView":streetView,"streetWidth":streetWidth,"streetWidthUnit":streetWidthUnit,"description":description,"extrabuildingNo":noOfBuilding,"extrashowroomNo":noOfShowroom,"revenue":revenue,"rentTime":pricePlanTime,"totalPriceRent":priceForTime,"indoor":indoorStr,"outdoor":outdoorStr,"furnish":furnishingStr,"parkingOption":parkingStr,"views":viewsStr,"country":lblCountry.text!,"state":lblState.text!,"city":lblCity.text!,"area":txtAreaLocality.text!,"zipcode":txtZipCode.text!,"address":txtAddress.text!,"apartmentNo":txtApartmentNo.text!,"buildingNo":txtBuildingNo.text!,"lat":latCordinate,"long":longCordinate,"balcony":balconyStatus,"garden":gardenStatus,"parking":parkingStatus,"modularKitchen":kitchenStatus,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","store":storeStatus,"lift":liftStatus,"duplex":duplexStatus,"furnished":furnishingStatus,"aircondition":airConditioningStatus,"length":measurementLength,"lengthUnit":measurementLengthUnit,"width":measurementWidth,"widthUnit":measurementWidthUnit,"defaultDailyPrice":defaultDailyPrice,"defaultWeeklyPrice":defaultWeeklyPrice,"defaultMonthlyPrice":defaultMonthlyPrice,"defaultyearlyPrice":defaultYearlyPrice,"status":propertyStatus] as [String : Any]
                
                
                self.apiCallForEditProperty(param: param1, imageDataArr: imagesArr, videoDataArr: videoArr)
            }
            else{
                
                self.apiCallForPostProperty(param: param, imageDataArr: imagesArr, videoDataArr: videoArr)
            }
          
            
        }
        
    }
    
}


extension AddLocationByMapController{
    
    func apiCallForPostProperty(param:[String:Any],imageDataArr:NSMutableArray,videoDataArr:NSMutableArray){
        
        print(param)
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithMultipleArray(imageDataArr, imageParam: "imagesFile", filetype: "image/jpeg", videoData: videoDataArr, videoParam: "videosFile", videoFileType: "video/mp4", getUrlString: App.URLs.apiCallForPostProperty as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyPopupController") as! PostPropertyPopupController
                        vc.objAddLocationByMap = self
                        self.navigationController?.present(vc, animated: true, completion: nil)
                        
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
                    
                     CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    
    /////edit Property
    
    func apiCallForEditProperty(param:[String:Any],imageDataArr:NSMutableArray,videoDataArr:NSMutableArray){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithMultipleArray(imageDataArr, imageParam: "imagesFile", filetype: "image/jpeg", videoData: videoDataArr, videoParam: "videosFile", videoFileType: "video/mp4", getUrlString: App.URLs.apiCallForEditProperty as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyPopupController") as! PostPropertyPopupController
                        vc.objAddLocationByMap = self
                        self.navigationController?.present(vc, animated: true, completion: nil)
                        
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}



extension AddLocationByMapController{
    
    func setDataForEditItem(){
        
        self.lblCountry.text = editItemDict.object(forKey: "country") as? String ?? "Country"
        
        self.lblState.text = editItemDict.object(forKey: "state") as? String ?? "State"
        self.lblCity.text = editItemDict.object(forKey: "city") as? String ?? "City"
        
        if self.lblState.text == ""{
            
            self.lblState.text = "State"
        }
        
        if self.lblCity.text == ""{
            
            self.lblCity.text = "City"
        }
        
        if self.lblCountry.text == ""{
            
            self.lblCountry.text = "Country"
        }
        
//        self.lblAreaLocality.text = editItemDict.object(forKey: "area") as? String ?? ""
//
//        if self.lblAreaLocality.text == ""{
//
//            self.lblAreaLocality.text = "Area/Locality"
//        }
        
        self.txtAreaLocality.text = editItemDict.object(forKey: "area") as? String ?? ""
        
        self.txtZipCode.text = editItemDict.object(forKey: "zipcode") as? String ?? ""
        
        self.txtAddress.text = editItemDict.object(forKey: "address") as? String ?? ""
        
        self.txtApartmentNo.text = editItemDict.object(forKey: "apartmentNo") as? String ?? ""
        
        self.txtBuildingNo.text = editItemDict.object(forKey: "buildingNo") as? String ?? ""
        
        self.latCordinate = editItemDict.object(forKey: "lat") as? String ?? ""
        self.longCordinate = editItemDict.object(forKey: "long") as? String ?? ""
        
    }
}

//
//  AddLocationController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


protocol SavedAddressDelegate{
    
    func savedAddress(country:String,state:String,city:String,locality:String,zipCode:String,address:String,lat:String,long:String)
}


class AddLocationController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    var locationManager : CLLocationManager = CLLocationManager()
    var strAddress = ""
    var AddressLat:Double = 0
    var AddressLong:Double = 0
    var gmsPlace:GMSPlace?
    var arrPlaces = NSMutableArray(capacity: 100)
    var arrPlacesIDs = NSMutableArray(capacity: 100)
    
    var delegate:SavedAddressDelegate?
    
    var country = ""
    var state = ""
    var city = ""
    var locality = ""
    var zipCode = ""
    var addressStr = ""
    
    var iscomingFirstTime = true
    
    var myLocationBackupLat = 0.0
    var myLocationBackupLong = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveLocationAction(_ sender: Any) {
        
        if country == "" || strAddress == ""{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please enable your location access in settings. Without enabled the location access Location can not be picked", controller: self)
        }
        else{
            
            self.delegate?.savedAddress(country: country, state: state, city: city, locality: locality, zipCode: zipCode, address: self.strAddress, lat: "\(AddressLat)", long: "\(AddressLong)")
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    
    @IBAction func tap_sateliteBtn(_ sender: Any) {
        
        mapView.mapType = .satellite
    }
    
    @IBAction func tap_normalMapBtn(_ sender: Any) {
        
        mapView.mapType = .normal
        
        if myLocationBackupLong != 0.0 && myLocationBackupLat != 0.0{
            
            let camera = GMSCameraPosition.camera(withLatitude: myLocationBackupLat, longitude: myLocationBackupLong, zoom: 12.0)
            mapView.camera = camera
        }
    }
    
}


extension AddLocationController:GMSMapViewDelegate{
    
    func configureMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 17.0)
        mapView.camera = camera
        locationManager.delegate = self
        mapView.isMyLocationEnabled = true
        
    }
    
    
    func dropMapPin(){
        
        self.mapView.clear()
        let marker = GMSMarker()
        marker.icon = UIImage(named:"map_loc")
        marker.position = CLLocationCoordinate2D(latitude: Double(AddressLat), longitude: Double(AddressLong))
        
        marker.isDraggable = true
        
        marker.map = self.mapView
    }
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.mapView.clear()
        
        print("marker dragged to location: \(marker.position.latitude),\(marker.position.longitude)")
        
        self.AddressLat = marker.position.latitude
        self.AddressLong = marker.position.longitude
      
        self.reverseGeocodeCoordinate(inLat: AddressLat, inLong: AddressLong)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if iscomingFirstTime == true{
            
            iscomingFirstTime = false
        }
        else{
          
            self.AddressLat = position.target.latitude
            self.AddressLong = position.target.longitude
                
            similarReverseGeocodeCoordinate(inLat: position.target.latitude, inLong: position.target.longitude)
            
        }
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        print("Begin Dragging")
    }
    
    
    func reverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                print(lines)
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    
                    self.lblAddress.text = self.strAddress
                    
                    print(self.strAddress)
                    self.configureMap()
                    
                  //  self.dropMapPin()
                    
                    print(lines?.country ?? "")
                    print(lines?.postalCode ?? "")
                    print(lines?.administrativeArea ?? "")
                    print(lines?.locality ?? "")
                    print(lines?.subLocality ?? "")
                    
                    self.country = lines?.country ?? ""
                    self.state = lines?.administrativeArea ?? ""
                    self.city = lines?.locality ?? ""
                    self.zipCode = lines?.postalCode ?? ""
                    self.locality = lines?.subLocality ?? ""
                    
                }
            }
        }
    }
    
    
    
    func similarReverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                print(lines)
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    
                    self.lblAddress.text = self.strAddress
                    
                    print(self.strAddress)
                    
                    print(lines?.country ?? "")
                    print(lines?.postalCode ?? "")
                    print(lines?.administrativeArea ?? "")
                    print(lines?.locality ?? "")
                    print(lines?.subLocality ?? "")
                    
                    self.country = lines?.country ?? ""
                    self.state = lines?.administrativeArea ?? ""
                    self.city = lines?.locality ?? ""
                    self.zipCode = lines?.postalCode ?? ""
                    self.locality = lines?.subLocality ?? ""
                    
                }
            }
        }
    }
    
    
    
    func makeAddressString(inArr:[String]) -> String {
        
        var fVal:String = ""
        for val in inArr {
            
            fVal =  fVal + val + " "
            
        }
        return fVal
        
    }
    
}


extension AddLocationController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            let lat:Double = currentLocation.coordinate.latitude
            let long:Double = currentLocation.coordinate.longitude
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.myLocationBackupLat = currentLocation.coordinate.latitude
            self.myLocationBackupLong = currentLocation.coordinate.longitude
            
            self.reverseGeocodeCoordinate(inLat: lat, inLong: long)
            
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
            self.mapView.isMyLocationEnabled = true
            
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                self.locationManager.headingFilter = 100
            }
            
        case .denied, .notDetermined, .restricted:
            print("Location Denied/NotDetermined/Restricted")
            self.mapView.isMyLocationEnabled = false
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



extension AddLocationController:GMSAutocompleteViewControllerDelegate{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress as Any)
        print("Place attributions: ", place.attributions as Any)
        print("address coardinate",place.coordinate)
        
        gmsPlace = place
        
        guard place.formattedAddress != nil else {
            return
        }
    
        self.strAddress = place.formattedAddress!
        
        self.lblAddress.text = self.strAddress
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithError error: NSError!) {
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        
    }
    
    func geoCode(str1:String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(str1, completionHandler: {(placemarks, error) -> Void in
            
            if((error) != nil){
                print("Error", error!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.AddressLat = coordinates.latitude
                self.AddressLong = coordinates.longitude
                
                print(self.AddressLat)
                print(self.AddressLong)
                
                // self.configureMap()
                
                let camera = GMSCameraPosition.camera(withLatitude: self.AddressLat, longitude: self.AddressLong, zoom: 12.0)
                self.mapView.camera = camera
                
               // self.dropMapPin()
                
            }
        })
    }
}

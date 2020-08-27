//
//  SearchLocationVC.swift
//  Aqar55
//
//  Created by Dacall soft on 22/05/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


protocol SearchByLocationDelegate {
    
    func searchByLocationData(lat:String,long:String,address:String)
}


class SearchLocationVC: UIViewController {

    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var searchHolderView: UIView!
    
    @IBOutlet weak var tableview: UITableView!
 
    
    var locationManager : CLLocationManager = CLLocationManager()
    var strAddress = ""
    var AddressLat:Double = 0
    var AddressLong:Double = 0
    var gmsPlace:GMSPlace?
    var arrPlaces = NSMutableArray(capacity: 100)
    var arrPlacesIDs = NSMutableArray(capacity: 100)
    var addressStr = ""
    
    var controllerPurpuse = ""
    
    var delegate:SearchByLocationDelegate?
    
    var didNotPickAnything = true
    var selectedViaTable = false
    var selectedViaDrag = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchbar.backgroundImage = UIImage()
        searchHolderView.layer.cornerRadius = 22.5
        tableview.isHidden = true
        self.searchbar.delegate = self
        
        self.mapview.delegate = self
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "PreventViewWillAppear")
        UserDefaults.standard.set(false, forKey: "PreventList")
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func tap_searchBtn(_ sender: Any) {
        
        if didNotPickAnything == true && selectedViaTable == false && selectedViaDrag == false{
            
            self.popControllerWithDelegate()
            
            print("Picked Via Location")
            
        }
        else if selectedViaTable == true{
            
            self.popControllerWithDelegate()
            
            print("Picked Via Tableview")
            
        }
        else if selectedViaDrag == true{
            
            self.popControllerWithDelegate()
            
            print("Picked Via Drag")
            
        }
        else{
            
            if searchbar.text == ""{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select your address.", controller: self)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the valid address via suggestion address or drop the pin anywhere on map.", controller: self)
            }
        }
       
    }
    
    
    func popControllerWithDelegate(){
        
        if self.controllerPurpuse == "List"{
            
            UserDefaults.standard.set(true, forKey: "PreventList")
        }
        else{
            
            UserDefaults.standard.set(true, forKey: "PreventViewWillAppear")
        }
        
        self.delegate?.searchByLocationData(lat: "\(AddressLat)", long: "\(AddressLong)", address: addressStr)
        self.navigationController?.popViewController(animated: true)
        
    }

}


extension SearchLocationVC:GMSMapViewDelegate{
    
    func configureMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 12.0)
        mapview.camera = camera
        locationManager.delegate = self
        mapview.isMyLocationEnabled = true
        
    }
    
    
    func dropMapPin(){
        
        self.mapview.clear()
        let marker = GMSMarker()
        marker.icon = UIImage(named:"map_loc")
        marker.position = CLLocationCoordinate2D(latitude: Double(AddressLat), longitude: Double(AddressLong))
        
        marker.isDraggable = true
        
        marker.map = self.mapview
    }
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.mapview.clear()
        
        print("marker dragged to location: \(marker.position.latitude),\(marker.position.longitude)")
        
        self.AddressLat = marker.position.latitude
        self.AddressLong = marker.position.longitude
        
        selectedViaDrag = true
        selectedViaTable = false
        
        self.reverseGeocodeCoordinate(inLat: AddressLat, inLong: AddressLong)
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
                    
                    self.searchbar.text = self.strAddress
                    
                    print(self.strAddress)
                    self.configureMap()
                    
                    self.dropMapPin()
                    
                    print(lines?.country ?? "")
                    print(lines?.postalCode ?? "")
                    print(lines?.administrativeArea ?? "")
                    print(lines?.locality ?? "")
                    print(lines?.subLocality ?? "")
                    
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



extension SearchLocationVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            let lat:Double = currentLocation.coordinate.latitude
            let long:Double = currentLocation.coordinate.longitude
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
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
            self.mapview.isMyLocationEnabled = true
            
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                self.locationManager.headingFilter = 100
            }
            
        case .denied, .notDetermined, .restricted:
            print("Location Denied/NotDetermined/Restricted")
            self.mapview.isMyLocationEnabled = false
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



extension SearchLocationVC:GMSAutocompleteViewControllerDelegate{
    
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
                self.mapview.camera = camera
                
                self.dropMapPin()
                
            }
        })
    }
}



//MARK:- SearchBar delegate
//MARK:-
extension SearchLocationVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.didNotPickAnything = false
        self.selectedViaDrag = false
        
        if searchBar.text == ""{
            
            self.tableview.isHidden = true
        }
        
        let filter = GMSAutocompleteFilter()
        
        filter.type = GMSPlacesAutocompleteTypeFilter.establishment
        
        let placesClient = GMSPlacesClient()
        
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { (result, error) -> Void in
            
            self.arrPlaces.removeAllObjects()
            
            self.arrPlacesIDs.removeAllObjects()
            
            self.tableview.isHidden = true
            
            guard result != nil else {
                return
            }
            
            for item in result! {
                
                if let res: GMSAutocompletePrediction = item {
                    
                    print(res)
                    
                    print("Result \(res.attributedFullText.string) with placeID \(res.placeID)")
                    self.arrPlaces.add(res.attributedFullText.string)
                    
                    self.arrPlacesIDs.add(res.placeID!)
                    
                }
            }
            
            if self.arrPlaces.count != 0{
                
                self.tableview.isHidden = false
            }
            
            if self.arrPlaces.count < 1 {
                
                self.tableview.isHidden = true
            }
            
            self.tableview.reloadData()
            
        })
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom:12)
        self.mapview.animate(to: camera)
        searchbar.resignFirstResponder()
        self.dropMapPin()
    }
    
}



//MARK:- TableView DataSource and Delegate
//MARK:-
extension SearchLocationVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddressPickerTableViewCell
        
        cell.lblAddress.text = arrPlaces[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedViaTable = true
        self.selectedViaDrag = false
        
        self.searchbar.text = arrPlaces[indexPath.row] as? String
        
        self.lblAddress.text = arrPlaces[indexPath.row] as? String
        
        /////************
        
        let id = self.arrPlacesIDs[indexPath.row] as? String ?? ""
        let placeID = id
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            
            if let error = error {
                
                self.tableview.isHidden = true
                
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                
                self.tableview.isHidden = true
                
                print("No place details for \(placeID)")
                return
            }
            
            self.AddressLat  = place.coordinate.latitude
            self.AddressLong = place.coordinate.longitude
            print("Place name \(place.name)")
            
            let camera = GMSCameraPosition.camera(withLatitude: self.AddressLat, longitude: self.AddressLong, zoom: 12.0)
            self.mapview.camera = camera
            
            self.tableview.isHidden = true
            
            self.dropMapPin()
            
            //
            
        })
        
        //***************
        
        //   geoCode(str1: (arrPlaces[indexPath.row] as? String)!)
        self.tableview.isHidden = true
        self.searchHolderView.layer.cornerRadius = 22.5
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}




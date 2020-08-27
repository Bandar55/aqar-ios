//
//  AddMediaController.swift
//  AQAR55
//
//  Created by lion on 05/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class AddMediaController: UIViewController {

    @IBOutlet weak var collectionView_Media: UICollectionView!
    
    @IBOutlet weak var txtAddCaption: UITextField!

    var arrImages = NSMutableArray()
    
    var arrContent = NSMutableArray()
    
    var videoDataArr = NSMutableArray()
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        collectionView_Media.reloadData()
        
        if self.controllerPurpuse == "Edit"{
            
            setDataForEdit()
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_skip(_ sender: UIButton) {
        
        let imagesDataDict = NSMutableDictionary()
        imagesDataDict.removeAllObjects()
        
        let videoDataArr = NSMutableArray()
        let arrContent = NSMutableArray()
        
        imagesDataDict.setValue(videoDataArr, forKey: "PropertyVideoArr")
        imagesDataDict.setValue(arrContent, forKey: "PropertyVideoCaptionArr")
        
        UserDefaults.standard.set(imagesDataDict, forKey: "PropertyVideo")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationByMapController") as! AddLocationByMapController
        
        vc.controllerPurpuse = self.controllerPurpuse
        vc.editItemDict = self.editItemDict
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tap_Save(_ sender: UIButton) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationByMapController") as! AddLocationByMapController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkvalidation()
    }
    
    @IBAction func tap_addVideoBtn(_ sender: Any) {
        
        showVideoPicker()
    }
    
}


extension AddMediaController:UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView_Media.register(UINib(nibName: "AddImageCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCell")
        
        let cell = collectionView_Media.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath) as! AddImageCell
    
      //  cell.property_img.image = UIImage(named: arrImages[indexPath.item])
        
        cell.blurView.isHidden = false
        cell.lbl_propertyContent.layer.borderWidth = 0.0
     //   cell.lbl_propertyContent.text = arrContent[indexPath.item]

        cell.property_img.image = (arrImages.object(at: indexPath.item) as! UIImage)
        cell.lbl_propertyContent.text = arrContent.object(at: indexPath.item) as? String ?? ""
        
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(self.tap_deleteBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = kScreenWidth/2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    @objc func tap_deleteBtn(sender:UIButton){
        
        self.arrImages.removeObject(at: sender.tag)
        self.videoDataArr.removeObject(at: sender.tag)
        self.arrContent.removeObject(at: sender.tag)
        
        self.collectionView_Media.reloadData()
    }
}

//MARK:- Custom Method
//MARK:-
extension AddMediaController{
    
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
}

//MARK:- Video Picker
//MARK:-
extension AddMediaController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let videoURL = info[.mediaURL] as? NSURL else {
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Video file can not be picked", controller: self)
            
            dismiss(animated: true, completion: nil)
            
            fatalError("Expected a dictionary containing an video file, but was provided the following: \(info)")
            
        }
        
        do {
            
            let imageData = try Data(contentsOf: videoURL as URL)
            self.videoDataArr.add(imageData)
        
        } catch {
            
            print("Unable to load data: \(error)")
        }
        
        if getThumbnailImage(forUrl: videoURL as URL) != nil {
        
            print("success")
            let image = getThumbnailImage(forUrl: videoURL as URL) as! UIImage
            self.arrImages.add(image)
        }
        else{
            
            let image = UIImage(named: "addimagesize")
            self.arrImages.add(image!)
        }
        
        self.arrContent.add(txtAddCaption.text!)
        
        self.collectionView_Media.reloadData()
        
        dismiss(animated: true, completion: nil)
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


extension AddMediaController{
    
    func checkvalidation(){
        
        if videoDataArr.count == 0{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please upload some video for property. If you don't want to upload video then you can continue with skip", controller: self)
        }
        else{
            
            let imagesDataDict = NSMutableDictionary()
            imagesDataDict.removeAllObjects()
            
            imagesDataDict.setValue(videoDataArr, forKey: "PropertyVideoArr")
            imagesDataDict.setValue(arrContent, forKey: "PropertyVideoCaptionArr")
            
            UserDefaults.standard.set(imagesDataDict, forKey: "PropertyVideo")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationByMapController") as! AddLocationByMapController
            
            vc.controllerPurpuse = self.controllerPurpuse
            vc.editItemDict = self.editItemDict
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}



extension AddMediaController{
    
    func setDataForEdit(){
        
        let videoArr = editItemDict.object(forKey: "videosFile") as? NSArray ?? []
        
        if videoArr.count != 0{
            
            for i in 0..<videoArr.count{
                
                let dict = videoArr.object(at: i) as? NSDictionary ?? [:]
                
                let videoStr = dict.object(forKey: "video") as? String ?? ""
                
                let urlStr = URL(string: videoStr)
                
                if urlStr != nil{
                    
                    if getThumbnailImage(forUrl: urlStr as! URL) != nil {
                        
                        print("success")
                        let image = getThumbnailImage(forUrl: urlStr as! URL) as! UIImage
                        self.arrImages.add(image)
                        
                        self.arrContent.add("")
                    }
                    else{
                        
                        let image = UIImage(named: "addimagesize")
                        self.arrImages.add(image!)
                        
                        self.arrContent.add("")
                    }
                    
                    do {
                        
                        let imageData = try Data(contentsOf: urlStr as! URL)
                        self.videoDataArr.add(imageData)
                        
                    } catch {
                        
                        print("Unable to load data: \(error)")
                    }
                    
                }
               
            }
            
            self.collectionView_Media.reloadData()
        }
    }
}

//
//  AddImageController.swift
//  AQAR55
//
//  Created by lion on 05/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class AddImageController: UIViewController {
  
  
    @IBOutlet weak var collectionView_addImage: UICollectionView!
    
    @IBOutlet weak var txtAddCaption: UITextField!
    
 
    var arrImages = NSMutableArray()
    var arrContent = NSMutableArray()
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView_addImage.reloadData()
        
        imagePicker.delegate = self
       // imagePicker.allowsEditing = true
        
        if self.controllerPurpuse == "Edit"{
            
            setDataForEdit()
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSkipAction(_ sender: UIButton) {
        
        let imagesDataDict = NSMutableDictionary()
        imagesDataDict.removeAllObjects()
        
        
        let arrImages = NSMutableArray()
        let arrContent = NSMutableArray()
        
        imagesDataDict.setValue(arrImages, forKey: "PropertyImageArr")
        imagesDataDict.setValue(arrContent, forKey: "PropertyImagesCaptionArr")
        
        UserDefaults.standard.set(imagesDataDict, forKey: "PropertyImages")
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMediaController") as! AddMediaController
        
        vc.editItemDict = self.editItemDict
        vc.controllerPurpuse = self.controllerPurpuse
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_Save(_ sender: UIButton) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMediaController") as! AddMediaController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
        
    }
    
    
    @IBAction func tap_addImageBtn(_ sender: Any) {
        
        showImagePicker()
    }

}

extension AddImageController:UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView_addImage.register(UINib(nibName: "AddImageCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCell")
        
        let cell = collectionView_addImage.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath) as! AddImageCell
        cell.blurView.isHidden = true
        cell.btn_playback.isHidden = true
        
       // cell.property_img.image = UIImage(named: arrImages[indexPath.item])

        cell.lbl_propertyContent.layer.borderWidth = 0.0
       // cell.lbl_propertyContent.text = arrContent[indexPath.item]

        cell.property_img.image = UIImage(data: arrImages.object(at: indexPath.item) as! Data)
        
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
        self.arrContent.removeObject(at: sender.tag)
        
        self.collectionView_addImage.reloadData()
    }
    
}


//MARK:- Custom Method
//MARK:-
extension AddImageController{
    
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
    
}

//MARK:- UiImage Picker Delegate
//MARK:-
extension AddImageController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageData = selectedImage.jpegData(compressionQuality: 0.2)! as NSData
        
        self.arrImages.add(imageData)
        self.arrContent.add(self.txtAddCaption.text!)

        self.txtAddCaption.text = ""
        
        self.collectionView_addImage.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
   
}


extension AddImageController{
    
    func checkValidation(){
        
        if arrImages.count == 0{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please upload some images for property. If you don't want to upload images then you can continue with skip", controller: self)
        }
        else{
            
            let imagesDataDict = NSMutableDictionary()
            imagesDataDict.removeAllObjects()
            
            imagesDataDict.setValue(arrImages, forKey: "PropertyImageArr")
            imagesDataDict.setValue(arrContent, forKey: "PropertyImagesCaptionArr")
            
            UserDefaults.standard.set(imagesDataDict, forKey: "PropertyImages")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMediaController") as! AddMediaController
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}


extension AddImageController{
    
    func setDataForEdit(){
        
        let imgArr = editItemDict.object(forKey: "imagesFile") as? NSArray ?? []
        
        if imgArr.count != 0{
            
          //  DispatchQueue.global(qos: .background).async {
                
                for i in 0..<imgArr.count{
                    
                    let dict = imgArr.object(at: i) as? NSDictionary ?? [:]
                    
                    let imgStr = dict.object(forKey: "image") as? String ?? ""
                    
                    let urlStr = URL(string: imgStr)
                    
                    if urlStr != nil{
                        
                        if let data = try? Data(contentsOf: urlStr!)
                        {
                            
                            self.arrImages.add(data as NSData)
                            
                            self.arrContent.add("")
                        }
                        
                    }
                    
                }
                
                self.collectionView_addImage.reloadData()
                
           // }
            
        }
    }
}

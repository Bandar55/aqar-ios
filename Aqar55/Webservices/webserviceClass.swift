//
//  webserviceClass.swift
//  Copyright © 2016 Apple. All rights reserved.

import Foundation
import UIKit
import AFNetworking


enum methodType {
    
    case post,get
}

class webservices{
    
    
    static let sharedInstance : webservices = {
        let instance = webservices()
        
        return instance
        
    }()


    var responseCode = 0;
    
    
//    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//
//        :NSObject,STPEphemeralKeyProvider
//        let manager = AFHTTPRequestOperationManager()
//        manager.operationQueue.cancelAllOperations()
//        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//
//        let url = baseURL + "ephemeral_keys"
//
//    }
    
    
    
    func startConnectionWithText(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPRequestOperationManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    
                }
                
            },
                         
                    failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
                            
                    self.responseCode = 2
                            
                    let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                            
                    outputBlock(errorDist);
                            
                    print("Error: " + (error?.localizedDescription)!)
                            
            })
            
        }
    }
    
    // MARK: POST
    
    func startConnectionWithSting(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
        
            let manager = AFHTTPRequestOperationManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            manager.requestSerializer.timeoutInterval = 120
            
            if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                
                let type_token = UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""
                
                print(type_token)
                
                manager.requestSerializer.setValue(type_token, forHTTPHeaderField: "setToken")
                
            }
            
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    
                    if(responseObject != nil){
                    
                        self.responseCode = 1
                    
                        outputBlock(responseObject! as! NSDictionary);
                    
                    }
                
                },
                
                failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
                   
                    self.responseCode = 2
                    
                    let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                    
                    outputBlock(errorDist);
                    
                    print("Error: " + (error?.localizedDescription)!)
                    
            })
            
        }
    }
    
    
    
    // MARK: POST without token
    
    func startConnectionWithStingWithoutToken(_ getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPRequestOperationManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            //    manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
            manager.requestSerializer.timeoutInterval = 120
            
            
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    // print("JSON: " + responseObject.description)
                }
                
            },
                         
                         failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
                            
                            self.responseCode = 2
                            
                            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                            
                            outputBlock(errorDist);
                            
                            print("Error: " + (error?.localizedDescription)!)
                            
            })
            
        }
    }
    
    
    //////////////
    
    
    
    
    // MARK: POST WEBSERVICE WITH DICTIONARY TYPE PARAM
    
    
    func startConnectionWithSting_ForDictonary(_ getUrlString:NSString ,method_type:methodType, params getParams:[String:String],outputBlock:@escaping (_ receivedData:NSDictionary)->Void ) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPRequestOperationManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            let url = baseURL + (getUrlString as String)
            
            print(url)
            
            manager.post(url as String, parameters: getParams, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                   
                }
                
            },
                         failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
                            
                            self.responseCode = 2
                            
                            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                            
                            outputBlock(errorDist);
                            
                            print("Error: " + (error?.localizedDescription)!)
                            
            })
            
        }
    }
    
    //  Mark service for Document Picker
    
    func startConnectionWithFile(imageData:NSData,fileName:String,filetype:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
         manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    // method for split dictionary & then upload a document

    func startConnectionWithFile_uploadDict(imageData:NSData,fileName:String,filetype:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[String:String],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }

 
    
    
    // for two documents uploadation,1 user Image
    
 
    func startConnectionWithFile1(imageData:NSData,imageData1:NSData,fileName:String,fileName1:String,filetype:String,filetype1:String,imageparm:String,imageparm1:String,userImage:NSData,userImageName:String,userImageParam:String,userImageFileType:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
            formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            }
            
            if imageData1.length > 0{
            formData!.appendPart(withFileData: imageData1 as Data!, name:imageparm1, fileName: fileName1, mimeType: filetype1)
            }
            
            if userImage.length > 0{
            formData!.appendPart(withFileData: userImage as Data!, name:userImageParam, fileName: userImageName, mimeType: userImageFileType)
            }
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    /// MARK: use for google map api
    
    
    func startConnectionWithStringGetTypeGoogle(getUrlString: NSString, outputBlock: @escaping (_ receivedData:NSDictionary)->Void) {
        
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.timeoutInterval = 180
    
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
    
        let url = (getUrlString as String)
    
        manager.get(url as String, parameters: nil, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
            
            if(responseObject != nil){
                
                self.responseCode = 1
            
                outputBlock(responseObject! as! NSDictionary)
            
                
            }
        
            
        }, failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
            
    
            self.responseCode = 2
        
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]

            outputBlock(errorDist)
            
        })
        
    }
    
    
    func startConnectionWithSingleFile(_ imageData:NSData,fileName:String,filetype:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
    
        DispatchQueue.global().async {
        
            let manager = AFHTTPRequestOperationManager()
        
            manager.operationQueue.cancelAllOperations()
        
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            
        
            let url = baseURL + (getUrlString as String)
        
            manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            //code
                
                if imageData.length > 0{
                    
                    formData!.appendPart(withFileData: imageData as Data!, name: "file", fileName: fileName, mimeType: filetype)
                }
              
                }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any!) -> Void in
                    
                    print(responseObject)
                    
                    if(responseObject != nil){
                    
                        self.responseCode = 1
                    
                        outputBlock(responseObject! as! NSDictionary);
                    
                    }
                
                }, failure: { (operation:AFHTTPRequestOperation?, error: Error?) -> Void in
            
                    self.responseCode = 2
            
                    let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
                    outputBlock(errorDist);
            
                    print(error!)
            
            })
        
        }
    
    }
    
    // get type webservice
    
    func startConnectionWithStringGetType(getUrlString:NSString ,outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        let url = baseURL + (getUrlString as String)
        
        print(url)
        
        manager.get(url as String, parameters: nil, success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
        }, failure: { (operation: AFHTTPRequestOperation?,error: Error?) in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
            print("Error: " + (error?.localizedDescription)!)
        })
    }

    
    func startConnectionWithData(imageData:NSData,fileName:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: "image/jpeg")
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    func startConnectionWithfile1(_ imageData:NSArray,fileName:String,filetype:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        DispatchQueue.global().async {
        
            let manager = AFHTTPRequestOperationManager()
        
            manager.operationQueue.cancelAllOperations()
        
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
            let url = baseURL + (getUrlString as String)
        
            manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            //code
            
                for i in 0..<imageData.count{
              
                    let imagedata:Data = imageData[i] as! Data
                
                    let strname = String(format: "name%@", i)
                
                    formData?.appendPart(withFileData: imagedata, name: strname, fileName: fileName, mimeType: filetype)
                
                }
            
            }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any!) -> Void in
                
                print(responseObject)
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    print("JSON: " + (responseObject as AnyObject).description)
                }
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) -> Void in
                
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print(error!)
                
            })
            
        }
    }
    
    
    func startConnectionWithEditProfileService(imageData:NSData,imageData1:NSData,fileName:String,fileName1:String,filetype:String,filetype1:String,imageparm:String,imageparm1:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: filetype)
            }
            
            if imageData1.length > 0{
                formData!.appendPart(withFileData: imageData1 as Data!, name:imageparm1, fileName: fileName1, mimeType: filetype1)
            }
            
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }

    
    ///////////
    
    func startConnectionWithProfileData(imageData:NSData,fileName:String,imageparm:String, getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: "image/jpeg")
            }
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    //////////
    
    func startConnectionWithProfileDataWithArray(imageData:NSData,fileName:String,imageparm:String, getUrlString:NSString,fileArr:NSMutableArray,ArrayParam:String,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageData.length > 0{
                
                formData!.appendPart(withFileData: imageData as Data!, name:imageparm, fileName: fileName, mimeType: "image/jpeg")
            }
            
            if fileArr.count != 0{
                
                for i in 0..<fileArr.count{
                    
                    let imagedata = fileArr[i] as! Data
                    
                    formData!.appendPart(withFileData: imagedata, name:ArrayParam, fileName: "foodImage.jpg", mimeType: "image/jpeg")
                }
            }
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    //:::::::::::::::::::::::::::
    
    
    func startConnectionWithMultipleArray(_ imageData:NSMutableArray,imageParam:String,filetype:String,videoData:NSMutableArray,videoParam:String,videoFileType:String,getUrlString:NSString ,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        DispatchQueue.global().async {
            
            let manager = AFHTTPRequestOperationManager()
            
            manager.operationQueue.cancelAllOperations()
            
            manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
            
            
            if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                
                let type_token = UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""
                
                print(type_token)
                
                manager.requestSerializer.setValue(type_token, forHTTPHeaderField: "setToken")
                
            }
            
            
            let url = baseURL + (getUrlString as String)
            
            manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
                //code
                
                for i in 0..<imageData.count{
                    
                    let imagedata:Data = imageData[i] as! Data
                    
                    let strname = "PropertyImage.jpg"
                    
                    formData?.appendPart(withFileData: imagedata, name: imageParam, fileName: strname, mimeType: filetype)
                    
                }
                
                
                for i in 0..<videoData.count{
                    
                    let imagedata1:Data = videoData[i] as! Data
                    
                    let strname = "video\(i).mp4"
                    
                    formData?.appendPart(withFileData: imagedata1, name: videoParam, fileName: strname, mimeType: videoFileType)
                }
                
            }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any!) -> Void in
                
                //  print(responseObject)
                
                if(responseObject != nil){
                    
                    self.responseCode = 1
                    
                    outputBlock(responseObject! as! NSDictionary);
                    
                    print("JSON: " + (responseObject as AnyObject).description)
                }
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) -> Void in
                
                self.responseCode = 2
                
                let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
                
                outputBlock(errorDist);
                
                print(error!)
                
            })
            
        }
    }
   
    func startConnectionWithProfileDataWithArray2(imageDataProfile:NSData,fileNameProfile:String,imageparmProfile:String,imageDataGovID1:NSData,fileNameGovID1:String,imageparmGovID1:String,imageDataGovID2:NSData,fileNameGovID2:String,imageparmGovID2:String,videoData:NSData,videoName:String,videoparm:String, getUrlString:NSString,fileArr:NSMutableArray,ArrayParam:String,method_type:methodType, params getParams:[NSString:NSObject],outputBlock:@escaping (_ receivedData:NSDictionary)->Void) {
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.operationQueue.cancelAllOperations()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let type_token = UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""
            
            print(type_token)
            
            manager.requestSerializer.setValue(type_token, forHTTPHeaderField: "setToken")
            
        }
        
        
        manager.requestSerializer.timeoutInterval = 180
        
        let url = baseURL + (getUrlString as String)
        
        manager.post(url, parameters: getParams, constructingBodyWith: { (formData: AFMultipartFormData?) -> Void in
            
            if imageDataProfile.length > 0{
                
                formData!.appendPart(withFileData: imageDataProfile as Data!, name:imageparmProfile, fileName: fileNameProfile, mimeType: "image/jpeg")
            }
            
            
            if imageDataGovID1.length > 0{
                
                formData!.appendPart(withFileData: imageDataGovID1 as Data!, name:imageparmGovID1, fileName: fileNameGovID1, mimeType: "image/jpeg")
            }
            
            
            if imageDataGovID2.length > 0{
                
                formData!.appendPart(withFileData: imageDataGovID2 as Data!, name:imageparmGovID2, fileName: fileNameGovID2, mimeType: "image/jpeg")
            }
            
            if videoData.length > 0{
                
                formData!.appendPart(withFileData: videoData as Data!, name:videoparm, fileName: videoName, mimeType: "video/mp4")
            }
            
            if fileArr.count != 0{
                
                for i in 0..<fileArr.count{
                    
                    let imagedata = fileArr[i] as! Data
                    
                    formData!.appendPart(withFileData: imagedata, name:ArrayParam, fileName: ArrayParam, mimeType: "image/jpeg")
                }
            }
            
        }, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) -> Void in
            
            if(responseObject != nil){
                
                self.responseCode = 1
                
                outputBlock(responseObject! as! NSDictionary);
                
            }
            
        }, failure: { (operation:AFHTTPRequestOperation?, error:
            Error?) -> Void in
            
            self.responseCode = 2
            
            let errorDist:NSDictionary = ["Error" : error!.localizedDescription]
            
            outputBlock(errorDist);
            
        })
    }
    
    
    
    
}


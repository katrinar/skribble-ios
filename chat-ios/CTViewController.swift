//
//  CTViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import Cloudinary

class CTViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLUploaderDelegate  {
    
   static var currentUser = CTProfile() //shared across the application
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(CTViewController.userLoggedIn(_:)),
            name: Constants.kUserLoggedInNotification,
            object: nil
        )
        let logoImageView = UIImageView(image: UIImage(named: "skribble-logo_icon.png"))
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: logoImageView.frame.size.width, height: logoImageView.frame.size.height+10))
        logoView.addSubview(logoImageView)
        
        self.navigationItem.titleView = logoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("CurrentUser: \(CTViewController.currentUser.id)")
    
    }
    
    func showCameraOptions() -> UIAlertController {
        
        let actionSheet = UIAlertController(title: "Select Photo Source", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            print("Select Camera: \(action.title!)")
            dispatch_async(dispatch_get_main_queue(), {
                self.launchPhotoPicker(.Camera)
            })
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { action in
            print("Select Photo Library: \(action.title!)")
            
            dispatch_async(dispatch_get_main_queue(), {
                self.launchPhotoPicker(.PhotoLibrary)
            })
        }))
        
        return actionSheet
        
//        if (self.selectedImage == nil){
//            self.presentViewController(actionSheet, animated: true, completion: nil)
//            return
//        }
        
    }
    
    
    
    func launchPhotoPicker(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func userLoggedIn(notification: NSNotification){
        if let user = notification.userInfo!["user"] as? Dictionary<String, AnyObject>{
        CTViewController.currentUser.populate(user)
        }
    }
    
    func postLoggedInNotification(currentUser: Dictionary<String, AnyObject>){
        let notification = NSNotification(
            name: Constants.kUserLoggedInNotification,
            object: nil,
            userInfo: ["user":currentUser]
        )
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotification(notification)
    }
    
    func checkLoggedIn()-> Bool {
        if (CTViewController.currentUser.id != nil){
            return true
        }
        
        let alert = UIAlertController(
            title: "Not Logged In",
            message: "Please log in or register to chat.",
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.startLoginRegisterSequence()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        return false
    }
    
    
    //MARK: - UploadImage
    func uploadImage(image: UIImage, completion:(imageInfo:Dictionary<String, AnyObject>) -> Void){
//        if (self.selectedImage == nil){
//            return
//        }
        
        // cloudinary://118396592152297:GzR9SFSUapiY2wzTIyV463rdAoU@hnhde1nnq
        let clouder = CLCloudinary(url: "cloudinary://118396592152297:GzR9SFSUapiY2wzTIyV463rdAoU@hnhde1nnq")
        let forUpload = UIImageJPEGRepresentation(image, 0.5)
        
        let uploader = CLUploader(clouder, delegate: self)
        
        uploader.upload(forUpload, options: nil,
                        
                        withCompletion: { (dataDictionary: [NSObject: AnyObject]!, errorResult:String!, code:Int, context: AnyObject!) -> Void in
                            
                            print("Upload Response: \(dataDictionary)")
                            
                            // self.uploadResponse = Mapper<ImageUploadResponse>().map(dataDictionary)
                            // if code < 400 { onCompletion(status: true, url: self.uploadResponse?.imageURL)}
                            // else {onCompletion(status: false, url: nil)}
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                var imageUrl = ""
                                if let secure_url = dataDictionary["secure_url"] as? String{
                                    imageUrl = secure_url
                                }
                                
                                //Generate thumbnail url:
                                //https://res.cloudinary.com/hnhde1nnq/image/upload/t_thumb_250/v1467073098/q19hek7eo2ospnrg6qvw.jpg
                                
                                let thumbnailUrl = imageUrl.stringByReplacingOccurrencesOfString("/upload/", withString: "/upload/t_thumb_250/")
                                
                                let imageInfo = [
                                    "original": imageUrl,
                                    "thumb": thumbnailUrl
                                ]
                                
                                completion(imageInfo: imageInfo)
                                
//                                self.placeInfo["image"] = imageInfo
//                                self.selectedImage = nil
//                                // nil it out to prevent infinite loop
//                                self.createPlace(self.placeInfo)
                                
                            })
            },
                        
                        andProgress: { (bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, context:AnyObject!) -> Void in
                            
                            print("Upload progress: \((totalBytesWritten * 100)/totalBytesExpectedToWrite) %");
            }
            
        )
    }
    
    func startLoginRegisterSequence(){
        let loginRegisterVc = CTAccountViewController()
        loginRegisterVc.showsBackButton = true
        let navCtr = UINavigationController(rootViewController: loginRegisterVc)
        navCtr.navigationBar.barTintColor = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1)

        self.presentViewController(navCtr, animated: true, completion: nil)
    }
    
    func exit(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureCustomBackButton(){
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_icon.png")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

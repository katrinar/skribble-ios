//
//  CTViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTViewController: UIViewController {
    
   static var currentUser = CTProfile() //shared across the application
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(CTViewController.userLoggedIn(_:)),
                                        name: Constants.kUserLoggedInNotification,
                                        object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("CurrentUser: \(CTViewController.currentUser.id)")
    
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
    
    func startLoginRegisterSequence(){
        let loginRegisterVc = CTAccountViewController()
        loginRegisterVc.showsBackButton = true
        let navCtr = UINavigationController(rootViewController: loginRegisterVc)
        self.presentViewController(navCtr, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

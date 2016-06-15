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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

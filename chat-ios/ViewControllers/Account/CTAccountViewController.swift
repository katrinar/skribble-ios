//
//  CTAccountViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTAccountViewController: CTViewController {
    
    var loginButtons = Array<UIButton>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Account"
        self.tabBarItem.image = UIImage(named: "profile_icon.png")

    }
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .blueColor()
        
        
        if (CTViewController.currentUser.id == nil){ // not logged in
            self.loadSignupView(frame, view: view)

        }
        else { // logged in
            self.loadAccountView(frame, view: view)
        }
        
        self.view = view
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

    }
    
    func loadAccountView(frame: CGRect, view: UIView){
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
//        let height = CGFloat(44)
//        let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
//        let whiteColor = UIColor.whiteColor().CGColor
//        let font = UIFont(name: "Heiti SC", size: 18)
        let y = CGFloat(Constants.origin_y)
        
        let nameLabel = UILabel(frame: CGRect(x: padding, y: y, width: width, height: 22))
        nameLabel.text = CTViewController.currentUser.email
        nameLabel.textColor = UIColor.whiteColor()
        view.addSubview(nameLabel)
        
    }
    
    func loadSignupView(frame: CGRect, view: UIView){
        
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let height = CGFloat(44)
        let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        let whiteColor = UIColor.whiteColor().CGColor
        let font = UIFont(name: "Heiti SC", size: 18)
        var y = CGFloat(Constants.origin_y)
        
        let buttonTitles = ["Sign Up", "Login"]
        for btnTitle in buttonTitles {
            let btn = CTButton(frame: CGRect(x: padding, y: y, width: width, height: height))
            btn.setTitle(btnTitle, forState: .Normal)
            btn.addTarget(self, action: #selector(CTAccountViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
            self.loginButtons.append(btn)
            view.addSubview(btn)
            y += height+padding
        }
        
    }
    
    func buttonTapped(btn: UIButton){
        let buttonTitle = btn.titleLabel?.text?.lowercaseString
        print("buttonTapped: \(buttonTitle!)")
        
        if (buttonTitle == "sign up"){
            let registerVc = CTRegisterViewController()
            self.navigationController?.pushViewController(registerVc, animated: true)
        }
        
        if (buttonTitle == "login"){
            let loginVc = CTLoginViewController()
            self.navigationController?.pushViewController(loginVc, animated: true)
        }
    }
    
    override func userLoggedIn(notification: NSNotification){
        super.userLoggedIn(notification)
        if (CTViewController.currentUser.id == nil){
            return
        }
        
        for btn in self.loginButtons{
            btn.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

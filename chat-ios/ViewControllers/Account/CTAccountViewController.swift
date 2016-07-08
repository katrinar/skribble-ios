//
//  CTAccountViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTAccountViewController: CTViewController, UITableViewDelegate, UITableViewDataSource {
    
    var loginButtons = Array<UIButton>()
    var places = Array<CTPlace>()
    var placesTable: UITableView!
    var showsBackButton = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = ""
        self.tabBarItem.title = "Account"
        self.tabBarItem.image = UIImage(named: "profile_icon.png")
        self.edgesForExtendedLayout = .None
    }
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .whiteColor()
        
        
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
        let path = "/api/place"
        
        var params = Dictionary<String, AnyObject>()
        
        params["admins"] = CTViewController.currentUser.id
        params["key"] = Constants.APIKey //temporary key for testing
        
        
        APIManager.getRequest(
            path,
            params: params,
            completion: { response in
//                print("ACCOUNT RESULTS: \(response)")
                
                if let results = response["results"] as? Array<Dictionary<String, AnyObject>>{
                    print("results")
                    
                    for placeInfo in results {
                        let place = CTPlace()
                        place.populate(placeInfo)
                        self.places.append(place)
                    }
                    
                    self.placesTable.reloadData()
                }
            })
            
        
        self.navigationItem.hidesBackButton = !self.showsBackButton
        
        if (self.showsBackButton == false){
            return
        }
        
            let btnCancel = UIButton(type: .Custom)
            let cancelIcon = UIImage(named: "cancel_icon.png")!
            btnCancel.setImage(cancelIcon, forState: .Normal)
            
            btnCancel.frame = CGRect(x: 0, y: 0, width: cancelIcon.size.width, height: 44)
            
            btnCancel.addTarget(
                self,
                action: #selector(CTAccountViewController.exit),
                forControlEvents: .TouchUpInside)
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnCancel)
        
    }
    
    func loadAccountView(frame: CGRect, view: UIView){
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let font = UIFont(name: "Heiti SC", size: 14)
            
        let lblUsername = UILabel(frame: CGRect(x: padding, y: padding, width: width, height: 24))
        lblUsername.textColor = .darkGrayColor()
        lblUsername.font = UIFont.boldSystemFontOfSize(24)
        lblUsername.text = CTViewController.currentUser.username
        view.addSubview(lblUsername)
        
        var y = padding+lblUsername.frame.size.height
        
        let lblEmail = UILabel(frame: CGRect(x: padding, y: y, width: width, height: 18))
        lblEmail.font = font
        lblEmail.textColor = .darkGrayColor()
        lblEmail.text = CTViewController.currentUser.email
        view.addSubview(lblEmail)
        
        y += padding+lblEmail.frame.size.height
        
        let line = UIView(frame: CGRect(x: 0, y: y, width: frame.size.width, height: 0.5))
        line.backgroundColor = .darkGrayColor()
        view.addSubview(line)
        
        y += line.frame.size.height

        
//        let btnLogout = CTButton(frame: CGRect(x: padding, y: y, width: width, height: 44))
//        btnLogout.setTitle("Logout", forState: .Normal)
//        btnLogout.addTarget(self,
//                            action: #selector(CTAccountViewController.logout),
//                            forControlEvents: .TouchUpInside)
//        view.addSubview(btnLogout)
//        
//        y += padding+btnLogout.frame.size.height
        
        self.placesTable = UITableView(frame: CGRect(x: 0, y: y, width: frame.size.width, height: frame.size.height-y))
        self.placesTable.autoresizingMask = .FlexibleHeight
        self.placesTable.dataSource = self
        self.placesTable.delegate = self
        self.placesTable.separatorStyle = .None
        self.placesTable.showsVerticalScrollIndicator = false
        self.placesTable.registerClass(CTPlaceTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(self.placesTable)

    }
    
    //MARK: - TableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let place = self.places[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier(CTTableViewCell.cellId, forIndexPath: indexPath) as! CTPlaceTableViewCell
        cell.lblTitle.text = place.title
        return cell
        
            }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CTPlaceTableViewCell.defaultHeight
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your Places"
    }

    
    //MARK: - Logout
    
    func logout(){
        APIManager.getRequest("/account/logout", params: nil, completion: { response in
            
            print("\(response)")
            

            })
    }
    
    //MARK: - Load Sign Up View

    func loadSignupView(frame: CGRect, view: UIView){
        
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let height = CGFloat(44)
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
            registerVc.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem
            self.navigationController?.pushViewController(registerVc, animated: true)
        }
        
        if (buttonTitle == "login"){
            let loginVc = CTLoginViewController()
            loginVc.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem
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

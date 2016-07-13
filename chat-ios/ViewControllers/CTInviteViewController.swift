//
//  CTInviteViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 7/12/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTInviteViewController: CTViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var contactTable: UITableView!
    var topView: UIView!
    var searchField: UITextField!
    
    var contacts: Array<Dictionary<String, AnyObject>> = [
        
        ["name":"John F. Kennedy", "state": "New York"],
        ["name":"Bill Clinton", "state": "Arkansas"],
        ["name":"Hilary Clinton", "state": "Illinois"],
        ["name":"George H.W. Bush", "state": "Connecticut"],
        ["name":"Donald Trump", "state": "New York"],
        ["name":"Ronald Reagan", "state": "California"],
        ["name":"George W. Bush", "state": "Texas"],
        ["name":"Barack Obama", "state": "Illinois"],
        ["name":"Jimmy Carter", "state": "Georgia"]
    
    ]
    
    // MARK: - Lifecycle Methods
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.edgesForExtendedLayout = .None
    }

    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        
        var y = CGFloat(15)
        let padding = CGFloat(6)
        let width = frame.size.width
        let height = CGFloat(32)
        let dimen = height + padding
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 84))
        self.topView.autoresizingMask = .FlexibleTopMargin
        self.topView.backgroundColor = .lightGrayColor()
        
        let btnCancel = UIButton(type: .Custom)
        btnCancel.frame = CGRect(x: width-dimen, y: y, width: height, height: height)
        btnCancel.setImage(UIImage(named: "cancel_icon.png"), forState: .Normal)

        btnCancel.addTarget(self,
                            action: #selector(CTViewController.exit),
                            forControlEvents: .TouchUpInside)
        topView.addSubview(btnCancel)
        
        y += btnCancel.frame.size.height
        
        self.searchField = UITextField(frame: CGRect(x: padding, y: y, width: width-2*padding, height: height))
        self.searchField.placeholder = "Search Your Contacts"
        self.searchField.borderStyle = .RoundedRect
        topView.addSubview(self.searchField)
        
        view.addSubview(topView)
        
        self.contactTable = UITableView(frame: frame, style: .Plain)
        self.contactTable.delegate = self
        self.contactTable.dataSource = self
        self.contactTable.contentInset = UIEdgeInsetsMake(84, 0, 0, 0)
        self.contactTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(self.contactTable)
        view.bringSubviewToFront(topView)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
        cell.textLabel?.text = ("\(contacts[indexPath.row]["name"]!)") as String
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

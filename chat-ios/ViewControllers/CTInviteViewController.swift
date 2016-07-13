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
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        self.edgesForExtendedLayout = .None

//        view.backgroundColor = .greenColor()
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 92))
        self.topView.backgroundColor = .lightGrayColor()
        view.addSubview(topView)
        
        let btnCancel = UIButton(type: .Custom)
        btnCancel.frame = CGRect(x: frame.size.width-100, y: 10, width: 100, height: 32)
        btnCancel.setImage(UIImage(named: "cancel_icon.png"), forState: .Normal)

        btnCancel.addTarget(self,
                            action: #selector(CTViewController.exit),
                            forControlEvents: .TouchUpInside)
        topView.addSubview(btnCancel)
        
        self.searchField = UITextField(frame: CGRect(x: 10, y: 50, width: frame.size.width-20, height: 32))
        self.searchField.placeholder = "Search Your Contacts"
        self.searchField.borderStyle = .RoundedRect
        topView.addSubview(searchField)
        
        self.contactTable = UITableView(frame: CGRect(x: 0, y:92, width: frame.size.width, height: frame.size.height-92), style: .Plain)
        self.contactTable.delegate = self
        self.contactTable.dataSource = self
        self.contactTable.contentInset = UIEdgeInsetsMake(0, 5, 0, 0)
        self.contactTable.autoresizingMask = .FlexibleHeight
        self.contactTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(self.contactTable)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
        cell.textLabel?.text = "John Smith"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

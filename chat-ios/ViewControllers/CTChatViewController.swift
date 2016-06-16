//
//  CTChatViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/16/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var place: CTPlace!
    var chatTable: UITableView!
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .grayColor()
        
        self.chatTable = UITableView(frame: frame, style: .Plain)
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        self.chatTable.registerClass(CTTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(self.chatTable)
        
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 20
    }
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(CTTableViewCell.cellId, forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

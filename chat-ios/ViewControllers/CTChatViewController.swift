//
//  CTChatViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/16/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import Firebase

class CTChatViewController: CTViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //Firebase Config:
    var firebase: FIRDatabaseReference! // establishes connection and maintains connection to DB
    var _refHandle: UInt!
    
    var place: CTPlace!
    var chatTable: UITableView!
    var posts = Array<Dictionary<String, AnyObject>>()
    var keys = Array<String>()
    var bottomView: UIView!
    var messageField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true

    }
    
    override func loadView(){
        self.edgesForExtendedLayout = .None
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .grayColor()
        
        self.chatTable = UITableView(frame: frame, style: .Plain)
        self.chatTable.dataSource = self
        self.chatTable.delegate = self
        self.chatTable.registerClass(CTTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        view.addSubview(self.chatTable)
        
        let height = CGFloat(44)
        let width = frame.size.width
        let y = frame.size.height //offscreen bounds; will animate in
        self.bottomView = UIView(frame: CGRect(x: 0, y: y, width: width, height: height))
        self.bottomView.autoresizingMask = .FlexibleTopMargin
        self.bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(bottomView)
        
        let padding = CGFloat(6)
        let btnWidth = CGFloat(80)
        
        self.messageField = UITextField(frame: CGRect(x: padding, y: padding, width: width-2*padding-btnWidth, height: height-2*padding))
        self.messageField.borderStyle = .RoundedRect
        self.messageField.placeholder = "Post a message"
        self.messageField.delegate = self
        self.bottomView.addSubview(self.messageField)
        
        let btnSend = UIButton(type: .Custom)
        btnSend.frame = CGRect(x: width-btnWidth, y: padding, width: 74, height: height-2*padding)
        btnSend.setTitle("Send", forState: .Normal)
        btnSend.backgroundColor = UIColor.lightGrayColor()
        btnSend.layer.cornerRadius = 5
        btnSend.layer.masksToBounds = true
        btnSend.layer.borderColor = UIColor.darkGrayColor().CGColor
        btnSend.layer.borderWidth = 0.5
        btnSend.addTarget(self, action: #selector(CTChatViewController.postMessage(_:)), forControlEvents: .TouchUpInside)
        self.bottomView.addSubview(btnSend)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebase = FIRDatabase.database().reference() // initialize FB manager
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear:")
        
        UIView.animateWithDuration(0.4, animations: {
            var bottomFrame = self.bottomView.frame
            bottomFrame.origin.y = bottomFrame.origin.y-self.bottomView.frame.size.height
            
            self.bottomView.frame = bottomFrame
        })
        
        //Listen for new messages in the FB DB
        self._refHandle = self.firebase.child(self.place.id).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let payload = snapshot.value as? Dictionary<String, AnyObject> {
                
                for key in payload.keys {
                    let post = payload[key] as! Dictionary<String, AnyObject>
                    print("POST == \(post)")
                
                    
                    if (self.keys.contains(key)){
                        continue
                    }
                    
                    self.keys.append(key)
                    self.posts.append(post)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.chatTable.reloadData()
                    })
                }
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.firebase.removeObserverWithHandle(self._refHandle)
    }
    
    func postMessage(btn: UIButton){
        print("postMessage: ")
    }
    
    //MARK: - TableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = self.posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CTTableViewCell.cellId, forIndexPath: indexPath)
        cell.textLabel?.text = post["message"] as? String
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath")
        
        //Push data to Firebase Database
        let timestamp = NSDate().timeIntervalSince1970
        let post = [
            "from": CTViewController.currentUser.id!,
            "message":"this is a test - KR",
            "timestamp": "\(timestamp)",
            "place":self.place.id
        ]
        
        self.firebase.child(self.place.id).childByAutoId().setValue(post)
        
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn: ")
        messageField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
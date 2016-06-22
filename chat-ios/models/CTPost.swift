//
//  CTPost.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/22/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTPost: NSObject {
    
    var id: String!
    var from: String!
    var message: String!
    var place: String!
    var timestamp: NSDate!
    
    func populate(postInfo: Dictionary<String, AnyObject>){
        let keys = ["message", "place", "from"]
        for key in keys {
            self.setValue(postInfo[key], forKey: key)
        }
        
        if let _timestamp = postInfo["timestamp"] as? String {
            
            let ts = Double(_timestamp)
            let date = NSDate(timeIntervalSince1970: ts!)
            print("DATE: \(date)")

        }
    }

}

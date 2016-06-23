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
    var formattedDate: String!
    
    func populate(postInfo: Dictionary<String, AnyObject>){
        let keys = ["message", "place", "from"]
        for key in keys {
            self.setValue(postInfo[key], forKey: key)
        }
        
        if let _timestamp = postInfo["timestamp"] as? String {
            
            let ts = NSTimeInterval(_timestamp)
            self.timestamp = NSDate(timeIntervalSince1970: ts!)
            print("DATE: \(self.timestamp)")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy" // "May 16, 2015"
            self.formattedDate = dateFormatter.stringFromDate(self.timestamp)

        }
    }

}

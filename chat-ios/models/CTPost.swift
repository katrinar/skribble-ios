//
//  CTPost.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/22/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import Alamofire

class CTPost: NSObject {
    
    var id: String!
    var from: String!
    var message: String!
    var place: String!
    var image: String!
    var imageData: UIImage?
    var timestamp: NSDate!
    var formattedDate: String!
    var isFetching = false
    
    func populate(postInfo: Dictionary<String, AnyObject>){
        let keys = ["message", "place", "from", "image"]
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
    
    func fetchImage(){
        if (self.image.characters.count == 0){
            return
        }
        
        if (self.imageData != nil){
            return
        }
        
        if (self.isFetching == true){
            return
        }
        
        self.isFetching = true
        Alamofire.request(.GET, self.image, parameters: nil).response { (req, res, data, error) in
            self.isFetching = false
            if (error != nil){
                return
            }
            
            if let img = UIImage(data: data!){
                self.imageData = img
            }
            
        }
    }

}

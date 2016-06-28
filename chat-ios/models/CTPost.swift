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
    var timestamp: NSDate!
    var formattedDate: String!
    var isFetching = false
    
    //Images
    var image: Dictionary<String, AnyObject>!
    var imageUrl: String!
    var thumbnailUrl: String!
    var imageData: UIImage?
    var thumbnailData: UIImage?
    
    
    
    func populate(postInfo: Dictionary<String, AnyObject>){
        let keys = ["message", "place", "from"]
        for key in keys {
            self.setValue(postInfo[key], forKey: key)
        }
        
        //Parsing Image
        if let _image = postInfo["image"] as? Dictionary<String, AnyObject> {
           
            if let _original = _image["original"] as? String {
                
                 self.imageUrl = _original
            }
            
            if let _thumb = _image["thumb"] as? String {
                self.thumbnailUrl = _thumb
            }
        }
        
        if let _timestamp = postInfo["timestamp"] as? String {
            
            let ts = NSTimeInterval(_timestamp)
            self.timestamp = NSDate(timeIntervalSince1970: ts!)
            print("DATE: \(self.timestamp)")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy" // "May 16, 2015"
            self.formattedDate = dateFormatter.stringFromDate(self.timestamp)

        }
    }
    
    func fetchThumbnail(){
        if (self.thumbnailUrl.characters.count == 0){
            return
        }
        
        if (self.thumbnailData != nil){
            return
        }
        
        if (self.isFetching == true){
            return
        }
        
        self.isFetching = true
        Alamofire.request(.GET, self.thumbnailUrl, parameters: nil).response { (req, res, data, error) in
            self.isFetching = false
            if (error != nil){
                return
            }
            
            if let img = UIImage(data: data!){
                self.thumbnailData = img
            }
        }
    }
    
    func fetchImage(){
        
     
        if (self.imageUrl.characters.count == 0){
            return
        }
        
        if (self.imageData != nil){
            return
        }
        
        if (self.isFetching == true){
            return
        }
        
        self.isFetching = true
        Alamofire.request(.GET, self.imageUrl, parameters: nil).response { (req, res, data, error) in
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

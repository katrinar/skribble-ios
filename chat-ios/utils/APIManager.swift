//
//  APIManager.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    
    static func getRequest(path:String, params:Dictionary<String, AnyObject>?, completion:((results: Dictionary<String, AnyObject>) -> Void)?) {
        
        let url = Constants.baseUrl+path
        
        
        Alamofire.request(.GET, url, parameters: params).responseJSON { response in
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                if (completion != nil){
                    completion!(results: json)
                }
            }
        }
    }
    
    static func postRequest(path:String, params:Dictionary<String, AnyObject>?, completion:((error: NSError?, results: Dictionary<String, AnyObject>?) -> Void)?) {
        
        let url = Constants.baseUrl+path

        Alamofire.request(.POST, url, parameters: params).responseJSON { response in
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                if (completion != nil){
                    
                    if (completion == nil){
                        return
                    }
                    
                    if let confirmation = json["confirmation"] as? String {
                        if (confirmation == "success"){
                            completion!(error: nil, results: json)

                        }
                        else{
                            let msg = json["message"] as! String
                            let err = NSError(domain: "", code: 0, userInfo: ["message": msg])
                            completion!(error: err, results: nil)
                        }
                    }
                    
                }
            }
        }
    }


static func checkCurrentUser(completion:((results: Dictionary<String, AnyObject>) -> Void)?) {
    
    let url = Constants.baseUrl+"/account/currentuser"
    
    Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
        if let json = response.result.value as? Dictionary<String, AnyObject>{
            if (completion != nil){
                completion!(results: json)
            }
        }
    }

}

}


//
//  CTRegisterViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/9/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTRegisterViewController: CTViewController, UITextFieldDelegate {
    
    var textFields = Array<UITextField>()
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .whiteColor()
        
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let height = CGFloat(32)
        var y = CGFloat(Constants.origin_y)

        let fieldNames = ["Username", "Email", "Password"]
        let imgs = [UIImage(named:"profile_icon.png")!, UIImage(named: "email_icon.png")!, UIImage(named: "key_icon.png")!]

        for i in 0..<3 {
            
            let field = CTTextField(frame: CGRect(x: padding+20, y: y, width: width, height: height))
            field.delegate = self
            field.placeholder = fieldNames[i]

            let isPassword = (fieldNames[i] == "Password")
            field.secureTextEntry = (isPassword)
            field.returnKeyType = (isPassword) ? .Join : .Next
            
            let icon = UIImageView(frame: CGRect(x: padding-4, y: y+4, width: 20, height: 20))
            icon.image = imgs[i]
            view.addSubview(icon)
            
            view.addSubview(field)
            self.textFields.append(field)
            y += height+padding
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.navigationItem.leftBarButtonItem != nil){
            self.navigationItem.hidesBackButton = true
            return
        }
        
       self.configureCustomBackButton()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let index = self.textFields.indexOf(textField)!
        print("textFieldShouldReturn: \(index)")
        
        if (index == self.textFields.count-1){ //password field, register
            var missingValue = ""
            var profileInfo = Dictionary<String, AnyObject>()

            for textField in self.textFields {
                if (textField.text?.characters.count == 0){
                    missingValue = textField.placeholder!
                    break
                }
                
                profileInfo[textField.placeholder!.lowercaseString] = textField.text!
            }
            
            //Incomplete:
            if (missingValue.characters.count > 0){
                print("MISSING VALUE")
                let msg = "You forgot your "+missingValue
                let alert = UIAlertController(title: "Missing Value",
                                              message: msg,
                                              preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return true
            }
            

            APIManager.postRequest("/api/profile",
                                   params: profileInfo,
                                   completion: { error, response in
                                    
                                    print("\(response)")
                                    
                                    if let result = response!["result"] as? Dictionary<String, AnyObject>{
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            
                                            self.postLoggedInNotification(result)
                                            
                                            if (self.navigationItem.leftBarButtonItem == nil){
                                                let accountVc = CTAccountViewController()
                                                self.navigationController?.pushViewController(accountVc, animated: true)
                                            }
                                            else {
                                                self.exit()
                                            }
                                        })
                                       
                                    }
            })
            
            return true
        }
        
        let nextField = self.textFields[index+1]
        nextField.becomeFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

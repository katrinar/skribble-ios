//
//  CTTextField.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/16/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTTextField: UITextField {
    
    var icon: UIImageView!
    
    // override setter to set icon image
    override var placeholder: String? {
        didSet {
            if (placeholder == nil){
                return
            }
            
            if (placeholder?.lowercaseString == "username"){
                self.icon.image = UIImage(named:"profile_icon.png") 
            }
            
            if (placeholder?.lowercaseString == "email"){
                self.icon.image = UIImage(named:"email_icon.png")
            }
            
            if (placeholder?.lowercaseString == "password"){
                self.icon.image = UIImage(named:"key_icon.png")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont(name: "Heiti SC", size: 18)
        self.autocorrectionType = .No
        
        let dimen = frame.size.height
        self.icon = UIImageView(frame: CGRect(x: 0, y: 0, width: dimen, height: dimen))
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: dimen+6, height: dimen))
        iconContainer.addSubview(self.icon)
        
        self.leftViewMode = .Always
        self.leftView = iconContainer

        let height = frame.size.height
        let width = frame.size.width
        
        let line = UIView(frame: CGRect(x: iconContainer.frame.size.width, y: height-1, width: width-20, height: 1))
        line.backgroundColor = .lightGrayColor()
        self.addSubview(line)
    }
    
 

}

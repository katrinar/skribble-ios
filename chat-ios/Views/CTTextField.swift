//
//  CTTextField.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/16/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTTextField: UITextField {

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont(name: "Heiti SC", size: 18)
        self.autocorrectionType = .No

        let height = frame.size.height
        let width = frame.size.width
        
        let line = UIView(frame: CGRect(x: 0, y: height-1, width: width, height: 1))
        line.backgroundColor = .whiteColor()
        self.addSubview(line)
    }
    
 

}

//
//  CTTableViewCell.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/16/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTTableViewCell: UITableViewCell {
    
    static var cellId = "cellId"
    static var defaultHeight = CGFloat(88)
    var messageLabel: UILabel!
    var dateLabel: UILabel!
    var thumbnail: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let frame = UIScreen.mainScreen().bounds
        
        let padding = CGFloat(12)
        var y = CGFloat(12)
        let thumbDimen = CTTableViewCell.defaultHeight-2*padding
        let x = thumbDimen+2*padding
        let width = frame.size.width-padding-x
        
        
        self.thumbnail = UIImageView(frame: CGRect(x: padding, y: padding, width: thumbDimen, height: thumbDimen))
        self.thumbnail.backgroundColor = .lightGrayColor()
        self.contentView.addSubview(self.thumbnail)
    
        self.dateLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: 22))
        self.dateLabel.backgroundColor = .whiteColor()
        self.dateLabel.font = UIFont(name: "Heiti SC", size: 12)
        self.contentView.addSubview(self.dateLabel)
        y += self.dateLabel.frame.size.height
        
        self.messageLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: 22))
        self.messageLabel.backgroundColor = .whiteColor()
        self.contentView.addSubview(self.messageLabel)
        
//        let line = UIView(frame: CGRect(x: 12, y: 58, width: frame.size.width-24, height: 1))
//        line.backgroundColor = .darkGrayColor()
//        self.addSubview(line)
        
    }
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

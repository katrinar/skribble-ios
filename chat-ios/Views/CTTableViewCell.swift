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
    static var defaultHeight = CGFloat(96)
    static var padding = CGFloat(12)
    var messageLabel: UILabel!
    var dateLabel: UILabel!
    var thumbnail: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        let frame = UIScreen.mainScreen().bounds
        
        var y = CGFloat(12)
        let x = CTTableViewCell.defaultHeight+CTTableViewCell.padding
        let width = frame.size.width-CTTableViewCell.padding-x
        
        
        self.thumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: CTTableViewCell.defaultHeight, height: CTTableViewCell.defaultHeight))
        self.thumbnail.backgroundColor = .lightGrayColor()
        self.contentView.addSubview(self.thumbnail)
    
        self.dateLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: 14))
        self.dateLabel.font = UIFont(name: "Helvetica", size: 12)
        self.dateLabel.textAlignment = .Right
        self.dateLabel.textColor = .lightGrayColor()
        self.contentView.addSubview(self.dateLabel)
        y += self.dateLabel.frame.size.height+2
        
        self.messageLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: 22))
        self.messageLabel.font = UIFont(name: "Helvetica", size: 14)
        self.messageLabel.numberOfLines = 0
//        self.messageLabel.lineBreakMode = .ByWordWrapping
        self.messageLabel.textColor = .darkGrayColor()
        self.messageLabel.addObserver(self, forKeyPath: "text", options: .Initial, context: nil)
        self.contentView.addSubview(self.messageLabel)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
     
        dispatch_async(dispatch_get_main_queue(), {
            if (keyPath != "text"){
                return
            }
            
            var frame = self.messageLabel.frame
            let maxHeight = CTTableViewCell.defaultHeight-frame.origin.y-CTTableViewCell.padding
            
            let str = NSString(string: self.messageLabel.text!)
            let bounds = str.boundingRectWithSize(
                CGSizeMake(frame.size.width, maxHeight),
                options: .UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.messageLabel.font],
                context: nil
            )
            
            frame.size.height = bounds.size.height
            self.messageLabel.frame = frame

        })
        
        
    }

}

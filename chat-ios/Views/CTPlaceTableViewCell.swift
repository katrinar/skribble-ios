//
//  CTPlaceTableViewCell.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 7/8/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTPlaceTableViewCell: UITableViewCell {

    static var cellId = "cellId"
    static var defaultHeight = CGFloat(96)
    static var padding = CGFloat(12)
    var lblTitle: UILabel!
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
        let x = CTPlaceTableViewCell.defaultHeight+CTPlaceTableViewCell.padding
        let width = frame.size.width-CTPlaceTableViewCell.padding-x
        
        
        self.thumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: CTPlaceTableViewCell.defaultHeight, height: CTPlaceTableViewCell.defaultHeight))
        self.thumbnail.backgroundColor = UIColor(patternImage: UIImage(named: "pencil_icon.png")!)
        //        self.thumbnail.backgroundColor = .lightGrayColor()
        self.contentView.addSubview(self.thumbnail)
        
        self.dateLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: 14))
        self.dateLabel.font = UIFont(name: "Helvetica", size: 12)
        self.dateLabel.textAlignment = .Right
        self.dateLabel.textColor = .lightGrayColor()
        self.contentView.addSubview(self.dateLabel)
        y += self.dateLabel.frame.size.height+2
        
        self.lblTitle = UILabel(frame: CGRect(x: x, y: y, width: width, height: 22))
        self.lblTitle.font = UIFont(name: "Helvetica", size: 14)
        self.lblTitle.numberOfLines = 0
        self.lblTitle.textColor = .darkGrayColor()
        self.lblTitle.addObserver(self, forKeyPath: "text", options: .Initial, context: nil)
        self.contentView.addSubview(self.lblTitle)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 1))
        line.backgroundColor = .lightGrayColor()
        self.contentView.addSubview(line)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        dispatch_async(dispatch_get_main_queue(), {
            if (keyPath != "text"){
                return
            }
            
            var frame = self.lblTitle.frame
            let maxHeight = CTPlaceTableViewCell.defaultHeight-frame.origin.y-CTPlaceTableViewCell.padding
            
            let str = NSString(string: self.lblTitle.text!)
            let bounds = str.boundingRectWithSize(
                CGSizeMake(frame.size.width, maxHeight),
                options: .UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.lblTitle.font],
                context: nil
            )
            
            frame.size.height = bounds.size.height
            self.lblTitle.frame = frame
            
        })

    }
}

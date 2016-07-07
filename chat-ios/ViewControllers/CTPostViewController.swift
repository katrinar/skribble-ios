//
//  CTPostViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 7/6/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTPostViewController: CTViewController, UIScrollViewDelegate {
    
    var post: CTPost!
    var postImage: UIImageView!
    var scrollview: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.edgesForExtendedLayout = .None
    }

    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .whiteColor()
        
        self.postImage = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.width))
        self.postImage.alpha = 0
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        let blk = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        layer.colors = [blk.CGColor, UIColor.clearColor().CGColor]
        self.postImage.layer.addSublayer(layer)
        
        view.addSubview(self.postImage)
        
        let bgText = UIView(frame: CGRect(x: 0, y: 250, width: frame.size.width, height: frame.size.height))
        bgText.backgroundColor = .whiteColor()
        
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let font = UIFont(name: "Heiti SC", size: 14)
        
        let lblPlace = UILabel(frame: CGRect(x: padding, y: padding, width: width, height: 24))
        lblPlace.textColor = .darkGrayColor()
        lblPlace.font = UIFont.boldSystemFontOfSize(24)
        lblPlace.text = self.post.place["name"] as? String
        bgText.addSubview(lblPlace)
        
        var y = padding+lblPlace.frame.size.height
        
        let lblUsername = UILabel(frame: CGRect(x: padding, y: y, width: width, height: 18))
        lblUsername.font = font
        lblUsername.textColor = .darkGrayColor()
        lblUsername.text = self.post.from["username"] as? String
        bgText.addSubview(lblUsername)
        
        y += lblUsername.frame.size.height
        
        let lblDate = UILabel(frame: CGRect(x: padding, y: y, width: width, height: 18))
        lblDate.textColor = .darkGrayColor()
        lblDate.font = font
        lblDate.text = self.post.formattedDate
        bgText.addSubview(lblDate)
        
        y += lblDate.frame.size.height+padding
        
        let line = UIView(frame: CGRect(x: 0, y: y, width: frame.size.width, height: 0.5))
        line.backgroundColor = .lightGrayColor()
        bgText.addSubview(line)
        
        y += padding
        
        let str = NSString(string: self.post.message)
        let bounds = str.boundingRectWithSize(
            CGSizeMake(width, 1000),
            options: .UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font!],
            context: nil
        )
        
        let lblText = UILabel(frame: CGRect(x: padding, y: y, width: width, height: bounds.size.height))
        lblText.font = font
        lblText.numberOfLines = 0
        lblText.lineBreakMode = .ByWordWrapping
        lblText.text = self.post.message
        lblText.textColor = .darkGrayColor()
        bgText.addSubview(lblText)

        self.scrollview = UIScrollView(frame: frame)
        self.scrollview.delegate = self
        self.scrollview.showsVerticalScrollIndicator = false
        self.scrollview.backgroundColor = .clearColor()
       
        self.scrollview.addSubview(bgText)
        var contentHeight = bgText.frame.origin.y+lblText.frame.origin.y+bounds.size.height+padding+64
        
        // enforce minimun height for scroll-ability
        if (contentHeight < frame.size.height){
            contentHeight = frame.size.height+100
        }
        self.scrollview.contentSize = CGSizeMake(0, contentHeight)

        view.addSubview(self.scrollview)        
  
        self.view = view

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //no image, ignore
        if (self.post.imageUrl.characters.count == 0){
            return
        }
        
        // image already fetched
        if (self.post.imageData != nil){
            self.postImage.alpha = 1
            self.postImage.image = self.post.imageData
            self.postImage.frame = self.resizeFrame(self.postImage.frame, image: self.post.imageData!)

            return
        }
        
        //fetch image
        
        self.post.fetchImage({ image in
            dispatch_async(dispatch_get_main_queue(),{

                self.postImage.frame = self.resizeFrame(self.postImage.frame, image: image)
                self.postImage.image = image
                UIView.animateWithDuration(
                    0.3,
                    animations: {
                        self.postImage.alpha = 1
                })
            })
        })
    }
    
    func resizeFrame(frame: CGRect, image: UIImage) -> CGRect{
        
        let width = frame.size.width
        let scale = width/image.size.width
        let height = scale*image.size.height
        
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }
    
    //MARK: -- ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollViewDidScroll: \(scrollview.contentOffset.y)")
    
        
        if (scrollview.contentOffset.y > 0){
            self.postImage.transform = CGAffineTransformIdentity
            
            //span 0 to 250
            var frame = self.postImage.frame
            let offset = -0.4*scrollView.contentOffset.y
            frame.origin.y = offset
            self.postImage.frame = frame
            
            return
        }
        
        let delta = -scrollview.contentOffset.y //convert to positive
        
        // span 0 to 80
        
        let scale = 1+(delta/80)
        print("Trans: \(scale)")
        
        self.postImage.transform = CGAffineTransformMakeScale(scale, scale)

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if (keyPath == "imageData"){
                self.post.removeObserver(self, forKeyPath: keyPath!)
                self.postImage.image = self.post.imageData!
                self.postImage.backgroundColor = .greenColor()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

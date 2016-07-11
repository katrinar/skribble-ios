//
//  CTCreatePlaceViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/14/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit

class CTCreatePlaceViewController: CTViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedImage: UIImage?
    var placeImageView: UIImageView!
    var backgroundView: UIImageView!
    
    var placeInfo = Dictionary<String, AnyObject>()

    
    var textFields = Array<UITextField>()
    var statePicker: UIPickerView!
    var states =  [ "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY" ]
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.lightGrayColor()
        
        let btnCancel = UIButton(type: .Custom)
        btnCancel.frame = CGRect(x: 20, y: 20, width: 100, height: 32)
        btnCancel.setTitle("Cancel", forState: .Normal)
        btnCancel.setTitleColor(.whiteColor(), forState: .Normal)
        btnCancel.addTarget(self,
                            action: #selector(CTViewController.exit),
                            forControlEvents: .TouchUpInside)
        view.addSubview(btnCancel)
        
        let padding = CGFloat(Constants.padding)
        let width = frame.size.width-2*padding
        let height = CGFloat(32)
        var y = CGFloat(Constants.origin_y)
        
        self.placeImageView = UIImageView(frame: CGRect(x: padding, y: padding, width: 44, height: 44))
        self.placeImageView.center = CGPointMake(0.5*frame.size.width, self.placeImageView.center.y)
        self.placeImageView.alpha = 0
        view.addSubview(self.placeImageView)
        
        let fieldNames = ["Name", "Address", "City", "State", "Password"]
        for fieldName in fieldNames {
            
            let field = CTTextField(frame: CGRect(x: padding, y: y, width: width, height: height))
            field.delegate = self
            field.placeholder = fieldName

            let isPassword = (fieldName == "Password")
            field.secureTextEntry = (isPassword)
            field.returnKeyType = (isPassword) ? .Join : .Next
            view.addSubview(field)
            
            self.textFields.append(field)
            y += height+padding
        }
        
        self.statePicker = UIPickerView(frame: CGRect(x: 0, y: frame.size.height, width: frame.size.width, height: 160))
        self.statePicker.backgroundColor = .whiteColor()
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        view.addSubview(statePicker)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - PickerViewDelegate and Datasource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
  
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.states.count
    }
    
  
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.states[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("didSelectRow \(row)")
        for textField in self.textFields{
            if (textField.placeholder == "State"){
                textField.text = self.states[row]
                UIView.animateWithDuration(0.35,
                                           animations: {
                                            var frame = self.statePicker.frame
                                            frame.origin.y = self.view.frame.size.height
                                            self.statePicker.frame = frame
                    }, completion: nil)
                
                let index = self.textFields.indexOf(textField)!
                let nextField = self.textFields[index+1]
                nextField.becomeFirstResponder()
                break
            }
        }
    }
    
    //MARK: - UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        print("didFinishPickingMediaWithInfo: \(info)")
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImage = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: {
            UIView.transitionWithView(
                self.placeImageView,
                duration: 0.3,
                options: UIViewAnimationOptions.TransitionFlipFromLeft,
                animations: {
                    self.placeImageView.image = self.selectedImage
                    self.placeImageView.alpha = 1.0
                },
                completion: { finished in
                    self.createPlace(self.placeInfo)
                    
            })
        })
    }

    //MARK: - Custom Functions
    
    func dismissKeyboard(){
        for textField in self.textFields {
            if (textField.isFirstResponder()){
                textField.resignFirstResponder()
                break
            }
        }
    }
    
    //MARK: - TextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let placeholder = textField.placeholder!.lowercaseString
        print("textFieldShouldBeginEditing: \(placeholder)")
        if (placeholder == "state"){
            
            self.dismissKeyboard()
            
            UIView.animateWithDuration(0.35,
                                       animations: {
                                        var frame = self.statePicker.frame
                                        frame.origin.y = self.view.frame.size.height-frame.size.height
                                        self.statePicker.frame = frame
                },
                                       completion: nil)
           
          return false
        }
        
        return true
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let index = self.textFields.indexOf(textField)!
        print("textFieldShouldReturn: \(index)")
        
        if (index == self.textFields.count-1){ //password field, register
            var missingValue = ""
            
            for textField in self.textFields {
                if (textField.text?.characters.count == 0){
                    missingValue = textField.placeholder!
                    break
                }
                
                self.placeInfo[textField.placeholder!.lowercaseString] = textField.text!
            }
            
            //Incomplete:
            if (missingValue.characters.count > 0){
                print("MISSING VALUE")
                let msg = "You forgot the "+missingValue
                let alert = UIAlertController(title: "Missing Value",
                                              message: msg,
                                              preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return true
            }
            
            self.placeInfo["admins"] = [CTViewController.currentUser.id!]
            print("\(self.placeInfo)")
            
            //ask if user wants to include picture
            let alert = UIAlertController(
                title: "Picture?",
                message: "would you like to include a picture?",
                preferredStyle: .Alert
            )
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
                print("Add Picture")
                
                // show image options
                textField.resignFirstResponder()
                let action = self.showCameraOptions()
                
                self.presentViewController(action, animated: true, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { action in
                print("No Picture")
                textField.resignFirstResponder()
                self.createPlace(self.placeInfo)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return true
        }
        let nextField = self.textFields[index+1]
        nextField.becomeFirstResponder()
        
        return true
    }
    
    func createPlace(placeInfo: Dictionary<String, AnyObject>){
        
        //check if there's an image first:
        if (self.selectedImage == nil){
            APIManager.postRequest("/api/place",
                                   params: placeInfo,
                                   completion: { error, response in
                                    
                                   print("\(response)")
                                    
                                    if let result = response!["result"] as? Dictionary<String, AnyObject>{
                                        let place = CTPlace()
                                        place.populate(result)
                                        
                                        let notification = NSNotification(
                                            name: Constants.kPlaceCreatedNotification,
                                            object: nil,
                                            userInfo: ["place":place]
                                        )
                                        
                                        let notificationCenter = NSNotificationCenter.defaultCenter()
                                        notificationCenter.postNotification(notification)
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                        
                                    }
            })
            
            return
        }
        //upload image
        self.uploadImage(self.selectedImage!, completion: { imageInfo in
            self.selectedImage = nil // nil it out to prevent infinite loop
            self.placeInfo["image"] = imageInfo
            self.createPlace(self.placeInfo)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

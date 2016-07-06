//
//  CTMapViewController.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CTMapViewController: CTViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK: - Properties
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var places = Array<CTPlace>()
    var btnCreatePlace: UIButton!
    var currentLocation: CLLocation?
    var darkOverlay: UIView!
    var selectedPlace: CTPlace?
    var passwordField: UITextField!
    
    //MARK: - Lifecycle Methods
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.edgesForExtendedLayout = .None
        self.title = ""
        self.tabBarItem.title = "Map"
        self.tabBarItem.image = UIImage(named: "globe_icon.png")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(CTMapViewController.placeCreated(_:)),
                                       name: Constants.kPlaceCreatedNotification,
                                       object: nil)
        
    }

    override func loadView() {
        
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = .redColor()
 
        self.mapView = MKMapView(frame: frame)
        self.mapView.delegate = self
        
        view.addSubview(mapView)
        let padding = CGFloat(Constants.padding)
        let height = CGFloat(44)
        
        self.btnCreatePlace = CTButton(frame: CGRect(x: padding, y: -height, width: frame.size.width-2*padding, height: height))
        self.btnCreatePlace.setTitle("Create Place", forState: .Normal)
        self.btnCreatePlace.addTarget(
            self,
            action: #selector(CTMapViewController.createPlace),
            forControlEvents: .TouchUpInside
        )

        self.btnCreatePlace.alpha = 0 //initially hidden
        view.addSubview(self.btnCreatePlace)
        
        self.darkOverlay = UIView(frame: frame)
        self.darkOverlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        var y = padding
        
        let btnCancel = UIButton(frame: CGRect(x: 20, y: 20, width: 44, height: 44))
//        btnCancel.backgroundColor = .redColor()
        btnCancel.setImage(UIImage(named: "cancel_icon.png"), forState: .Normal)
        btnCancel.addTarget(
            self,
            action: #selector(CTMapViewController.dismissOverlay),
            forControlEvents: .TouchUpInside
        )
        y += btnCancel.frame.size.height+60
        
//        let passwordLabel = UILabel(frame: CGRect(x: padding, y: 100, width: frame.size.width-2*padding, height: 24))
//        passwordLabel.backgroundColor = .redColor()
//        self.darkOverlay.addSubview(passwordLabel)
        
        self.passwordField = CTTextField(frame: CGRect(x: 20, y: 100, width: frame.size.width-40, height: 24))
        self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.darkOverlay.addSubview(passwordField)
        y += passwordField.frame.size.height+padding
        
        let btnEnter = CTButton(frame: CGRect(x: padding, y: y, width: frame.size.width-2*padding, height: 44))
        btnEnter.setTitle("Enter", forState: .Normal)
        btnEnter.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1.0)
        btnEnter.addTarget(
            self,
            action: #selector(CTMapViewController.enterSelectedPlace),
            forControlEvents: .TouchUpInside
        )
        self.darkOverlay.addSubview(btnEnter)

            
        self.darkOverlay.alpha = 0.0
        self.darkOverlay.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(CTMapViewController.dismissOverlay)
            ))
        self.darkOverlay.addSubview(btnCancel)
        
        view.addSubview(self.darkOverlay)
        
     

        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)

        if(CTMapViewController.currentUser.id == nil){
            return
        }
        
        if (self.btnCreatePlace.alpha == 1){
            return
        }

        self.showCreateButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissOverlay()
        self.passwordField.text = ""
    }
    
    //MARK: - Custom Functions
    
    func placeCreated(notification: NSNotification){
        if let place = notification.userInfo!["place"] as? CTPlace {
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(place)
                let ctr = CLLocationCoordinate2DMake(place.lat, place.lng)
                
                //check distance
                let coord = CLLocation(latitude: place.lat, longitude: place.lng)
                let mapCenter = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
                let delta = mapCenter.distanceFromLocation(coord)
                print("Delta == \(delta)")
                if(delta < 750){ //not far enough, ignore
                    return
                }
                
                self.mapView.setCenterCoordinate(ctr, animated: true)
            })
            
        }
        
    }
    
    override func userLoggedIn(notification: NSNotification){
        
        super.userLoggedIn(notification)

        if(CTMapViewController.currentUser.id == nil) {
            return
        }
 
        print("CTMapViewController: userLoggedIn")
        if(self.view.window == nil){ //not on screen, ignore
            return
        }
        self.showCreateButton()
    }
    
    func dismissOverlay(){
        self.passwordField.resignFirstResponder()
        
        UIView.animateWithDuration(
            0.35,
            animations: {
                self.darkOverlay.alpha = 0.0
        })
    }
    
    func showDarkOverlay(){
        UIView.animateWithDuration(
            0.35,
            animations: {
                self.darkOverlay.alpha=1.0
        })
    }
    
    func enterSelectedPlace(){
        
        self.passwordField.resignFirstResponder()
        
        if (CTViewController.currentUser.id != nil){
            //user is an admin of place, do not need password

           let isAdmin = self.selectedPlace?.admins.contains(CTViewController.currentUser.id!)
            
            
            if (isAdmin == true){
                let chatVc = CTChatViewController()
                chatVc.place = self.selectedPlace
                self.navigationController?.pushViewController(chatVc, animated: true)
                return
            }
        }
        
       
        
        if (self.selectedPlace?.visited == true || self.passwordField.text == self.selectedPlace?.password){
            let chatVc = CTChatViewController()
            chatVc.place = self.selectedPlace
            self.navigationController?.pushViewController(chatVc, animated: true)
            return
        }
        
        if (self.passwordField.text != self.selectedPlace?.password){
            
            let alert = UIAlertController(
                title: "Wrong Password",
                message: "Please Try Again Later",
                preferredStyle: .Alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let chatVc = CTChatViewController()
        chatVc.place = self.selectedPlace
        self.navigationController?.pushViewController(chatVc, animated: true)
    }
  
    func showCreateButton(){
        self.btnCreatePlace.alpha = 1
        UIView.animateWithDuration(1.25,
                                   
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    var frame = self.btnCreatePlace.frame
                                    frame.origin.y = 20
                                    self.btnCreatePlace.frame = frame
            }, completion: nil)
  
    }

    func createPlace(){
        print("CreatePlace: ")
        let createPlaceVc = CTCreatePlaceViewController()
        self.presentViewController(createPlaceVc, animated: true, completion: nil)
    }
    
    func searchPlaces(lat: CLLocationDegrees, lng: CLLocationDegrees){

        //MAKE API REQUEST TO OUR BACKEND:
        
       var params = Dictionary<String, AnyObject>()
        params["lat"] = lat
        params["lng"] = lng
        params["key"] = "123" //temporary key for testing
        
        APIManager.getRequest("/api/place", params: params, completion: { response in
            
            print("\(response)")

            if let results = response["results"] as? Array<Dictionary<String, AnyObject>>{
                
                self.mapView.removeAnnotations(self.places)
                self.places.removeAll()
                for placeInfo in results {
                    let place = CTPlace()
                    place.populate(placeInfo)
                    self.places.append(place)
                    
                }

                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.mapView.addAnnotations(self.places)
                    
                })
            }
 
        })
  
    }
    
    //MARK: - MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinId = "pinId"
        
        if let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(pinId) as? MKPinAnnotationView {
            pin.annotation = annotation
            return pin
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        
        return pin
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        print("regionDidChangeAnimated: \(mapView.centerCoordinate.latitude), \(mapView.centerCoordinate.longitude)")

        // First time, always run:
        
        if(self.currentLocation == nil){
            self.searchPlaces(mapView.centerCoordinate.latitude, lng: mapView.centerCoordinate.longitude)
            return
            
        }
        
        let mapCenter = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let delta = mapCenter.distanceFromLocation(self.currentLocation!)
        if(delta < 750){ //not far enough, ignore
            return
            
        }
        
        print("DELTA == \(delta)")
        self.currentLocation = mapCenter
        self.searchPlaces(mapView.centerCoordinate.latitude, lng: mapView.centerCoordinate.longitude)
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.selectedPlace = view.annotation as? CTPlace
        
        // user previously entered, do not enforce password again:
        if (self.selectedPlace?.visited == true){
            self.enterSelectedPlace()
            return
        }
        
        // user has to enter password
        if (CTViewController.currentUser.id == nil){
            self.showDarkOverlay()
            return
        }
        
        
            //user is an admin of place, do not need password
            
        let isAdmin = self.selectedPlace?.admins.contains(CTViewController.currentUser.id!)
            
            
        if (isAdmin == false){ //user has to enter password
            self.showDarkOverlay()
            return
        }
        
        // user is an admin of place, do not need password:
        let chatVc = CTChatViewController()
        chatVc.place = self.selectedPlace
        self.navigationController?.pushViewController(chatVc, animated: true)

    }
    
    // MARK: LocationManagerDelegate
 
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if (status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        print("didUpdateLocations: \(locations)")
        
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = locations[0]
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.currentLocation!.coordinate.latitude, self.currentLocation!.coordinate.longitude)
 
        let dist = CLLocationDistance(500)
        let region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, dist, dist)
        self.mapView.setRegion(region, animated: true)
        
        //MAKE API REQUEST TO OUR BACKEND:
        
        self.searchPlaces(self.currentLocation!.coordinate.latitude, lng: self.currentLocation!.coordinate.longitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
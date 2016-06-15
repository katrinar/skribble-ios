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
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var places = Array<CTPlace>()
    var btncreatePlace: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Map"
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
        view.addSubview(mapView)
        
        let padding = CGFloat(20)
        let height = CGFloat(44)
        
        self.btncreatePlace = CTButton(frame: CGRect(x: padding, y: -height, width: frame.size.width-2*padding, height: height))
        self.btncreatePlace.setTitle("Create Place", forState: .Normal)
        self.btncreatePlace.addTarget(self,
                                      action: #selector(CTMapViewController.createPlace),
                                      forControlEvents: .TouchUpInside)
        self.btncreatePlace.alpha = 0 //initially hidden
        view.addSubview(self.btncreatePlace)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (CTMapViewController.currentUser.id == nil){
            return
        }
        
        if (self.btncreatePlace.alpha == 1){
            return
        }
        
        self.showCreateButton()
        
    }
    
    func placeCreated(notification: NSNotification){
        if let place = notification.userInfo!["place"] as? CTPlace {
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(place)
                
                let ctr = CLLocationCoordinate2DMake(place.lat, place.lng)
                self.mapView.setCenterCoordinate(ctr, animated: true)
            })
        }
    }
    
    func createPlace(){
        print("createPlace")
        let createPlaceVc = CTCreatePlaceViewController()
        self.presentViewController(createPlaceVc, animated: true, completion: nil)
    }
    
    //MARK: - userLoggedIn Notification
    override func userLoggedIn(notification: NSNotification){
        super.userLoggedIn(notification)
        
//        let isVisible = (self.view.window == nil) ? false : true
        
        if (CTMapViewController.currentUser.id == nil){
            return
        }
        
        print("CTMapViewController: userLoggedIn")

        if (self.view.window == nil){ //not on screen, ignore
            return
        }
        self.showCreateButton()
//        self.btncreatePlace.alpha = 1
//        UIView.animateWithDuration(1.25,
//                                   delay: 0,
//                                   usingSpringWithDamping: 0.5,
//                                   initialSpringVelocity: 0,
//                                   options: UIViewAnimationOptions.CurveEaseInOut,
//                                   animations: {
//                                    var frame = self.btncreatePlace.frame
//                                    frame.origin.y = 20
//                                    self.btncreatePlace.frame = frame
//                                    
//            }, completion: nil)

    }
    
    func showCreateButton(){
        self.btncreatePlace.alpha = 1
        UIView.animateWithDuration(1.25,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    var frame = self.btncreatePlace.frame
                                    frame.origin.y = 20
                                    self.btncreatePlace.frame = frame
                                    
            }, completion: nil)

    }
    
    //MARK: - MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pinId"
        if let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(pinId) as? MKPinAnnotationView{
            pin.annotation = annotation
            return pin

        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
        pin.animatesDrop = true
        pin.canShowCallout = true
        return pin
    }
    
    //MARK: - LocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if (status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("didUpdateLocations: \(locations)")
        self.locationManager.stopUpdatingLocation()
        let currentLocation = locations[0]
        
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        
        let dist = CLLocationDistance(500)
        let region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, dist, dist)
        self.mapView.setRegion(region, animated: true)
        
        //MAKE API REQUEST TO OUR BACKEND:
        let url = "/api/place"
        
        let params = [
            "lat": currentLocation.coordinate.latitude,
            "lng": currentLocation.coordinate.longitude
        ]
        
        
        APIManager.getRequest(url, params: params, completion: { response in
            print("\(response)")
            
            if let results = response["results"] as? Array<Dictionary<String, AnyObject>>{
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

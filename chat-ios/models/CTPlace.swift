//
//  CTPlace.swift
//  chat-ios
//
//  Created by Katrina Rodriguez on 6/7/16.
//  Copyright © 2016 Kat. All rights reserved.
//

import UIKit
import MapKit

class CTPlace: NSObject, MKAnnotation {
    
    var id: String!
    var name: String!
    var city: String!
    var state: String!
    var address: String!
    var password: String!
    var admins: Array<String>!
    var image: Dictionary<String, AnyObject>!
    var zip: String!
    var lat: Double!
    var lng: Double!
    var visited = false
    
    func populate(placeInfo: Dictionary<String, AnyObject>){
        
        let keys = ["name", "city", "state", "address", "zip", "id", "password", "admins", "image"]
        for key in keys {
            let value = placeInfo[key]
            self.setValue(value, forKey: key)
        }
        
        if let _geo = placeInfo["geo"] as? Array<Double> {
            self.lat = _geo[0]
            self.lng = _geo[1]
        }
    }
    
        // MARK: - MKAnnotation Overrides
        var title: String? {
            return self.name
        }
        
        var subtitle: String? {
            return self.address
        }
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2DMake(self.lat, self.lng)
        }
}


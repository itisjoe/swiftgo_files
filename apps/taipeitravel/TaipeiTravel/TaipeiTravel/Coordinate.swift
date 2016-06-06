//
//  Coordinate.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/6.
//  Copyright © 2016年 hsin. All rights reserved.
//

import Foundation
import CoreLocation


struct Coordinate {
    var index: Int
    var latitude: Double
    var longitude: Double
}

extension Coordinate: Comparable {}

func ==(a: Coordinate, b: Coordinate) -> Bool {
    let myUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // 是否取得定位權限
    let locationAuth = myUserDefaults.objectForKey("locationAuth") as? Bool
    
    if locationAuth != nil && locationAuth! {
        // 取得目前使用者座標
        let userLatitude = myUserDefaults.objectForKey("userLatitude") as? Double
        let userLongitude = myUserDefaults.objectForKey("userLongitude") as? Double
        let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
        
        // 兩點的座標
        let aLocation = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let bLocation = CLLocation(latitude: b.latitude, longitude: b.longitude)

        return aLocation.distanceFromLocation(userLocation) == bLocation.distanceFromLocation(userLocation)
    } else {
        return a.index == b.index
    }

}

func <(a: Coordinate, b: Coordinate) -> Bool {
    let myUserDefaults = NSUserDefaults.standardUserDefaults()

    // 是否取得定位權限
    let locationAuth = myUserDefaults.objectForKey("locationAuth") as? Bool

    if locationAuth != nil && locationAuth! {
        // 取得目前使用者座標
        let userLatitude = myUserDefaults.objectForKey("userLatitude") as? Double
        let userLongitude = myUserDefaults.objectForKey("userLongitude") as? Double
        let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
        
        // 兩點的座標
        let aLocation = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let bLocation = CLLocation(latitude: b.latitude, longitude: b.longitude)
        
        return aLocation.distanceFromLocation(userLocation) < bLocation.distanceFromLocation(userLocation)
    } else {
        return a.index < b.index
    }
}

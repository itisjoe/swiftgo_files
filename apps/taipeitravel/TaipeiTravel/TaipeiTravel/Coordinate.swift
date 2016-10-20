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
    let myUserDefaults = UserDefaults.standard
    
    // 是否取得定位權限
    let locationAuth = myUserDefaults.object(forKey: "locationAuth") as? Bool
    
    if locationAuth != nil && locationAuth! {
        // 取得目前使用者座標
        let userLatitude = myUserDefaults.object(forKey: "userLatitude") as? Double
        let userLongitude = myUserDefaults.object(forKey: "userLongitude") as? Double
        let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
        
        // 兩點的座標
        let aLocation = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let bLocation = CLLocation(latitude: b.latitude, longitude: b.longitude)

        return aLocation.distance(from: userLocation) == bLocation.distance(from: userLocation)
    } else {
        return a.index == b.index
    }

}

func <(a: Coordinate, b: Coordinate) -> Bool {
    let myUserDefaults = UserDefaults.standard

    // 是否取得定位權限
    let locationAuth = myUserDefaults.object(forKey: "locationAuth") as? Bool

    if locationAuth != nil && locationAuth! {
        // 取得目前使用者座標
        let userLatitude = myUserDefaults.object(forKey: "userLatitude") as? Double
        let userLongitude = myUserDefaults.object(forKey: "userLongitude") as? Double
        let userLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
        
        // 兩點的座標
        let aLocation = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let bLocation = CLLocation(latitude: b.latitude, longitude: b.longitude)
        
        return aLocation.distance(from: userLocation) < bLocation.distance(from: userLocation)
    } else {
        return a.index < b.index
    }
}

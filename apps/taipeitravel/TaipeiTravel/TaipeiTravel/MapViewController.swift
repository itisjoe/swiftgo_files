//
//  MapViewController.swift
//  TaipeiTravel
//
//  Created by joe feng on 2016/6/7.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    let fullSize :CGSize = UIScreen.main.bounds.size
    let myUserDefaults :UserDefaults = UserDefaults.standard
    var fetchType :String = ""
    var info :[String:AnyObject]! = nil
    var latitude :Double = 0.0
    var longitude :Double = 0.0
    var myMapView :MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 樣式
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        latitude = info["latitude"] as? Double ?? 0.0
        longitude = info["longitude"] as? Double ?? 0.0
        
        self.title = info["title"] as? String ?? "標題"
        
        // 建立一個 MKMapView
        myMapView = MKMapView(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height - 113))
        
        // 設置委任對象
        myMapView.delegate = self
        
        // 地圖樣式
        myMapView.mapType = .standard
        
        // 顯示自身定位位置
        myMapView.showsUserLocation = true
        
        // 允許縮放地圖
        myMapView.isZoomEnabled = true
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.005
        let longDelta = 0.005
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // 設置地圖顯示的範圍與中心點座標
        let center:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        myMapView.setRegion(currentRegion, animated: true)
        
        // 加入到畫面中
        self.view.addSubview(myMapView)
        
        // 建立一個地點圖示 (圖示預設為紅色大頭針)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: latitude, longitude: longitude).coordinate
        objectAnnotation.title = self.title
        myMapView.addAnnotation(objectAnnotation)
        
    }

}

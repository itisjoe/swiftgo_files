//
//  ViewController.swift
//  ExMap
//
//  Created by joe feng on 2016/6/2.
//  Copyright © 2016年 hsin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var myLocationManager :CLLocationManager!
    var myMapView :MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        
        // 設置委任對象
        myLocationManager.delegate = self
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest

        
        
        // 取得螢幕的尺寸
        let fullSize = UIScreen.main.bounds.size

        // 建立一個 MKMapView
        myMapView = MKMapView(frame: CGRect(x: 0, y: 20, width: fullSize.width, height: fullSize.height - 20))
        
        // 設置委任對象
        myMapView.delegate = self

        // 地圖樣式
        myMapView.mapType = .standard

        // 顯示自身定位位置
        myMapView.showsUserLocation = true
        
        // 允許縮放地圖
        myMapView.isZoomEnabled = true
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // 設置地圖顯示的範圍與中心點座標
        let center:CLLocation = CLLocation(latitude: 25.05, longitude: 121.515)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        myMapView.setRegion(currentRegion, animated: true)
        
        // 加入到畫面中
        self.view.addSubview(myMapView)
        
        // 建立一個地點圖示 (圖示預設為紅色大頭針)
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: 25.036798, longitude: 121.499962).coordinate
        objectAnnotation.title = "艋舺公園"
        objectAnnotation.subtitle = "艋舺公園位於龍山寺旁邊，原名為「萬華十二號公園」。"
        myMapView.addAnnotation(objectAnnotation)
        
        // 建立另一個地點圖示 (經由委任方法設置圖示)
        objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: 25.063059, longitude: 121.533838).coordinate
        objectAnnotation.title = "行天宮"
        objectAnnotation.subtitle = "行天宮是北臺灣參訪香客最多的廟宇。"
        myMapView.addAnnotation(objectAnnotation)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()

            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
        // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController( title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present( alertController, animated: true, completion: nil)
        }
        // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
    }

// MARK: MKMapViewDelegate Methods
    
    //自定義大頭針樣式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // 建立可重複使用的 MKAnnotationView
            let reuseId = "MyPin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                // 建立一個地圖圖示視圖
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                // 設置點擊地圖圖示後額外的視圖
                pinView?.canShowCallout = false
                // 設置自訂圖示
                pinView?.image = UIImage(named:"user")
            } else {
                pinView?.annotation = annotation
            }
            
            return pinView
        } else {

            // 其中一個地點使用預設的圖示
            // 這邊比對到座標時就使用預設樣式 不再額外設置
            if annotation.coordinate.latitude == 25.036798 && annotation.coordinate.longitude == 121.499962 {
                return nil
            }
            
            // 建立可重複使用的 MKPinAnnotationView
            let reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                // 建立一個大頭針視圖
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                // 設置點擊大頭針後額外的視圖
                pinView?.canShowCallout = true
                // 會以落下釘在地圖上的方式出現
                pinView?.animatesDrop = true
                // 大頭針的顏色
                pinView?.pinTintColor = UIColor.blue
                // 這邊將額外視圖的右邊視圖設為一個按鈕
                pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                pinView?.annotation = annotation
            }

            return pinView
        }

    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("地圖縮放或滑動時")
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("載入地圖完成時")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("點擊大頭針的說明")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("點擊大頭針")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("取消點擊大頭針")
    }

// MARK: CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation :CLLocation = locations[0] as CLLocation
        print("\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")

    }


}


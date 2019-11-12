//
//  MapViewController.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 17/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    //@objc optional - не обязательный метод для протокола
    func getAddress(_ address: String?)
}
// если в extension для protocol объявлять методы, то они автоматом будут не обязательными
extension MapViewControllerDelegate{
    
}

class MapViewController: UIViewController {
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    var annotationIdentifier = "annotationIdentifier"
    var incomeSegueIdentifier = ""
    
    
    var preLocation: CLLocation?{ // для постоянного мониторинге местоположения пользователя
        didSet{
            mapManager.startTrackingUserLocation(for: mapView,
                                                 and: preLocation) { (currentLocation) in
                                                    self.preLocation = currentLocation
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        self.mapManager.showUserLocation(mapView: self.mapView)
                                                    }
            }
        }
    }
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        
        mapView.delegate = self
        setupMapView()
    }
    
    // для отображения геолокации пользователя
    @IBAction func centreViewInUserLocation(_ sender: Any) { // определяет и приближает к точке геопозиции
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        mapManager.getDirection(for: mapView) { (location) in
            self.preLocation = location
        }
    }
    // кнопка добаления адреса
    @IBAction func doneButtonPressed(_ sender: Any) {
        mapViewControllerDelegate?.getAddress(addressLabel.text) // передаем данный в протокол
        dismiss(animated: true) // закрываем карту
    }
    
    // настройки для карты
    private func setupMapView(){
        goButton.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifire: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == "showPlace"{
            mapManager.setupPlaceMark(place: place, mapView: mapView)
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    // для определения геолокации пользователя
    private func setupLocationManager(){
        mapManager.locationManager.delegate = self // метода данного протокола будет выполнять setupLocationManager
        mapManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension MapViewController: MKMapViewDelegate{
    
    // метод создаем банер когда получаем местоположение кафе
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // если определена позиция не пользователя
        guard !(annotation is MKUserLocation) else {return nil}
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10 // округляем изображение
            imageView.clipsToBounds = true // обрезаем по границк
            imageView.image = UIImage(data: imageData) // получаем изображение
            annotationView?.rightCalloutAccessoryView = imageView // помещаем его вправа
            
            
        }
        return annotationView
    }
    
    // вызывается каждый раз при смене отображаемого региона
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showPlace" && preLocation != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: mapView)
            }
        }
        geocoder.cancelGeocode() // для освобождения резурсов связаных с геокодированием
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error{
                print("mapView -> ", error)
                return
            }
            guard let placemarks = placemarks else{return} // получаем массив меток
            let plasmark = placemarks.first // выбираем первую метку
            let streetName = plasmark?.thoroughfare // название улици
            let buildNumber = plasmark?.subThoroughfare // номер дома
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil{
                    self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                }else if streetName != nil{
                    self.addressLabel.text = "\(streetName!)"
                }else{
                    self.addressLabel.text = ""
                }
                
            }
            
            
        }
    }
    

    

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
    

    

    
}

// для мониторига разрешения пользоваелем пользоваться его геоданными
extension MapViewController: CLLocationManagerDelegate{
    // вызавается в случае любого изменения статусаы
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapManager.checkLocatitionAutorization(mapView: mapView, segueIdentifire: incomeSegueIdentifier)
    }
}


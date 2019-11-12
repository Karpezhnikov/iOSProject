//
//  MapManager.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 21/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import MapKit

class MapManager{
    let locationManager = CLLocationManager() // отвечает за настройку и управления служб геолокации
    private let regionInMetters = 1_000.00 // масштаб приближение к геопозиции
    private var diractionsArray: [MKDirections] = [] // для записи старых маршрутов
    private var placeCoordinate: CLLocationCoordinate2D?
    
    // для установки координаты
    func setupPlaceMark(place: Place, mapView: MKMapView){
        guard let location = place.location else {return}
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error{
                print("ERROR-->", error)
                return
            }
            guard let placemarks = placemarks else{return}
            let placemark = placemarks.first!
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type

            guard let placemarkLocation = placemark.location else{return}
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // для определения разрешения пользователя на определение геолокации
    func checkLocationServices(mapView: MKMapView, segueIdentifire: String, closure: ()->()){
        if CLLocationManager.locationServicesEnabled(){ // если службы геолокации доступны
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocatitionAutorization(mapView: mapView, segueIdentifire: segueIdentifire)
            closure()
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
                self.alertController(title: "Геолокация", massege: "Откройте доступ к службам геолокации: Настройки -> Приватные -> Служба геолокации")
                print("Not GEO")
            }
        }
    }
    
    // для получание права использовать геолокацию
    func checkLocatitionAutorization(mapView: MKMapView, segueIdentifire: String){
        switch CLLocationManager.authorizationStatus() { // получаем статус по разрешению получать геолокацию
        case .authorizedWhenInUse: // статус возвращается если разрешено использовать во время использования приложения
            if segueIdentifire == "getAddress"{showUserLocation(mapView: mapView)}
            mapView.showsUserLocation = true // то будем отображать на карте локацию пользователя
            break
        case .denied: // если приложению не разрешено пользоваться геолокацией
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.alertController(title: "Геолокация",
                                massege: "Откройте доступ к службам геолокации: Настройки -> Приватные -> Служба геолокации")
            }
            break
        case .notDetermined: // статус не определено
            locationManager.requestWhenInUseAuthorization() // вызываем окно с разрешением на использование
            break
        case .restricted: // если преложение не авторизовано для служб геолокации
            alertController(title: "Геолокация", massege: "Откройте доступ к службам геолокации: Настройки -> Приватные -> Служба геолокации")
            break
        case .authorizedAlways: //если проложение разрешено постоянно использовать геолокацию
            break
        @unknown default: // если в будущем в перечеслении появится новый кейс
            print("New case is Enable")
        }
    }
    
    // фокусирует карту на местоположение пользователя
    func showUserLocation(mapView: MKMapView){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, // определяет точку на карте
                                            latitudinalMeters: regionInMetters,
                                            longitudinalMeters: regionInMetters)
            mapView.setRegion(region, animated: true) // приближает к ней
        }
    }
    
    // строим маршрут от местоположения пользователя до заведения 
    func getDirection(for mapView: MKMapView, preLocation: (CLLocation)->()){
        guard let location = locationManager.location?.coordinate else {
            alertController(title: "Error", massege: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        preLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        
        guard let request = createDirectionRequest(from: location) else {
            alertController(title: "Error", massege: "Destanation in not found")
            return
        }
        let direction = MKDirections(request: request)
        resetMapView(withNew: direction, mapView: mapView)
        
        direction.calculate { (response, error) in
            if let error = error{
                print(error)
                return
            }
            
            guard let response = response else{
                self.alertController(title: "Error", massege: "Direction is not available")
                return
            }
            
            for route in response.routes{
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
//                let distance = String(format: "%.1f", route.distance/1000)
//                let timeIntable = route.expectedTravelTime
                
                print("Расстояние до места%")
            }
        }
    }
    
    // метод для построения маршрута
    func createDirectionRequest(from coordinete: CLLocationCoordinate2D)->MKDirections.Request?{
        guard let destanationCoordinate = placeCoordinate else {return nil}
        let startingLocation = MKPlacemark(coordinate: coordinete)
        let destanation = MKPlacemark(coordinate: destanationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destanation)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // меняем отображаемую зону области карты в соответствии с перемещением пользователя
    func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation:CLLocation)->()){
        
        guard let location = location else {return}
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else {return}
        
        closure(center)
        
    }
    
    // сброс всех маршрутов перед построением нового
    func resetMapView(withNew diraction: MKDirections, mapView: MKMapView){
        mapView.removeOverlays(mapView.overlays) // удаляем все маршруты с карты
        diractionsArray.append(diraction)
        let _ = diractionsArray.map { $0.cancel()}
        diractionsArray.removeAll()
    }
    
    // определение центра отображаемой области
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        
        let latitude = mapView.centerCoordinate.latitude // ширина
        let longitude = mapView.centerCoordinate.longitude // долгота
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    
    func alertController(title: String, massege: String){
        // создаем окно выбора для добавления фото
        let actionSheet = UIAlertController(title: title,
                                            message: massege,
                                            preferredStyle: .alert)
        // создаем дейстие для включения камеры
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        actionSheet.addAction(okAction)
        // выводим меню выбора
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController() //
        alertWindow.windowLevel = UIWindow.Level.alert + 1 // позиция относительно других окон
        alertWindow.makeKeyAndVisible() // делаем окно ключевым и видемым
        alertWindow.rootViewController?.present(actionSheet,animated: true)
    }
    
    
    
}

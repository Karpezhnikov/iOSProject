//
//  PlaceModel.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 15/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import RealmSwift

// модель данных для заполнения полей строки
class Place: Object {
    @objc dynamic var name = "" // делаем не обязательными все поля кроме name
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    // инициализатор для класса
    convenience init(name: String, location: String?, type: String?, imageData:Data?, rating: Double){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.rating = rating
    }
}





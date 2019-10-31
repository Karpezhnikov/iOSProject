//
//  StorageManager.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//
// для работы с Realm

import RealmSwift

let realm = try! Realm()

class StorageManager{
    
    // сохраняет полученный объект
    static func saveObject(_ service: Service){
        try! realm.write {
            realm.add(service)
        }
        
    }
    
}

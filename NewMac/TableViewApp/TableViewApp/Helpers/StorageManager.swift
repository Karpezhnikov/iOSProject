//
//  StorageManager.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 15/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

// файл для работы с БД Realm
import RealmSwift

let realm = try! Realm()

class StorageManager{
    
    static func saveObject(_ place: Place){
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject(_ place: Place){
        try! realm.write {
            realm.delete(place)
        }
    }
    
}


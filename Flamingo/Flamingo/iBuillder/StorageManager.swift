//
//  StorageManager.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager{
    
    static func saveObject(_ service: Service){
        
        try! realm.write {
            realm.add(service)
        }
        
    }
    
}

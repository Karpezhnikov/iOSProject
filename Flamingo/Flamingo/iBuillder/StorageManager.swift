//
//  StorageManager.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//
// для работы с Realm

import RealmSwift

let schemaVersion: UInt64 = 1
let config = Realm.Configuration(
        // Get the URL to the bundled file
    //fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
    schemaVersion: schemaVersion,
    migrationBlock: { migration, oldSchemaVersion in
    // We haven’t migrated anything yet, so oldSchemaVersion == 0
    if (oldSchemaVersion < schemaVersion) {
        // Nothing to do!
        // Realm will automatically detect new properties and removed properties
        // And will update the schema on disk automatically
        }}
)

// Open the Realm with the configuration
let realm = try! Realm(configuration: config)


class StorageManager{
    
    // сохраняет полученный объект
    static func saveObject(_ newObject: Object){
        try! realm.write {
            realm.add(newObject)
        }
    }
    
    
    static func saveObjectRealm(_ newObject: Object){
        try! realm.write {
            realm.add(newObject)
            print("Request for DataDase --> saveObjectDiscount")
        }
//        
//        let listMasters = realm.objects(Discxount.self)
//        print(listMasters)
    }
    
    static func deleteObjectRealm(_ newObject: Object){
        try! realm.write {
            realm.delete(newObject)
        }
    }
    
    // возвращает всех мастеров для указаного service
    static func getMasterFromTheDataBase(_ service: Service) -> [MasterServices]{
        var masters = [MasterServices]()
        let idsMaster = service.idsMasters.components(separatedBy: ";") // парсим строку для получения id
        
        guard idsMaster.count > 0 else { // проверием что они есть
            return []
        }
        
        let listMasters = realm.objects(MasterServices.self) // делаем запрос в бд
        for master in listMasters{
            if idsMaster.contains(master.idMaster) { // берем нужных мастеров
                masters.append(master)
            }
        }
        return masters
    }
    
}

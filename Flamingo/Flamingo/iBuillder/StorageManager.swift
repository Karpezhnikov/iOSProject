//
//  StorageManager.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//
// для работы с Realm

import RealmSwift

let schemaVersion: UInt64 = 14
let config = Realm.Configuration(
        // Get the URL to the bundled file
    fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
    readOnly: true,
    schemaVersion: schemaVersion)

// Open the Realm with the configuration
let realm = try! Realm(configuration: config)


class StorageManager{
    
    // сохраняет полученный объект
    static func saveObject(_ service: Service){
        try! realm.write {
            realm.add(service)
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
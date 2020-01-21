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
            print("Save for Realm--> \(newObject.objectSchema.className)")
        }
    }
    
    static func deleteObjectRealm(_ newObject: Object){
        try! realm.write {
            realm.delete(newObject)
        }
    }
    
    // возвращает всех мастеров для указаного service
    static func getMasterFromTheDataBase(_ service: Service) -> [Master]{
        var masters = [Master]()
        let idsMaster = service.idsMasters.components(separatedBy: ",") // парсим строку для получения id
        guard idsMaster.count > 0 else { // проверием что они есть
            return []
        }
        
        let listMasters = realm.objects(Master.self) // делаем запрос в бд
        for master in listMasters{
            if idsMaster.contains(master.id) { // берем нужных мастеров
                masters.append(master)
            }
        }
        
        return masters
    }
    
    static func getServicesMaster(_ id:String)-> [Service]{
        var servicesReturn = Array<Service>()
        let services = realm.objects(Service.self).sorted(byKeyPath: "nameService")
        for service in services{ //смотрим все услуги
            let idsMaster = service.idsMasters.components(separatedBy: ",")//находим запись о мастерах и парсим
            if idsMaster.contains(id){ // смотрим, есть ли там мстер
                servicesReturn.append(service) // если есть добавляем в список
            }
        }
        return servicesReturn
    }
    
    static func updateFavorites(_ id: String){
        let result = realm.objects(Service.self).filter("id = '\(id)'")
        guard result.count > 0 else {
            return
        }
        let updateFavorites = result.first
        if updateFavorites!.favorites{
            try! realm.write {
                updateFavorites!.favorites = false
            }
        }else{
            try! realm.write {
                updateFavorites!.favorites = true
            }
        }
    }
    
}

extension Object {
//    func toDictionary() -> NSDictionary {
//        let properties = self.objectSchema.properties.map { $0.name }
//        let dictionary = self.dictionaryWithValues(forKeys: properties)
//
//        let mutabledic = NSMutableDictionary()
//        mutabledic.setValuesForKeys(dictionary)
//        
//        
//        for prop in (self.objectSchema.properties as [Property]) {
//            // find lists
//            if let nestedObject = self[prop.name] as? Object {
//                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
//            } else if let nestedListObject = self[prop.name] as? ListBase {
//                var objects = [AnyObject]()
//                for index in 0..<nestedListObject._rlmArray.count  {
//                    let object = nestedListObject._rlmArray[index] as! Object
//                    objects.append(object.toDictionary())
//                }
//                mutabledic.setObject(objects, forKey: prop.name)
//            }
//
//        }
//        return mutabledic
//    }

}

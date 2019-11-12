//
//  ModelDataBase.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import RealmSwift

class Service: Object{
    
    @objc dynamic var nameService = ""  // название услуги
    @objc dynamic var placeService = 0 // цена услуги
    @objc dynamic var timeService = "" // время действия
    @objc dynamic var serviceDescription = "" // описание услуги
    @objc dynamic var cosmetics = ""
    
    @objc dynamic var nameCategoryService = "" // название категории услуги
    @objc dynamic var comsmetology = "" // косметология
    @objc dynamic var partOfTheBody = "" //часть тела
    @objc dynamic var maleMan = "" // для кого (unisex, man, women )
        
    // для добавления новой услуги
    func saveService(arrayData: Array<Service>){
        for service in arrayData{
            let newService = Service()
            
            newService.nameService = service.nameService
            newService.placeService = service.placeService
            newService.timeService = service.timeService
            newService.serviceDescription = service.serviceDescription
            newService.cosmetics = service.cosmetics.isEmpty ? "" : service.cosmetics
            newService.nameCategoryService = service.nameCategoryService
            newService.comsmetology = service.comsmetology
            newService.partOfTheBody = service.partOfTheBody
            newService.maleMan = service.maleMan
            
            StorageManager.saveObject(newService)
        }
        
        
    }
}











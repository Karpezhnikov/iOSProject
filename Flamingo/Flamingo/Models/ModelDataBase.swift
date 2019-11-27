//
//  ModelDataBase.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import RealmSwift

class Service: Object{
    
    @objc dynamic var idService = 1
    @objc dynamic var nameService = ""  // название услуги
    @objc dynamic var placeService = 0 // цена услуги
    @objc dynamic var timeService = "" // время действия
    @objc dynamic var serviceDescription = "" // описание услуги
    @objc dynamic var cosmetics = ""
    
    @objc dynamic var nameCategoryService = "" // название категории услуги
    @objc dynamic var comsmetology = "" // косметология
    @objc dynamic var partOfTheBody = "" //часть тела
    @objc dynamic var maleMan = "" // для кого (unisex, man, women )
    @objc dynamic var idsMasters = ""
        
    // для добавления новой услуги
    func saveService(arrayData: Array<Service>){
        for service in arrayData{
            let newService = Service()
            
            newService.idService = service.idService
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


class MasterServices: Object {
    @objc dynamic var idMaster = ""
    @objc dynamic var nameMaster = ""
    @objc dynamic var listServicesMaster = "" // список id услуг через ";"
    @objc dynamic var timeAndPriceMaster = ""
}

class Discount: Object{
    @objc dynamic var nameDiscount = ""  // название акции
    @objc dynamic var serviceDiscount = ""
    @objc dynamic var descriptionDiscount = "" // описание акции
    @objc dynamic var image: Data?

    // инициализатор для класса
    convenience init(nameDiscount: String, descriptionDiscount: String, image:Data?){
        self.init()
        self.nameDiscount = nameDiscount
        self.serviceDiscount = ""
        self.descriptionDiscount = descriptionDiscount
        self.image = image
    }
}

class DiscontFireBase{
    var id = ""
    var name = ""
    var description = ""
    var dateStart = ""
    var dateEnd = ""
    var imageURL = ""
    
    convenience init(id: String, name: String, description: String, dateStart: String, dateEnd: String, image: String){
        self.init()
        self.id = id
        self.name = name
        self.description = description
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.imageURL = image
    }
}

//    func saveDiscount(){
//        let imageOne = UIImage(named: "discontTwo")
//        let imageData = imageOne?.pngData()
//        
//        let newDiscount = Discount(nameDiscount: "АКЦИЯ!",
//                                   descriptionDiscount: "Только три дня! 📆6,7,8 июня!СКИДКА 50% на программу «МОЛОДОСТЬ»",
//                                   image: imageData)
//        
//        StorageManager.saveObjectDiscount(newDiscount)
//        
//        
//    }








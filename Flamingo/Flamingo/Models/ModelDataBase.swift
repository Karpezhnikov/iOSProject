//
//  ModelDataBase.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 28/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import RealmSwift

class Service: Object{
    
    @objc dynamic var id = ""
    @objc dynamic var nameService = ""  // название услуги
    @objc dynamic var placeService = "" // цена услуги
    @objc dynamic var timeService = "" // время действия
    @objc dynamic var serviceDescription = "" // описание услуги
    //@objc dynamic var cosmetics = ""
    @objc dynamic var nameCategoryService = "" // название категории услуги
    @objc dynamic var comsmetology = "" // косметология
    @objc dynamic var partOfTheBody = "" //часть тела
    @objc dynamic var maleMan = "" // для кого (unisex, man, women )
    @objc dynamic var imageURL = ""
    @objc dynamic var image: Data?
    
    @objc dynamic var idsMasters = ""
        
    convenience init(idService: String?, nameService: String?,
                     placeService: String?, timeService: String?, serviceDescription: String?,
                     nameCategoryService: String?, comsmetology: String?, partOfTheBody: String?,
                     maleMan: String?, imageURL: String?, image: UIImage, idsMasters: String?){
        self.init()
        self.id = idService ?? ""
        self.nameService = nameService ?? "" // название услуги
        self.placeService = placeService ?? ""// цена услуги
        self.timeService = timeService ?? ""// время действия
        self.serviceDescription = serviceDescription ?? ""// описание услуги
        //@objc dynamic var cosmetics = ""
        self.nameCategoryService = nameCategoryService ?? ""// название категории услуги
        self.comsmetology = comsmetology ?? "" // косметология
        self.partOfTheBody = partOfTheBody ?? "" //часть тела
        self.maleMan = maleMan ?? "" // для кого (unisex, man, women )
        self.imageURL = imageURL ?? ""
        self.image = image.pngData()
        self.idsMasters = idsMasters ?? ""
    }
    
    // для добавления новой услуги
    func saveService(arrayData: Array<Service>){
        for service in arrayData{
            let newService = Service()
            
            newService.id = service.id
            newService.nameService = service.nameService
            newService.placeService = service.placeService
            newService.timeService = service.timeService
            newService.serviceDescription = service.serviceDescription
            //newService.cosmetics = service.cosmetics.isEmpty ? "" : service.cosmetics
            newService.nameCategoryService = service.nameCategoryService
            newService.comsmetology = service.comsmetology
            newService.partOfTheBody = service.partOfTheBody
            newService.maleMan = service.maleMan
            
            StorageManager.saveObject(newService)
        }
        
        
    }
}

class Master: Object{
    @objc dynamic var id = ""          // id Document Firebase
    @objc dynamic var name = ""
    @objc dynamic var lastName = ""    // фамилия
    @objc dynamic var firstName = ""   // имя
    @objc dynamic var middleName = ""  // отчество
    @objc dynamic var profil = ""      // профессия мастера
    @objc dynamic var info = ""        // информация о местере
    @objc dynamic var imageURL = ""    // ссылка на Storage
    @objc dynamic var image: Data?     // изображение в формате Data
    
    // инициализатор для класса
    convenience init(id: String, name: String?, profil: String?, info: String?, imageURL: String?, image:UIImage){
        self.init()
        self.id = id
        self.name = name ?? ""
        self.profil = profil ?? ""
        self.info = info ?? ""
        self.imageURL = imageURL ?? ""
        self.image = image.pngData()
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

class DiscontFireBase: Object{
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var descriptionDiscont = ""
    @objc dynamic var dateStart = ""
    @objc dynamic var dateEnd = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var image: Data?
    
    convenience init(id: String, name: String?, description: String?, dateStart: String?, dateEnd: String?, imageURL: String?, image: UIImage){
        self.init()
        self.id = id
        self.name = name ?? ""
        self.descriptionDiscont = description ?? ""
        self.dateStart = dateStart ?? ""
        self.dateEnd = dateEnd ?? ""
        self.imageURL = imageURL ?? ""
        self.image = image.pngData()
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








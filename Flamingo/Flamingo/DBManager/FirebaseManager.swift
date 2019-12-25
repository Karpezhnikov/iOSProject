//
//  FirebaseManager.swift
//  Flamingo
//
//  Created by mac on 26/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

class FirebaseManager{
    
    static let firebaseBD = Firestore.firestore()
    
    //MARK: Save Disconts of Firebase
    static func saveDiscontToFirebase(_ discont: Discont){
        //let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = firebaseBD.collection("disconts").addDocument(data: [
            "id":discont.id,
            "name": discont.name,
            "description": discont.descriptionDiscont,
            "dateStart": discont.dateStart,
            "dateEnd": discont.dateEnd,
            "imageURL": discont.imageURL
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //MARK: Save Master of Firebase
    static func saveMasterToFirebase(_ master: Master){
        //let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = firebaseBD.collection("masters").addDocument(data: [
            "id": master.id,
            "name": master.name,
            "profil": master.profil,
            "info": master.info,
            "imageURL": master.imageURL
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document (Master) added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //MARK: Save ServiceEntry of Firebase
    static func saveServiceEntryToFirebase(_ serviceEnrty: ServiceEntry){
        //let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = firebaseBD.collection("service_enrty").addDocument(data: [
            "id": serviceEnrty.id,
            "serviceName": serviceEnrty.serviceName,
            "nameClient": serviceEnrty.nameClient,
            "serviceEnrty": serviceEnrty.numberPhoneClient,
            "dttmEntry": serviceEnrty.dttmEntry,
            "idMaster": serviceEnrty.idMaster,
            "serviceIdDocument": serviceEnrty.serviceIdDocument,
            "price": serviceEnrty.price
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document (ServiceEntry) added with ID: \(ref!.documentID)")
                serviceEnrty.id = ref!.documentID
                StorageManager.saveObjectRealm(serviceEnrty)
                
                 // записываем id документа
                //StorageManager.saveObjectRealm(serviceEnrty) // сохраняем в бд
            }
        }
    }
    
    //MARK: Save Service of Firebase
    static func saveServiceToFirebase(_ service: Service){
        //let db = Firestore.firestore()
        //ToDo: добавить idsMasters = ""
        var ref: DocumentReference? = nil
        ref = firebaseBD.collection("services").addDocument(data: [
            "id":service.id,
            "name":service.nameService,
            "place":service.placeService,
            "time":service.timeService,
            "discription":service.serviceDescription,
            "nameCategory":service.nameCategoryService,
            "partOfTheBody":service.partOfTheBody,
            "maleman":service.maleMan,
            "imageURL":service.imageURL,
            "idsMasters":service.idsMasters
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //MARK: Save Person of Firebase
    static func savePersonToFirebase(_ person: Person){
        var ref: DocumentReference? = nil
        ref = firebaseBD.collection("users").addDocument(data: [
            "name":person.name,
            "numberPhone":person.numberPhone,
            "admin":person.admin,
            "numberVerif":person.numberVerif
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    static func saveObjectOfFirebase(_ master: Master){
        var ref: DocumentReference? = nil
        ref = firebaseBD.collection("masters").addDocument(data: [
            "id":master.id,
            "name":master.name,
            "profil":master.profil,
            "imageURL":master.imageURL
            
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //MARK: Get Data Disconts
    // Синхронизоруем Firebase и Realm
    static func getDataDicontsOfFirebase(){
        var idFireBase = Array<String>() // массив для удаления старых документов
        firebaseBD.collection("disconts").getDocuments() { (querySnapshot, err) in // get disconts
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                // добавляем новые документы
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let discont = realm.objects(Discont.self).filter("id CONTAINS[c] %@", document.documentID).count //ищем id = documentID
                    if discont == 0{ // если нет данных в БД
                        self.saveDataDiscontToRealm(dataDocument: data, documentID: document.documentID) // то вызываем функцию записи в Realm
                    }
                    idFireBase.append(document.documentID) //добаляем id в массив
                }
                // удаляем старые
                let disconts = realm.objects(Discont.self) //ищем id = documentID
                for discont in disconts{
                    if !idFireBase.contains(discont.id){ // если нет такого документа в FireBase, то
                        StorageManager.deleteObjectRealm(discont) // удаляем его из Realm
                    }
                }
            }
        }
    }
    
    //MARK: Get Data Categorys
    // Синхронизоруем Firebase и Realm
    static func getDataCategorysOfFirebase(){
        var idFireBase = Array<String>() // массив для удаления старых документов
        firebaseBD.collection("categoryService").getDocuments() { (querySnapshot, err) in // get disconts
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                print("catedoryService")
                // добавляем новые документы
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let discont = realm.objects(CategoryService.self).filter("id CONTAINS[c] %@", document.documentID).count //ищем id = documentID
                    if discont == 0{ // если нет данных в БД
                        self.saveDataCategoryToRealm(dataDocument: data, documentID: document.documentID) // то вызываем функцию записи в Realm
                    }
                    idFireBase.append(document.documentID) //добаляем id в массив
                }
                // удаляем старые
                let categories = realm.objects(CategoryService.self) //ищем id = documentID
                for category in categories{
                    if !idFireBase.contains(category.id){ // если нет такого документа в FireBase, то
                        StorageManager.deleteObjectRealm(category) // удаляем его из Realm
                    }
                }
            }
        }
    }
    
    //MARK: Get Data Masters
    // Синхронизоруем Firebase и Realm
    static func getDataMastersOfFirebase(){
        var idFireBase = Array<String>() // массив для удаления старых документов
        firebaseBD.collection("masters").getDocuments() { (querySnapshot, err) in // get disconts
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                // добавляем новые документы
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let masters = realm.objects(Master.self).filter("id CONTAINS[c] %@", document.documentID) //ищем id = documentID
                    if masters.count == 0{ // если нет данных в БД
                        self.saveDataMasterToRealm(dataDocument: data, documentID: document.documentID)
                    }else{ //если данные есть, то смотрим есть ли изменение в данных
                        for master in masters{
                            if master.name != (document["name"] as! String) || // изменилось имя
                            master.imageURL != (document["imageURL"] as! String) || // или ссылка
                            master.info != (document["info"] as! String) || // или инфо
                            master.profil != ((document["profil"] as! String)){ // или профиль
                                StorageManager.deleteObjectRealm(master) // удаляем объект
                                self.saveDataMasterToRealm(dataDocument: data, documentID: document.documentID) // добавляем заново
                            }
                        }
                        //блок для аддейта мастера
                    }
                    idFireBase.append(document.documentID) //добаляем id в массив
                }
                // удаляем старые
                let masters = realm.objects(Master.self) //ищем id = documentID
                for master in masters{
                    if !idFireBase.contains(master.id){ // если нет такого документа в FireBase, то
                        StorageManager.deleteObjectRealm(master) // удаляем его из Realm
                    }
                }
            }
        }
    }
    
    //MARK: Get Data Services
    // Синхронизоруем Firebase и Realm
    static func getDataServicesOfFirebase(){
        var idFireBase = Array<String>() // массив для удаления старых документов
        firebaseBD.collection("services").getDocuments() { (querySnapshot, err) in // get disconts
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }else{
                // добавляем новые документы
                //print("Получили querySnapshot")
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let discont = realm.objects(Service.self).filter("id CONTAINS[c] %@", document.documentID).count //ищем id = documentID
                    //print(realm.objects(Service.self).filter("id CONTAINS[c] %@", document.documentID))
                    if discont == 0{ // если нет данных в БД
                        //print("Ушли в saveDataServiceToRealm")
                        self.saveDataServiceToRealm(dataDocument: data, documentID: document.documentID) // то вызываем функцию записи в Realm
                        
                    }
                    idFireBase.append(document.documentID) //добаляем id в массив
                }
                // удаляем старые
                let services = realm.objects(Service.self) //ищем id = documentID
                for service in services{
                    if !idFireBase.contains(service.id){ // если нет такого документа в FireBase, то
                        StorageManager.deleteObjectRealm(service) // удаляем его из Realm
                    }
                }
            }
        }
    }
    
    //MARK: Save Data Discont To Realm
    // для получения изображения и записи данных в Realm
    static func saveDataDiscontToRealm(dataDocument: Dictionary<String,Any>, documentID: String){
        //print("asd")
        guard let imageURL = dataDocument["imageURL"] as? String else{return} // проверяем ссылку на изображение
        let url = URL(string: imageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in // создаем URLSession
            if error != nil{
                print(error!)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if "\(httpResponse.statusCode)" != "200"{ // выходим если не смогли получить данные
                    return
                }
            }
            guard let data = data else{return} // проверяем, что данные получены
            DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
                DispatchQueue.main.async {
                    let discont = Discont(id: documentID,
                                                  name: dataDocument["name"] as? String,
                                                  description: dataDocument["description"] as? String,
                                                  dateStart: dataDocument["dateStart"] as? String,
                                                  dateEnd: dataDocument["dateEnd"] as? String,
                                                  imageURL: dataDocument["imageURL"] as? String,
                                                  image: UIImage(data: data)!)
                    StorageManager.saveObjectRealm(discont)
                    print("discont save")
                }
            }
        }.resume()
        
    }
    
    //MARK: Save Data Category To Realm
    // для получения изображения и записи данных в Realm
    static func saveDataCategoryToRealm(dataDocument: Dictionary<String,Any>, documentID: String){
        //print("asd")
        guard let imageURL = dataDocument["imageURL"] as? String else{return} // проверяем ссылку на изображение
        let url = URL(string: imageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in // создаем URLSession
            if error != nil{
                print(error!)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if "\(httpResponse.statusCode)" != "200"{ // выходим если не смогли получить данные
                    return
                }
            }
            guard let data = data else{return} // проверяем, что изображение получено
            DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
                DispatchQueue.main.async {
//                    let discont = DiscontFireBase(id: documentID,
//                                                  name: dataDocument["name"] as? String,
//                                                  description: dataDocument["description"] as? String,
//                                                  dateStart: dataDocument["dateStart"] as? String,
//                                                  dateEnd: dataDocument["dateEnd"] as? String,
//                                                  imageURL: dataDocument["imageURL"] as? String,
//                                                  image: UIImage(data: data)!)
                    let category = CategoryService(id: documentID,
                                                   category: dataDocument["category"] as? String,
                                                   imageURL: dataDocument["imageURL"] as? String,
                                                   image: UIImage(data: data)!)
                    StorageManager.saveObjectRealm(category)
                    print("Category save")
                }
            }
        }.resume()
        
    }
    
    //MARK: Save Data Master To Realm
    // для получения изображения и записи данных в Realm
    static func saveDataMasterToRealm(dataDocument: Dictionary<String,Any>, documentID: String){
        //print("asd")
        guard let imageURL = dataDocument["imageURL"] as? String else{return} // проверяем ссылку на изображение
        let url = URL(string: imageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in // создаем URLSession
            if error != nil{
                print(error!)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if "\(httpResponse.statusCode)" != "200"{ // выходим если не смогли получить данные
                    return
                }
            }
            guard let data = data else{return} // проверяем, что изображение получено
            DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
                DispatchQueue.main.async {
//                    let master = Master(id: documentID,
//                                                  name: dataDocument["name"] as? String,
//                                                  description: dataDocument["description"] as? String,
//                                                  dateStart: dataDocument["dateStart"] as? String,
//                                                  dateEnd: dataDocument["dateEnd"] as? String,
//                                                  imageURL: dataDocument["imageURL"] as? String,
//                                                  image: UIImage(data: data)!)
                    guard UIImage(data: data) != nil else{return}
                    let master = Master(id: documentID,
                                        name: dataDocument["name"] as? String,
                                        profil: dataDocument["profil"] as? String,
                                        info: dataDocument["info"] as? String,
                                        imageURL: dataDocument["imageURL"] as? String,
                                        image: UIImage(data: data)!)
                    StorageManager.saveObjectRealm(master)
                    print("master save")
                }
            }
        }.resume()
        
    }
    
    //MARK: Save Data Service To Realm
    // для получения изображения и записи данных в Realm
    static func saveDataServiceToRealm(dataDocument: Dictionary<String,Any>, documentID: String){
        //print("asd")
        guard let imageURL = dataDocument["imageURL"] as? String else{return} // проверяем ссылку на изображение
        let url = URL(string: imageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in // создаем URLSession
            if error != nil{
                print(error!)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if "\(httpResponse.statusCode)" != "200"{ // выходим если не смогли получить данные
                    return
                }
            }
            guard let data = data else{return} // проверяем, что изображение получено
            DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
                DispatchQueue.main.async {
                    guard let imageData = UIImage(data: data) else{return}// если получилось преобразовать и из-е
                    let service = Service(idService: documentID,
                                          nameService: dataDocument["name"] as? String,
                                          placeService: dataDocument["place"] as? String,
                                          timeService: dataDocument["time"] as? String,
                                          serviceDescription: dataDocument["discription"] as? String,
                                          nameCategoryService: dataDocument["nameCategory"] as? String,
                                          comsmetology: "",
                                          partOfTheBody: dataDocument["partOfTheBody"] as? String,
                                          maleMan: dataDocument["maleman"] as? String,
                                          imageURL: dataDocument["imageURL"] as? String,
                                          image: imageData,
                                          idsMasters: dataDocument["idsMasters"] as? String)
                    StorageManager.saveObjectRealm(service)
                    print("service save")
                }
            }
        }.resume()
        
    }
    
    //MARK: Updata Master
    static func updataMaster(_ master: Master, idDocument: String, imageURLDel: String){
        firebaseBD.collection("masters").document("\(idDocument)").updateData(["imageURL" : master.imageURL])
        firebaseBD.collection("masters").document("\(idDocument)").updateData(["info" : master.info])
        firebaseBD.collection("masters").document("\(idDocument)").updateData(["name" : master.name])
        firebaseBD.collection("masters").document("\(idDocument)").updateData(["profil" : master.profil])
        deleteImageOfFireBaseStorage(imageURLDel, "master_images")
    }
    
    //MARK: Delete Document
    static func deleteDocument(_ id: String, _ imageURL: String, _ collection: String, _ child: String){
        //let db = Firestore.firestore()
        firebaseBD.collection("\(collection)").document("\(id)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        deleteImageOfFireBaseStorage(imageURL, child)
    }
    
    //MARK: Delete Image
    static func deleteImageOfFireBaseStorage(_ imageURL: String, _ child: String){
        //delete image
        let storagePath = imageURL
        let spaceRef = Storage.storage().reference().child("\(child)") //
        print("TUTU" ,imageURL)
        let deleteImage = spaceRef.storage.reference(forURL: storagePath)

        deleteImage.delete { error in
            if error != nil {
                print(error!)
          } else {
                print("Image successfully removed!")
          }
        }
    }
    
    // помечаем как удаленное и перемещяем в архив
    static func archivedDiscont(_ discont: Discont){
        firebaseBD.collection("disconts").document("\(discont.id)").updateData(["isDelete" : true])
    }
    
    
}










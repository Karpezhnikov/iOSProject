//
//  FirebaseManager.swift
//  Flamingo
//
//  Created by mac on 26/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager{
    
    static let firebaseBD = Firestore.firestore()
    
    // save discont
    static func saveDiscontToFirebase(_ discont: DiscontFireBase){
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
            "imageURL":service.imageURL
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
                    let discont = realm.objects(DiscontFireBase.self).filter("id CONTAINS[c] %@", document.documentID).count //ищем id = documentID
                    if discont == 0{ // если нет данных в БД
                        self.saveDataDiscontToRealm(dataDocument: data, documentID: document.documentID) // то вызываем функцию записи в Realm
                    }
                    idFireBase.append(document.documentID) //добаляем id в массив
                }
                // удаляем старые
                let disconts = realm.objects(DiscontFireBase.self) //ищем id = documentID
                for discont in disconts{
                    if !idFireBase.contains(discont.id){ // если нет такого документа в FireBase, то
                        StorageManager.deleteObjectRealm(discont) // удаляем его из Realm
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
            guard let data = data else{return} // проверяем, что изображение получено
            DispatchQueue.global(qos: .background).async { // в асинхронном режиме записываем данные
                DispatchQueue.main.async {
                    let discont = DiscontFireBase(id: documentID,
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
                                          image: UIImage(data: data)!)
                    StorageManager.saveObjectRealm(service)
                    print("service save")
                }
            }
        }.resume()
        
    }
    
    
    //MARK: Delete Data Discont To FireBase
//    // для полного удаления из Firebase Cloud
//    static func deleteDiscont(_ discont: DiscontFireBase){
//        //let db = Firestore.firestore()
//        firebaseBD.collection("disconts").document("\(discont.id)").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//        deleteImageOfFireBaseStorage(imageURL: discont.imageURL)
//
//    }
    
    static func deleteDocument(_ id: String, _ imageURL: String, _ collection: String, _ child: String){
        //let db = Firestore.firestore()
        firebaseBD.collection("disconts").document("\(id)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        //deleteImageOfFireBaseStorage(imageURL: imageURL)
        deleteImageOfFireBaseStorage1(imageURL, child)
    }
    
    static func deleteImageOfFireBaseStorage1(_ imageURL: String, _ child: String){
        //delete image
        let storagePath = imageURL
        let spaceRef = Storage.storage().reference().child("\(child)") //

        let deleteImage = spaceRef.storage.reference(forURL: storagePath)

        deleteImage.delete { error in
            if error != nil {
                print(error!)
          } else {

          }
        }
    }
    
//    //MARK: Delete image Discont To Storage
//    static func deleteImageOfFireBaseStorage(imageURL: String){
//        //delete image
//        let storagePath = imageURL
//        let spaceRef = Storage.storage().reference().child("discont_images") //
//
//        let deleteImage = spaceRef.storage.reference(forURL: storagePath)
//
//        deleteImage.delete { error in
//            if error != nil {
//                print(error!)
//          } else {
//
//          }
//        }
//    }
    
    // помечаем как удаленное и перемещяем в архив
    static func archivedDiscont(_ discont: DiscontFireBase){
        firebaseBD.collection("disconts").document("\(discont.id)").updateData(["isDelete" : true])
    }
    
    
}










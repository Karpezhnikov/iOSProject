//
//  FirebaseManager.swift
//  GamesTeam
//
//  Created by kam_team on 24.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import Foundation
import Firebase

//хранит в себе данные о колекциях в firebase
enum CollectionsFirebase{
    case QuestionsAndActions
    
    //название коллекции в firebase
    var nameFirebase: String{
        switch self {
        case .QuestionsAndActions:
            return "QuestionsAndActions"
        }
    }
}

//MARK: Firebase Manager
class FirebaseManager{
    static let firebaseBD = Firestore.firestore()
    
    ////обновляем базу данных с воспросами и действиями 
    static func updateQuectionsAndActions(){
        let collectionName = CollectionsFirebase.QuestionsAndActions.nameFirebase
        firebaseBD.collection(collectionName).getDocuments { (querySnapshot, error) in
            guard error == nil else{
                print("Не удалось получить данные 'updateQuectionsAndActions'.")
                print("Ошибка: \(error!)")
                return
            }
            guard let querySnapshotDoc = querySnapshot?.documents, querySnapshotDoc.count != 0 else{
                print("Нет данных из коллекции \(collectionName).")
                return
            }
            for document in querySnapshotDoc{
                //если такого документа нет
                if !RealmManager.checkDataParam(QuestionsAndActionsRealm.self, nameParam: "id", value: document.documentID){
                    guard let qaaR = self.createQAAR(document.data(), document.documentID) else { //создаем объект
                        print("Error 'createQAAR': Не удалось создать класс QuestionsAndActionsRealm")
                        return
                    }
                    RealmManager.saveObject(qaaR) //созраняем новый объект в бд
                    print("document.documentID")
                }
            }
        }
    }
    
    
    
}

//MARK: Pivate Func
extension FirebaseManager{
    ////создает QuestionsAndActionsRealm новый класс из получанных данных
    static func createQAAR(_ data: Dictionary<String,Any>, _ id: String)->QuestionsAndActionsRealm?{
        print(data)
        guard let body = data["body"] as? String else {return nil}
        guard let isAbult = data["isAbult"] as? Bool else {return nil}
        guard let isAlcohol = data["isAlcohol"] as? Bool else {return nil}
        guard let level = data["level"] as? String else {return nil}
        guard let qoa = data["qoa"] as? String else {return nil}
        let qaaR = QuestionsAndActionsRealm(id: id,
                                            gameID: GameType.TrueAndAction.gameId,
                                            body: body,
                                            isAbult: isAbult,
                                            isAlcohol: isAlcohol,
                                            level: level,
                                            qoa: qoa)
        return qaaR
    }
}

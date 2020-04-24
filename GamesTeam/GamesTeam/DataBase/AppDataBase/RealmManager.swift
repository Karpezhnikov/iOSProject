//
//  RealmManager.swift
//  GamesTeam
//
//  Created by kam_team on 16.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import Foundation
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

//MARK: Realm Manager
class RealmManager{
    
    //// сохраняет полученный объект
    static func saveObject(_ newObject: Object){
        try! realm.write {
            realm.add(newObject)
        }
    }
    
    ////удаляем объект
    static func deleteObjectRealm(_ newObject: Object){
        try! realm.write {
            realm.delete(newObject)
        }
    }
    
    ////обновляем значение переменной IsAbult в SettingsGameRealm
    static func updateIsAbultGame(_ settings: SettingsGameRealm, _ toBool: Bool){
        // Update an object with a transaction
        try! realm.write {
            settings.isAbultGame = toBool
        }
    }
    
    ////обновляем значение переменной IsAlcohol в SettingsGameRealm
    static func updateIsAlcoholGame(_ settings: SettingsGameRealm, _ toBool: Bool){
        // Update an object with a transaction
        try! realm.write {
            settings.isAlcoholGame = toBool
        }
    }
    
    ////устанавливаем уровень
    static func updateNextLevel(_ settings: SettingsGameRealm, _ nextLevel: String){
        try! realm.write {
            settings.nextLevel = nextLevel
        }
    }
    
    ////проверяем наличие документа в RealmBD
    static func checkDataParam(_ objectChect: Object.Type, nameParam: String, value: String)->Bool{
        let result = realm.objects(objectChect).filter("\(nameParam) = '\(value)'")
        if result.count != 0{
            return true
        }else{
            return false
        }
    }
    
    ////возвращает рандомнный массив с вопросами по входным параметрам
    static func getArrayQue(gameID: Int, isAbult: Bool, isAlcohol: Bool, level: Levels) -> Array<QuestionsAndActions>{
        var arrayQue = Array<QuestionsAndActions>()
        let allArrayQueAndAction = realm.objects(QuestionsAndActionsRealm.self).filter("gameID = \(gameID) AND qoa = '\(QOA.question.nameRealmDB)'")
        
        for que in allArrayQueAndAction{
            let question = QuestionsAndActions(bodyQQ: que.body,
                                               isAbult: que.isAbult,
                                               isAlcohol: que.isAlcohol,
                                               level: decoderStringToArray(que.level),
                                               qoa: .question)
            if question.level.contains(level){ //нужный уровень сложности
                switch (isAbult, isAlcohol){
                case (false, false):
                    if question.isAbult == false, question.isAlcohol == false{
                        arrayQue.append(question)
                    }
                case (true, false):
                    if question.isAlcohol == false{
                        arrayQue.append(question)
                    }
                case (false, true):
                    if question.isAbult == false{
                        arrayQue.append(question)
                    }
                case (true, true):
                    arrayQue.append(question)
                }
            }
        }
        arrayQue.shuffled()
        return arrayQue
    }
    
    ////возвращает рандомнный массив с действиями по входным параметрам
    static func getArrayAction(gameID: Int, isAbult: Bool, isAlcohol: Bool, level: Levels) -> Array<QuestionsAndActions>{
        var arrayAction = Array<QuestionsAndActions>()
        let allArrayQueAndAction = realm.objects(QuestionsAndActionsRealm.self).filter("gameID = \(gameID) AND qoa = '\(QOA.action.nameRealmDB)'")
        for act in allArrayQueAndAction{
            let action = QuestionsAndActions(bodyQQ: act.body,
                                               isAbult: act.isAbult,
                                               isAlcohol: act.isAlcohol,
                                               level: decoderStringToArray(act.level),
                                               qoa: .action)
            if action.level.contains(level){ //нужный уровень сложности
                switch (isAbult, isAlcohol){
                case (false, false):
                    if action.isAbult == false, action.isAlcohol == false{
                        arrayAction.append(action)
                    }
                case (true, false):
                    if action.isAlcohol == false{
                        arrayAction.append(action)
                    }
                case (false, true):
                    if action.isAbult == false{
                        arrayAction.append(action)
                    }
                case (true, true):
                    arrayAction.append(action)
                }
            }
        }
        arrayAction.shuffled()
        return arrayAction
    }
    
    static func saveObjGame(){
        let gameRealm = GameRealm()
        gameRealm.id = GameType.TrueAndAction.gameId
        gameRealm.name = "Правда или Действие?"
        gameRealm.rating = 4
        gameRealm.favorite = false
        gameRealm.imageData = UIImage(named: "TrueAndAct")!.pngData()!
        gameRealm.sale = "29"
        gameRealm.isBuy = true
        gameRealm.minPlayers = 2
        gameRealm.infoGame = "Отличная игра для веселой кампании. Она поможет узнать друг друга лучше!"
        gameRealm.rulesGame = "1. Игроки от 2 до 10.:2.Каждому по очереди даётся право выбрать правду или действие.:3.Если игрок выбирает правду, то на экране появляется вопрос на который играно должен ответить.:4.Если игрок выбрал действие, то на экране появляется действие, которое должен сделать игрок."
        RealmManager.saveObject(gameRealm)
        
        let settingsTAF = SettingsGameRealm()
        settingsTAF.gameId = GameType.TrueAndAction.gameId
        settingsTAF.lavels = encodedArrayToSrtingLevels([.Easy,.Middle,.Hard])
        settingsTAF.qqsGameID = GameType.TrueAndAction.gameId
        settingsTAF.actionsGameID = GameType.TrueAndAction.gameId
        settingsTAF.isAbultGame = false
        settingsTAF.isAlcoholGame = false
        settingsTAF.nextLevel = ""
        
        RealmManager.saveObject(settingsTAF)
//
//        let qq1 = QuestionsAndActionsRealm()
//        qq1.gameID = GameType.TrueAndAction.gameId
//        qq1.body = "Какого размера твоя грудь?"
//        qq1.isAbult = true
//        qq1.isAlcohol = true
//        qq1.level = encodedArrayToSrtingLevels([.Easy,.Middle])
//        qq1.qoa = QOA.question.nameRealmDB
//        RealmManager.saveObject(qq1)
//
//        let qq2 = QuestionsAndActionsRealm()
//        qq2.gameID = GameType.TrueAndAction.gameId
//        qq2.body = "Сколько ты выпил?"
//        qq2.isAbult = false
//        qq2.isAlcohol = true
//        qq2.level = encodedArrayToSrtingLevels([.Easy,.Middle])
//        qq2.qoa = QOA.question.nameRealmDB
//        RealmManager.saveObject(qq2)
//
//        let qq3 = QuestionsAndActionsRealm()
//        qq3.gameID = GameType.TrueAndAction.gameId
//        qq3.body = "Сколько тебе лет?"
//        qq3.isAbult = false
//        qq3.isAlcohol = false
//        qq3.level = encodedArrayToSrtingLevels([.Easy,.Hard])
//        qq3.qoa = QOA.question.nameRealmDB
//        RealmManager.saveObject(qq3)
//
//        let action1 = QuestionsAndActionsRealm()
//        action1.gameID = GameType.TrueAndAction.gameId
//        action1.body = "Выпей свой напиток до дна!"
//        action1.isAbult = false
//        action1.isAlcohol = true
//        action1.level = encodedArrayToSrtingLevels([.Easy,.Middle])
//        action1.qoa = QOA.action.nameRealmDB
//        RealmManager.saveObject(action1)
//
//        let action2 = QuestionsAndActionsRealm()
//        action2.gameID = GameType.TrueAndAction.gameId
//        action2.body = "Присядь 10 раз"
//        action2.isAbult = false
//        action2.isAlcohol = false
//        action2.level = encodedArrayToSrtingLevels([.Easy])
//        action2.qoa = QOA.action.nameRealmDB
//        RealmManager.saveObject(action1)
//
//        let action3 = QuestionsAndActionsRealm()
//        action3.gameID = GameType.TrueAndAction.gameId
//        action3.body = "Сними с себя весь верх"
//        action3.isAbult = true
//        action3.isAlcohol = false
//        action3.level = encodedArrayToSrtingLevels([.Hard])
//        action3.qoa = QOA.action.nameRealmDB
//        RealmManager.saveObject(action1)
    }
    
}

//MARK: Realm objects
class GameRealm: Object{
    @objc dynamic var id = Int()
    @objc dynamic var name = String()
    @objc dynamic var rating = Int()
    @objc dynamic var imageData = Data()
    @objc dynamic var favorite = Bool()
    @objc dynamic var sale = String()
    @objc dynamic var isBuy = Bool()
    @objc dynamic var maxPlayers = Int()
    @objc dynamic var minPlayers = Int()
    @objc dynamic var infoGame = String()
    @objc dynamic var rulesGame = String()
}

class SettingsGameRealm: Object{
    @objc dynamic var gameId = Int()
    @objc dynamic var lavels = String() //строка с названиями лев через ":"
    @objc dynamic var qqsGameID = Int()
    @objc dynamic var actionsGameID = Int()
    @objc dynamic var isAbultGame = Bool()
    @objc dynamic var isAlcoholGame = Bool()
    @objc dynamic var nextLevel = String()
    
}

class QuestionsAndActionsRealm: Object{
    @objc dynamic var id = String()
    @objc dynamic var gameID = Int()
    @objc dynamic var body = String()
    @objc dynamic var isAbult = Bool()
    @objc dynamic var isAlcohol = Bool()
    @objc dynamic var level = String() //строка с названиями лев через ":"
    @objc dynamic var qoa = String()
    
    convenience init(id : String, gameID : Int, body : String, isAbult : Bool, isAlcohol : Bool, level : String, qoa : String) {
        self.init()
        self.id = id
        self.gameID = gameID
        self.body = body
        self.isAbult = isAbult
        self.isAlcohol = isAlcohol
        self.level = level
        self.qoa = qoa
    }
}

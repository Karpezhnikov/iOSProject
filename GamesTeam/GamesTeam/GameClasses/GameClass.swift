//
//  TrueAndAction.swift
//  GamesTeam
//
//  Created by kam_team on 02.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: Game
class Game{
    var id = 0 //уникальный id игры
    var nameGame = "" //название
    var rating = 1
    var imageGame = UIImage()
    var favorite = true
    var sale = ""
    var isBuy = false
    var maxPlayers: Int? = nil
    var minPlayers: Int = 2
    
    var infoGame = ""
    var rulesGame = ""
    
    var settingGame = SettingsGame()
    
}

//MARK: - Settings Game
class SettingsGame{
    var gameId = 0 //уникальный id игры
    var lavels = Array<Levels>() //уровни игры
    var qqsGame = Array<QuestionsAndActions>() // массив с вопросами
    var actionsGame = Array<QuestionsAndActions>() //массив с действиями
    var isAbultGame = Bool() // вопрос 18+?
    var isAlcoholGame = Bool() // для игры с алкоголем?
    var gameType:GameType = .None //идентификатор игры
    var nextLevel:Levels = .none //выбраный уровень игры
}

class QuestionsAndActions{
    var bodyQQ = String() // сам вопрос или действие
    var isAbult = Bool() // вопрос 18+?
    var isAlcohol = Bool() // для игры с алкоголем?
    var level = Array<Levels>() // уровень вопроса
    var qoa = QOA.none
    
    init(bodyQQ: String, isAbult: Bool, isAlcohol: Bool, level: Array<Levels>, qoa:QOA) {
        self.bodyQQ = bodyQQ
        self.isAbult = isAbult
        self.isAlcohol = isAlcohol
        self.level = level
        self.qoa = qoa
    }
}

//MARK: Game type
//данные для загрузки ViewController с игрой
enum GameType{
    case TrueAndAction
    case None
    
    ////унмкальный идентификатор игры
    var gameId: Int{
        switch self {
        case .TrueAndAction:
            return 1
        case .None:
            return 0
        }
    }
    
}

//MARK: - Levels
////уровни сложность в игре
enum Levels{
    case Hard
    case Middle
    case Easy
    case none
    
    ////наименование в Realm
    var nameRealmDB: String{
        switch self {
        case .Easy:
            return "Easy"
        case .Middle:
            return "Middle"
        case .Hard:
            return "Hard"
        case .none:
            return "none"
        }
    }
    
    //// String представление на русском
    var nameLevel: String{
        switch self {
        case .Easy:
            return "Легкий"
        case .Middle:
            return "Средний"
        case .Hard:
            return "Тяжелый"
        case .none:
            return ""
        }
    }
    
    ////описание  уровня
    var infoLevel: String{
        switch self {
        case .Easy:
            return "Для тех кто не любит сложности, тяжелох заданий и каверзных вопросов."
        case .Middle:
            return "Для тех кто хочет больше веселья, но в пределах разумного."
        case .Hard:
            return "Для тех кто любит сложности, тяжелые задания и каверзные вопросы."
        case .none:
            return ""
        }
    }
    
    ////цвет уровня
    var colorLevel: UIColor{
        switch self {
        case .Easy:
            return ColorApp.ligthBlue ?? UIColor.green.withAlphaComponent(0.3)
        case .Middle:
            return ColorApp.ligthBlue ?? UIColor.green.withAlphaComponent(0.3)
        case .Hard:
            return ColorApp.ligthBlue ?? UIColor.green.withAlphaComponent(0.3)
        case .none:
            return ColorApp.whiteApp
        }
    }
    
    ////изображение уровня
    var imageName: String{
        switch self {
        case .Easy:
            return ""
        case .Middle:
            return ""
        case .Hard:
            return ""
        case .none:
            return ""
        }
    }
}

//MARK: QOA
//для определения вопрос или действие
enum QOA{
    
    case action
    case question
    case none
    
    var nameRealmDB: String{
        switch self {
        case .action:
            return "action"
            
        case .question:
            return "question"
        default:
            return "none"
        }
    }
    
}



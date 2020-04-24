//
//  HelpersFunc.swift
//  GamesTeam
//
//  Created by kam_team on 03.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

public func getRating(_ arrayFavor: Array<UIImageView>, _ rating: Int){
    guard arrayFavor.count == 5 else {
        return
    }
    switch rating {
    case 1:
        arrayFavor[0].image = UIImage(systemName: "star.fill")
    case 2:
        arrayFavor[1].image = UIImage(systemName: "star.fill")
        arrayFavor[2].image = UIImage(systemName: "star.fill")
    case 3:
        arrayFavor[1].image = UIImage(systemName: "star.fill")
        arrayFavor[2].image = UIImage(systemName: "star.fill")
        arrayFavor[3].image = UIImage(systemName: "star.fill")
    case 4:
        arrayFavor[1].image = UIImage(systemName: "star.fill")
        arrayFavor[2].image = UIImage(systemName: "star.fill")
        arrayFavor[3].image = UIImage(systemName: "star.fill")
        arrayFavor[4].image = UIImage(systemName: "star.fill")
    case 5:
        arrayFavor[1].image = UIImage(systemName: "star.fill")
        arrayFavor[2].image = UIImage(systemName: "star.fill")
        arrayFavor[3].image = UIImage(systemName: "star.fill")
        arrayFavor[4].image = UIImage(systemName: "star.fill")
        arrayFavor[5].image = UIImage(systemName: "star.fill")
    default:
        return
    }
}

public func getAlert(_ title: String, _ message: String, _ titleCancel: String) -> UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: titleCancel, style: .cancel, handler: nil))
    return alert
}

//// декодирует из массива QOA в строку с названием через ":"
//func decodedArrayToSrtingQOA(_ arrayQOA: Array<QOA>)->String{
//    var stringEnum = ""
//
//    for enumName in arrayQOA{ //записываем все названия
//        stringEnum += "\(enumName.nameRealmDB):"
//    }
//    stringEnum.remove(at: stringEnum.index(before: stringEnum.endIndex)) // удаляем лишний символ в конце ":"
//
//    return stringEnum
//}

//// кодирует из массива Levels в строку с названием через ":"
func encodedArrayToSrtingLevels(_ arrayQOA: Array<Levels>)->String{
    var stringEnum = ""
    
    for enumName in arrayQOA{ //записываем все названия
        stringEnum += "\(enumName.nameRealmDB):"
    }
    stringEnum.remove(at: stringEnum.index(before: stringEnum.endIndex)) // удаляем лишний символ в конце ":"
    
    return stringEnum
}

////декодирует из строки в массив Levels
func decoderStringToArray(_ stringLevels: String)->Array<Levels>{
    var arrayLevels = [Levels]()
    let arrayString = stringLevels.components(separatedBy: ":")
    for levelName in arrayString{
        if levelName == Levels.Easy.nameRealmDB{
            arrayLevels.append(.Easy)
        }else if levelName == Levels.Middle.nameRealmDB{
            arrayLevels.append(.Middle)
        }else if levelName == Levels.Hard.nameRealmDB{
            arrayLevels.append(.Hard)
        }else{
            arrayLevels.append(.none)
        }
    }
    
    return arrayLevels
}

////Кодируем все правила в одну строку, через:
func encoderRulesGame(_ arrayRules: Array<String>)->String{
    var stringRules = ""
    for rule in arrayRules{
        stringRules += rule + ":"
    }
    stringRules.remove(at: stringRules.index(before: stringRules.endIndex)) // удаляем лишний символ в конце ":"
    return stringRules
}

////Декодируем правила из строки в массив
func decoderRulesGame(_ stringRules: String)->Array<String>{
    return stringRules.components(separatedBy: ":")
}

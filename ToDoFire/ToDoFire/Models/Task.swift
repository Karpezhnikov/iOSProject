//
//  Task.swift
//  ToDoFire
//
//  Created by Алексей Карпежников on 24/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let ref: DatabaseReference? // для доступа к конкретному значению
    var complited: Bool = false // обозначение статура задачи(fasle - поумолчанию не выполнена)
    
    // для создания объекта локально
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    // DataSnapshot - срез данный в БД на этот момент
    init(snapshot: DataSnapshot) {
        // ключи всегда будут иметь тип стринг
        // а второй элемент не знаем
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        complited = snapshotValue["complited"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionart()->Any{
        return ["title":title, "userId":userId, "complited" : complited]
    }
    
}

//
//  User.swift
//  ToDoFire
//
//  Created by Алексей Карпежников on 24/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct User {
    let uid: String
    let email: String
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}

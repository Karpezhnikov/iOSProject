//
//  Background.swift
//  WarFly
//
//  Created by Алексей Карпежников on 03/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {

    // функция возвращает фон
    static func populeteBackground(at point: CGPoint) -> Background{
        let background = Background(imageNamed: "backgroundWater")
        background.position = point // точка относильтельно которой должен располагаться фон по центру
        background.zPosition = 0 // для того чтобы фон был снизу
        
        return background
    }
    
}

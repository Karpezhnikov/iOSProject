//
//  Island.swift
//  WarFly
//
//  Created by Алексей Карпежников on 03/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit


final class Island: SKSpriteNode, GameBackgroundStriteable {

    // можем вызрать метод как с point, так и без
    static func populate(at point: CGPoint?)-> Island{
        let islandImageName = configureName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(0.1)
        island.position = point ?? randomPoint() // если без, то координаты рандомные
        island.zPosition = 1
        island.run(rotateForRandomAngle())
        island.name = "backgroundSprite"
        island.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        island.run(move(from: island.position))
        island.physicsBody?.collisionBitMask =  0 // с какими может сталкиваться
        return island
    }
    
    // определяем имя картинки (рандом)
    fileprivate static func configureName()-> String{
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        return imageName
    }
    
    // определяем увеличение картинки (рандом)
    fileprivate static func randomScaleFactor() -> CGFloat{
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()/10)
        return randomNumber
    }
    
    // создаем действие, чтобы остаров крутился (радномно на поворот острова)
    fileprivate static func rotateForRandomAngle() -> SKAction{
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        
        return SKAction.rotate(byAngle: randomNumber*CGFloat(Double.pi/180), duration: 0)
    }
    
    // делаем объект движемым
    fileprivate static func move(from point: CGPoint) -> SKAction{
        let movePoint = CGPoint(x: point.x, y: -200) // откуда двигаться
        let moveDistance = point.y + 200 // дистанция передвижения
        let movementSpeed: CGFloat = 150.0 // время передвижения
        let duration = moveDistance/movementSpeed //время работы анимации
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
    
}

//
//  Cloud.swift
//  WarFly
//
//  Created by Алексей Карпежников on 03/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit

final class Cloud: SKSpriteNode, GameBackgroundStriteable {
    
    
    static func populate(at point: CGPoint?)-> Cloud{
        let cloudImageName = configureName()
        let cloud = Cloud(imageNamed: cloudImageName)
        cloud.size.width = CGFloat(200)
        cloud.size.height = CGFloat(100)
        cloud.position = point ?? randomPoint()
        cloud.zPosition = 2
        cloud.name = "backgroundSprite"
        cloud.anchorPoint = CGPoint(x: 0.5, y: 1.0) // для нормального удаления после полного ухода
        cloud.run(move(from: cloud.position))
        cloud.alpha = 0.85 // делаем чуть прозрачнее
        cloud.physicsBody?.collisionBitMask =  0 // с какими может сталкиваться
        return cloud
    }
    
    // определяем имя картинки (рандом)
    // fileprivate - чтобы при создания объекта класса не было видно этих ф-й
    // (скрываем реализацию класса)
    fileprivate static func configureName()-> String{
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "cl" + "\(randomNumber)"
        return imageName
    }
    
    // определяем увеличение картинки (рандом)
    fileprivate static func randomScaleFactor() -> CGFloat{
        let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
        let randomNumber = CGFloat(distribution.nextInt()/10)
        return randomNumber
    }
    
    // создаем действие, чтобы остаров крутился (радномно на поворот острова)
    static func rotateForRandomAngle() -> SKAction{
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        
        return SKAction.rotate(byAngle: randomNumber*CGFloat(Double.pi/180), duration: 0)
    }
    
    fileprivate static func move(from point: CGPoint) -> SKAction{
        let movePoint = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 200.0
        let duration = moveDistance/movementSpeed
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
    
}

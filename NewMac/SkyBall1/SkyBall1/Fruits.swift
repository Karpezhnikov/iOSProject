//
//  Fruits.swift
//  SkyBall1
//
//  Created by Алексей Карпежников on 14/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import SpriteKit

class Fruits: SKSpriteNode {
    // point - позиция
    static func populate() -> Fruits {
        //let playerImageName = configurateName()
        let scale = UIScreen.main.bounds.size
        let fruit = Fruits(imageNamed: "orange")
        fruit.setScale(setScaleTreeBranc(from: fruit.size.width))
        fruit.position = CGPoint(x: 0, y: scale.height/2)
        fruit.zPosition = 3
        //playerBall.run(move(from: treeBranch.position))
        fruit.name = "fruit"
        //playerBall.run(move(from: playerBall.position))
        
        
        return fruit
    }
    
    // ф-я считает ко-эф-т умножения
    fileprivate static func setScaleTreeBranc(from wigthTB: CGFloat) -> CGFloat{
        // сколько будет занимать фрукт от ширины экрана
        let scale = UIScreen.main.bounds.size.width/4 // до середины экрана
        let wigthtreeBranch = scale/wigthTB // считаем пропорцию
        return wigthtreeBranch
    }
    
    // для движения объекта вниз
    fileprivate static func move(from point: CGPoint) -> SKAction{
        let movePoint = CGPoint(x: point.x, y: -200) // точка окончания движения
        let moveDistance = point.y + 200 // дистанция
        let movementSpeed: CGFloat = 200.0 // скорость движения
        let duration = moveDistance/movementSpeed // время движения
        return SKAction.move(to: movePoint, duration: TimeInterval(duration)) // действие
    }
    
}

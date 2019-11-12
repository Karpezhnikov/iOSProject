//
//  TreeBranch.swift
//  SkyBall
//
//  Created by Алексей Карпежников on 08/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

final class TreeBranch: SKSpriteNode {
    
    // point - позиция
    static func populate(at point: CGPoint?) -> TreeBranch {
        let treeBranchImageName = configurateName()
        let treeBranch = TreeBranch(imageNamed: treeBranchImageName)
        treeBranch.setScale(setScaleTreeBranc(from: treeBranch.size.width))
        treeBranch.position = point ?? randomPointTreeBranch(from: treeBranch.frame.size.width)
        treeBranch.zPosition = 2
        treeBranch.run(move(from: treeBranch.position))
        treeBranch.name = "treeBranch"
        
        
        return treeBranch 
    }

    // ф-я считает ко-эф-т умножения
    fileprivate static func setScaleTreeBranc(from wigthTB: CGFloat) -> CGFloat{
        let scale = UIScreen.main.bounds.size.width/2 // до середины экрана
        let wigthtreeBranch = scale/wigthTB // считаем пропорцию
        return wigthtreeBranch
    }
 
    // генерирует рандомное изображение
    fileprivate static func configurateName() -> String{
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "treeBranch\(randomNumber)"
        return imageName
    }
    
    fileprivate static func randomPointTreeBranch(from wigth: CGFloat)->CGPoint{
        let screen = UIScreen.main.bounds
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 100, highestValue: Int(screen.size.height) + 200)
        let y: CGFloat = CGFloat(distribution.nextInt()) // от lowestValue до highestValue
        
        var x: CGFloat = 0
        if GKRandomDistribution(lowestValue: 0, highestValue: 10).nextInt() > 5{
            x = 0 // по правому краю
        } else{
            x = screen.width // по правому краю
            
        }
        return CGPoint(x: x, y: y)
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

enum SideDeraction{
    case left
    case rigth
}

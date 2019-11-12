//
//  PlayerBall.swift
//  SkyBall1
//
//  Created by Алексей Карпежников on 08/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import UIKit
import CoreMotion

class PlayerBall: SKSpriteNode {

    let scale = UIScreen.main.bounds.size
    let motionMeneger = CMMotionManager()
    var xAccelerate: CGFloat = 0
    // point - позиция
    static func populate() -> PlayerBall {
        //let playerImageName = configurateName()
        let scale = UIScreen.main.bounds.size
        let playerBall = PlayerBall(imageNamed: "playerBall")
        playerBall.setScale(setScaleTreeBranc(from: playerBall.size.width))
        playerBall.position = CGPoint(x: scale.width/2, y: scale.height/2)
        playerBall.zPosition = 3
        //playerBall.run(move(from: treeBranch.position))
        playerBall.name = "playerBall"
        //playerBall.run(move(from: playerBall.position))
        
        
        return playerBall
    }
    
    // определяем границы, за которые не может уйти объект
    func borderPlayerBall(){
        let minPositionX = CGFloat(0)
        let maxPositionX = UIScreen.main.bounds.size.width
        
        if self.position.x < minPositionX{
            self.position.x = minPositionX
        } else if self.position.x > maxPositionX{
            self.position.x = maxPositionX
        }
        
        if self.position.y < 300{
            self.position.y = 300
        }
    }
    
    // управления с помощью акселерометра
    func accelerateControl(){
        motionMeneger.accelerometerUpdateInterval = 0.2
        motionMeneger.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data{
                let acceleration = accelerometrData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
        }
        self.position.x += xAccelerate * 50 // получаем значение акселерометра
        borderPlayerBall()
    }
    
    func normalContril(at location: CGFloat){
        //let location = touch.location(in: UIScreen).x
         
//        if location > firstTouch {
//            let posX = UIScreen.main.bounds.size.width * 0.0125
//            let moveToRight = SKAction.moveBy(x: posX, y: 0, duration: 0.001)
//            //let forever = SKAction.repeatForever(moveToRight)
//            self.run(moveToRight)
//            //playerBall.position.x = playerBall.position.x + screen.size.width * 0.0125
//        }else if location < firstTouch {
//            let posX = UIScreen.main.bounds.size.width * 0.0125
//            let moveToLeft = SKAction.moveBy(x: -posX, y: 0, duration: 0.001)
//            //let forever = SKAction.repeatForever(moveToLeft)
//            self.run(moveToLeft)
//            //playerBall.position.x = playerBall.position.x - screen.size.width * 0.0125
//        }else if location == self.position.x{
//            self.position.x = location
//
//        }
        // если касание не равно позиции объекта, то
        if location != self.position.x{
            let posX = location - self.position.x // определяем расстояние
            let moveToLeft = SKAction.moveBy(x: posX, y: 0, duration: 0.5)
            self.run(moveToLeft) // передвигаем объект к месту касания
        }
        self.position.x = location
        //self.removeAllActions()
        borderPlayerBall()
    }
    
    // ф-я считает ко-эф-т умножения
    fileprivate static func setScaleTreeBranc(from wigthTB: CGFloat) -> CGFloat{
        let scale = UIScreen.main.bounds.size.width/6 // до середины экрана
        let wigthtreeBranch = scale/wigthTB // считаем пропорцию
        return wigthtreeBranch
    }
    
//    // для движения объекта вниз
//    fileprivate static func move(from point: CGPoint) -> SKAction{
//        let movePoint = CGPoint(x: point.x, y: -200) // точка окончания движения
//        let moveDistance = point.y + 200 // дистанция
//        let movementSpeed: CGFloat = 200.0 // скорость движения
//        let duration = moveDistance/movementSpeed // время движения
//        return SKAction.move(to: movePoint, duration: TimeInterval(duration)) // действие
//    }
    

    
 
    
}

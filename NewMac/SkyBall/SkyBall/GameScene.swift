//
//  GameScene.swift
//  SkyBall
//
//  Created by Алексей Карпежников on 07/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        //configureStartScene()
        //spawnClouds()
        
        let screen = UIScreen.main.bounds
        for _ in 1...5{
            let x: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
            let y: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.height)))
            let treeBranch = TreeBranch.populetTreeBranch(at: CGPoint(x: x, y: y))
            self.addChild(treeBranch)
            print("Создаем ветку")
        }
        
    }
    
    fileprivate func configureStartScene(){
        let screenCentrPoint = CGPoint(x: self.size.width/2, y: self.size.height/2) // центр экрана
        let background = Background.populeteBackground(at: screenCentrPoint)
        background.size = self.size // растягиваем изображение на весь экран
        self.addChild(background) // устанавливем фон на экран
        

        
//        let cloudImageName = configureName()
//        let cloud = Cloud(imageNamed: cloudImageName)
//        cloud.size.width = CGFloat(200)
//        cloud.size.height = CGFloat(100)
//        cloud.position = point ?? randomPoint()
//        cloud.zPosition = 2
//        cloud.name = "backgroundSprite"
//        cloud.anchorPoint = CGPoint(x: 0.5, y: 1.0) // для нормального удаления после полного ухода
//        cloud.run(move(from: cloud.position))
//        cloud.alpha = 0.85 // делаем чуть прозрачнее
//        cloud.physicsBody?.collisionBitMask =  0 // с какими может сталкиваться
        
    }
    
//    //создаем облака
//    fileprivate func spawnClouds(){
//        
//        let spawnCloudWait = SKAction.wait(forDuration: 1) // время создания
//        let spawnCloudAction = SKAction.run { // действие создания
//            let cloud = Cloud.populate(at: nil)
//            self.addChild(cloud)
//        }
//        
//        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction]) // двойное действие
//        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
//        run(spawnCloudForever)
//    }
    
    override func didSimulatePhysics() {
        
//        player.checkPosition() // не дает плееру уйти за границу
//        player.performFly() // управление акселерометром
        
        // функция опознает все объекты на странице по имении
        enumerateChildNodes(withName: "backgroundSprite") { (node, stop) in
            if node.position.y < -190{
                node.removeFromParent() // удаляем объект, если он ниже нуля
            }
        }
        
    }

}
    

    
   


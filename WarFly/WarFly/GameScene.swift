//
//  GameScene.swift
//  WarFly
//
//  Created by Алексей Карпежников on 03/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    

    var player: PlayerPlane!
    
    override func didMove(to view: SKView) {
        
        configureStartScene()
        spawnClouds()
        spawnIslands()
        let daedLine = DispatchTime.now() + .nanoseconds(1)
        DispatchQueue.main.asyncAfter(deadline: daedLine) { [unowned self] in
            self.player.performFly()
        }
        
        
        let powerUP = PowerUP()
        powerUP.pevformRotation()
        powerUP.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(powerUP)
        
        let enemyTextureAtlas = SKTextureAtlas(named: "Enemy")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas]) {
            Enemy.textureAtlas = enemyTextureAtlas
            let enemi = Enemy()
            enemi.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
            self.addChild(enemi)
        }
        
        
    }
    
    //создаем облака
    fileprivate func spawnClouds(){
        
        let spawnCloudWait = SKAction.wait(forDuration: 1) // время создания
        let spawnCloudAction = SKAction.run { // действие создания
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction]) // двойное действие
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
    }
    
    // создаем остава
    fileprivate func spawnIslands(){
        
        let spawnIslandWait = SKAction.wait(forDuration: 2)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
    fileprivate func configureStartScene(){
        let screenCentrPoint = CGPoint(x: self.size.width/2, y: self.size.height/2) // центр экрана
        let background = Background.populeteBackground(at: screenCentrPoint)
        background.size = self.size // растягиваем изображение на весь экран
        self.addChild(background) // устанавливем фон на экран
        
        let screen = UIScreen.main.bounds //размер экрана
        
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width/2, y: 200))
        self.addChild(player)
        
        
    }
    
    override func didSimulatePhysics() {
        
        player.checkPosition() // не дает плееру уйти за границу
        player.performFly() // управление акселерометром
        
        // функция опознает все объекты на странице по имении
        enumerateChildNodes(withName: "backgroundSprite") { (node, stop) in
            if node.position.y < -190{
                node.removeFromParent() // удаляем объект, если он ниже нуля
            }
        }
        
    }
    
}

//
//  GameScene.swift
//  SkyBall1
//
//  Created by Алексей Карпежников on 08/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let screen = UIScreen.main.bounds
    let playerBall = PlayerBall.populate()
    var firstTouch: CGFloat = 0
    
    let motionMeneger = CMMotionManager()
    var xAccelerate: CGFloat = 0
    
    let methodConntrol = true // true - акселерометр, false - обычное
    
    override func didMove(to view: SKView) {
        
        self.view!.isMultipleTouchEnabled = true // для получения всех касаний по экрану
        
        configureStartScene()
        let daedLine = DispatchTime.now() + .nanoseconds(1)
        DispatchQueue.main.asyncAfter(deadline: daedLine) { [unowned self] in
            self.addTreeBranch()
        }
        
        
        self.addChild(playerBall)
    
    }
    
    fileprivate func configureStartScene(){

        let screenCentrPoint = CGPoint(x: screen.size.width/2, y: screen.size.height/2) // центр экрана
        let background = Background.populeteBackground(at: screenCentrPoint)
        self.addChild(background) // устанавливем фон на экран
        
    }
    
    fileprivate func addTreeBranch(){
        
        let spawnTreeBranchWait = SKAction.wait(forDuration: 1)
        let spawnTreeBranchAction = SKAction.run { [unowned self] in
            let treeBranch = TreeBranch.populate(at: nil)
            self.addChild(treeBranch)
        }
        
        let spawnTreeBranchSequence = SKAction.sequence([spawnTreeBranchWait, spawnTreeBranchAction])
        let spawnTreeBranchForever = SKAction.repeatForever(spawnTreeBranchSequence)
        run(spawnTreeBranchForever)
        
        
    }
    
    override func didSimulatePhysics() {
        
        //playerBall.borderPlayerBall()
        // функция опознает все объекты на странице по имении
        enumerateChildNodes(withName: "treeBranch") { (node, stop) in
            if node.position.y < -50{
                node.removeFromParent() // удаляем объект, если он ниже нуля
            }
        }
        
        if methodConntrol{
            playerBall.accelerateControl()
        }
        
    }
    

        
    
    // метод просто отслеживает касание
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // определяем первое касание, если его нет то, ставим половину экрана
        firstTouch = touches.first?.location(in: self).x ?? screen.size.width/2
        
    }
    
    // метод отслеживает движение по экрану (для управления playerBall)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self.view).x
        // ф-я для управления (нужно доработать )
        if !methodConntrol{
            playerBall.normalContril(at: location!)
        }
        
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
        
    
    
    
}

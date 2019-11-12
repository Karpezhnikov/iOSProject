//
//  MainMenu.swift
//  SpaceShoter
//
//  Created by Алексей Карпежников on 01/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    var starField: SKEmitterNode!
    
    var newGameButtonNode:SKSpriteNode!
    var levelButtonNode:SKSpriteNode!
    var labelLevel:SKLabelNode!
    var labelRecord:SKLabelNode!
    var labelTitle:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        // 750 * 1334
        starField = self.childNode(withName: "starFieldAnimation") as? SKEmitterNode
        starField.advanceSimulationTime(10)
        
        labelTitle = self.childNode(withName: "TitleLadel") as? SKLabelNode
        labelTitle.position = CGPoint(x: 375, y: 1100)
        labelTitle.fontName = "AmericanTypewriter-Bold" // устанавливаем шрифт
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "startGame")
        newGameButtonNode.position = CGPoint(x: 375, y: 1334*0.6)
        
        levelButtonNode = self.childNode(withName: "levelButton") as? SKSpriteNode
        levelButtonNode.texture = SKTexture(imageNamed: "levalButton")
        levelButtonNode.position = CGPoint(x: newGameButtonNode.position.x, y: newGameButtonNode.position.y - levelButtonNode.size.height - 10)
        
        labelLevel = self.childNode(withName: "labelLevel") as? SKLabelNode
        labelLevel.position = CGPoint(x: newGameButtonNode.position.x, y: levelButtonNode.position.y - labelLevel.frame.size.height*2)
        labelLevel.fontName = "AmericanTypewriter-Bold" // устанавливаем шрифт
        
        labelRecord = self.childNode(withName: "record") as? SKLabelNode
        labelRecord.position = CGPoint(x: newGameButtonNode.position.x, y: newGameButtonNode.position.y + labelRecord.frame.size.height*2)
        labelRecord.text = "Рекорд \(UserDefaults.standard.integer(forKey: "UserRecord"))"
        labelRecord.fontName = "AmericanTypewriter-Bold" // устанавливаем шрифт
        
        let userLevel = UserDefaults.standard
        if userLevel.bool(forKey: "hard"){
            labelLevel.text = "Сложно"
        }else{
            labelLevel.text = "Легко"
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nidesArray = self.nodes(at: location)
            
            if nidesArray.first?.name == "newGameButton"{
                //let transmition = SKTransition.self
                let gameScene = GameScene(size: (self.view?.frame.size)!)
                self.view?.presentScene(gameScene)
            }else if nidesArray.first?.name == "levelButton"{
                changeLevel()
            }
        }
    }
    
    func changeLevel(){
        let userLevel = UserDefaults.standard
        
        switch labelLevel.text {
        case "Легко":
            labelLevel.text = "Сложно"
            userLevel.set(true, forKey: "hard")
        default:
            labelLevel.text = "Легко"
            userLevel.set(false, forKey: "hard")
        }
        userLevel.synchronize()
    }
    
}

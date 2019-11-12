//
//  PowerUP.swift
//  WarFly
//
//  Created by Алексей Карпежников on 07/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUP: SKSpriteNode {

    let initalSize = CGSize(width: 52, height: 52)
    let textureAtlas = SKTextureAtlas(named: "powerUP")
    var animationSpriteArray = [SKTexture]()
    
    init() {
        let greenTexture = textureAtlas.textureNamed("powerUP3@3x")
        super.init(texture: greenTexture, color: .clear, size: initalSize)
        self.name = "powerUP"
        self.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pevformRotation(){
        for i in 1...5{
            //let number = String(format: "%d", i)
            let texture = SKTexture(imageNamed: "powerUP\(i)@3x")
            animationSpriteArray.append(texture)
        }
        print("COUNT animationSpriteArray = ", animationSpriteArray.count)
        let rotation = SKAction.animate(withNormalTextures: self.animationSpriteArray, timePerFrame: 1, resize: true, restore: false)
        let rotationForever = SKAction.repeatForever(rotation)
        self.run(rotationForever)
        SKTexture.preload(animationSpriteArray){
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
}

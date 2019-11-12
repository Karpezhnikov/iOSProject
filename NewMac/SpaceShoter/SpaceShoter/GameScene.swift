//
//  GameScene.swift
//  SpaceShoter
//
//  Created by Алексей Карпежников on 30/09/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//  iphone XR self.frame.size.width = 750.0, self.frame.size.height = 1334.0 scoreLabel.frame.size.width

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var starField: SKEmitterNode! // звездное небо
    var player: SKSpriteNode! // игрок
    var scoreLabel: SKLabelNode! // для отображения счета
    var HealthBar: SKSpriteNode!
    var lifeIcon: SKSpriteNode!
    var buttonPause: SKSpriteNode!
    var worldNode = SKNode()
    var score: Int = 0{ // для расчета счета
        didSet{
            scoreLabel.text = "Счет: \(score)"
        }
    }
    var gameTimer: Timer! // таймер для запуска ф-и создание объекта
    var aliens = ["alien", "alien2","alien3"] // массив имен картинок
    
   
    let alienCategory:UInt32 = 0x1 << 1 //для маски???? надо разобраться
    let bulletCategory:UInt32 = 0x1 << 0 //для маски???? надо разобраться
    let playerCategory:UInt32 = 0x1 << 2
    
    let motionMeneger = CMMotionManager()
    var xAccelerate: CGFloat = 0
    
    var arrayIndexPosLife = [CGFloat]() // массив значаний position.x
    let countLife = 5
    var arrayLife = [SKSpriteNode]() // массив созданных жизней
 
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = .zero // начало отсчета с левого нижнего угла
        
        
        
        let backgraund: SKSpriteNode = SKSpriteNode(imageNamed: "backgraundFon")
        backgraund.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height)
        starField = SKEmitterNode(fileNamed: "Starfield") // присваиваем файл для анимации
        starField.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height) // обозначаем позицию анимации
        starField.advanceSimulationTime(10) // пропускаем первые 10 сек анимации (чтобы сразу было небо)
        starField!.zPosition = 0 // для того чтобы задний фон всегда был сзади
        self.addChild(backgraund) // добавляем объект на экран
        
        
        player = SKSpriteNode(imageNamed: "shuttle") // присваем картинку игроку
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // задаем размер
        player.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 200) // устанавливаем угрока на центр
        player.setScale(2) // увеличиваем размер в 2 раза
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCategory // привязка
        player.physicsBody?.contactTestBitMask = alienCategory // на что мы будем проверять
        player.physicsBody?.collisionBitMask =  0
        self.addChild(player) // добавляем игрока на сцену
        
        createLifi()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // отключаем физику
        //self.physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        self.scene?.physicsWorld.contactDelegate = self // позволит отслеживать соприкосновение в игре
        
        scoreLabel = SKLabelNode(text: "Счет: 0") // устанавливаем дефолтное значение для лейбла
        scoreLabel.fontName = "AmericanTypewriter-Bold" // устанавливаем шрифт
        scoreLabel.fontSize = 20 // устаначливаем размер шрифта
        scoreLabel.color = .white // устанавливаем цвет
        scoreLabel.position = CGPoint(x: scoreLabel.frame.size.width, y: (UIScreen.main.bounds.size.height - scoreLabel.frame.size.width)) // устанавливаем позицию (self.frame.size.width - размер экрана)
        score = 0 // устанавливаем начальное значение счетчика
        
        self.addChild(scoreLabel) // выводим лейбл на экран
        
        // ставим уровень сложности
        var timeInterval = 0.75
        if UserDefaults.standard.bool(forKey: "hard"){
            timeInterval = 0.3
        }
        
        // функция которая запускается addAlien каждые 0.75 сек
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        // используем акселерометр для передвижения карабля
        motionMeneger.accelerometerUpdateInterval = 0.2
        motionMeneger.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data{
                let acceleration = accelerometrData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
        }
        
    }
    
    override func didSimulatePhysics() {
        
        let maxPositionX = UIScreen.main.bounds.size.width - player.frame.size.width/2
        let minPositionX = player.frame.size.width/2
        
        player.position.x += xAccelerate * 50 // получаем значение акселерометра
        if player.position.x < minPositionX { // ставим ораничения слева
            //player.position = CGPoint(x: UIScreen.main.bounds.size.width, y: player.position.y)
            player.position = CGPoint(x: minPositionX, y: player.position.y)
        }else if player.position.x > maxPositionX{ // ставим ораничения справа
            player.position = CGPoint(x: maxPositionX, y: player.position.y)
        }
        
    }
    

    
    func didBegin(_ contact: SKPhysicsContact) {
        var alienBody: SKPhysicsBody
        var buletBody: SKPhysicsBody
        
        // Если alien с кораблем
        if contact.bodyA.categoryBitMask == 0x1 << 2 && contact.bodyB.categoryBitMask == 0x1 << 1{
            if arrayLife.count == 1{
                do{
                    let alienNode = contact.bodyB.node as! SKSpriteNode // получаем объект столкновения с короблем
                    let lifeNode = arrayLife.removeFirst() // вытаскиваем и удаляем жизнь из массива
                    collisionElements(elementNodeDel: lifeNode, elemantNodeDelExp: alienNode)
                }
                if UserDefaults.standard.integer(forKey: "UserRecord") < score{
                    UserDefaults.standard.set(score, forKey: "UserRecord") // сохраняем рекорт
                }
                //  и должны как-то закончить игру
//                scene?.view?.isPaused = true
//                //worldNode = SKSpriteNode(color: SKColor.purple, size: CGSize(width: 100, height: 100))
//                worldNode = SKSpriteNode(imageNamed: "startGame")
//                worldNode.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
//                worldNode.zPosition = 1000
//                addChild(worldNode)
                
                
            }else if arrayLife.count > 0{
                do{
                    let alienNode = contact.bodyB.node as! SKSpriteNode // получаем объект столкновения с короблем
                    let lifeNode = arrayLife.removeFirst()
                    collisionElements(elementNodeDel: lifeNode, elemantNodeDelExp: alienNode)
                }
            }
        // Если bulet с alien
        }else{
            buletBody = contact.bodyB
            alienBody = contact.bodyA
            do {
                let alienNode = contact.bodyA.node as! SKSpriteNode
                let buletNode = contact.bodyB.node as! SKSpriteNode
                // вызываем функцию collisionElements
                if (alienBody.categoryBitMask & alienCategory) != 0 && (buletBody.categoryBitMask & bulletCategory) != 0 {
                    collisionElements(elementNodeDel: buletNode, elemantNodeDelExp: alienNode)
                }
            }
        }
    }

    func createLifi(){
        // получаем расстояние между каждым объектом (+ 2 с учетом отступа от границ)
        let sizewidth = UIScreen.main.bounds.size.width/CGFloat(countLife+2)
        var sizewidthLife = CGFloat() // создаем переменую чтобы вписывать position.x
        
        var i = countLife + 2 // для цыкла
        while i > 0 {
            arrayIndexPosLife.append(sizewidthLife) // заполняем массив position.x
            sizewidthLife += sizewidth // каждый раз отспуп слева будет больше
            i -= 1
        }
        
        arrayIndexPosLife.removeFirst() //удаляем первый элемент index = 0 (для первого отступа слева)
        
        for positionX in arrayIndexPosLife{ // создаем countLife элементов на одинаковом расстоянии
            lifeIcon = SKSpriteNode(imageNamed: "life")
            lifeIcon.physicsBody = SKPhysicsBody(rectangleOf: lifeIcon.size)
            lifeIcon.position = CGPoint(x: positionX, y: lifeIcon.frame.size.height)
            lifeIcon.zPosition = 4
            lifeIcon.physicsBody?.collisionBitMask =  0
            arrayLife.append(lifeIcon)
            self.addChild(lifeIcon)
        }
    }
    
    // функция удаляем 2 элемента и на их месте делает взрыв(нужно переименовать)
    func collisionElements(elementNodeDel:SKSpriteNode, elemantNodeDelExp:SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Vzriv")
        explosion?.position = elemantNodeDelExp.position
        self.addChild(explosion!)
        
        //self.run(SKAction.playSoundFileNamed("vzriv.mp3", waitForCompletion: false))
        
        elementNodeDel.removeFromParent()
        elemantNodeDelExp.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
        }
        score += 5
    }

    
    @objc func addAlien(){
    
        // выбираем рандомные НАЗВАНИЯ картинок из списка
        aliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: aliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: aliens[0]) // создаем объект картинку
        // рандом для определения позиции объекта по X
        let randomPos = GKRandomDistribution(lowestValue: Int(alien.frame.size.width), highestValue: Int(UIScreen.main.bounds.size.width-alien.frame.size.width))
        let pos = CGFloat(randomPos.nextInt())
        alien.position = CGPoint(x: pos, y: UIScreen.main.bounds.size.height + alien.size.height) // определяем позицию, где появится объект
        alien.setScale(2) // увеличиваем объект в 2 раза
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size) // устанавливаем размер врага
        alien.physicsBody?.isDynamic = true // сделаем его динамичным чтобы отслеживать
        
        alien.physicsBody?.categoryBitMask = alienCategory // к какой категории относится обьект
        alien.physicsBody?.contactTestBitMask = playerCategory | bulletCategory // уведовлять о соприкосновениями с
        alien.physicsBody?.collisionBitMask =  0 // с какими может сталкиваться
        
        //alien.physicsBody?.usesPreciseCollisionDetection = true // объект может cоприкосаться с другими
        
        self.addChild(alien) // добавляем объект на экран
        
        var animDuration: TimeInterval = 4 // скорость объекта alien
        if UserDefaults.standard.bool(forKey: "hard"){
            animDuration = 2
        }
        
        var actions = [SKAction]() // создаем массив действий
        // перемещаем объект в указаное место (to - куда переместить, duration - за какое время)
        actions.append(SKAction.move(to: CGPoint(x: pos, y: 0), duration: animDuration))
        // удаляем действие, что не циклилось
        actions.append(SKAction.removeFromParent())
        // воспроизводим действие
        alien.run(SKAction.sequence(actions))
        
    }
    
    // определяем касание по экрану
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    
    // ф-я проигрываем звук
    func fireBullet(){
        //self.run(SKAction.playSoundFileNamed("vzriv.mp3", waitForCompletion: false))
        // waitForCompletion - если нужно выполнить действие после звука
        
        let bulet = SKSpriteNode(imageNamed: "torpedo") // получаем картинку
        bulet.position = player.position // устанавливаем начальную позицию объекта
        bulet.position.y += 5 // ставим чуть выше корабля
        
        bulet.physicsBody = SKPhysicsBody(circleOfRadius: bulet.size.width/2) // устанавливаем размер врага
        bulet.physicsBody?.isDynamic = true // сделаем его динамичным чтобы отслеживать
        bulet.setScale(2) // увеличиваем объект в 2 раза
        
        bulet.physicsBody?.categoryBitMask = bulletCategory // привязка
        bulet.physicsBody?.contactTestBitMask = alienCategory // на что мы будем проверять
        bulet.physicsBody?.collisionBitMask =  0 //
        bulet.physicsBody?.usesPreciseCollisionDetection = true // объект может cоприкосаться с другими
        
        self.addChild(bulet) // добавляем объект на экран
        
        let animDuration: TimeInterval = 0.3 // создаем интервал
        var actions = [SKAction]() // создаем массив действий
        // перемещаем объект в указаное место
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: UIScreen.main.bounds.size.height + bulet.size.height), duration: animDuration))
        // удаляем действие, чтобы не циклилось
        actions.append(SKAction.removeFromParent())
        // воспроизводим действие
        bulet.run(SKAction.sequence(actions))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

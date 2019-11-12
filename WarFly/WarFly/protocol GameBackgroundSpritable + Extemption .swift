//
//  protocol GameBackgroundSpritable + Extemption .swift
//  WarFly
//
//  Created by Алексей Карпежников on 04/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameBackgroundStriteable {
    // Self - значит что должен вернуться либо тип протокола,
    // либо тип класса где используется протокол
    static func populate(at point: CGPoint?)-> Self
    static func randomPoint() -> CGPoint
}
extension GameBackgroundStriteable{
    // создает рандомно позицию объекта на экране
    static func randomPoint()->CGPoint{
        let screen = UIScreen.main.bounds
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 400, highestValue: Int(screen.size.height) + 500)
        let y: CGFloat = CGFloat(distribution.nextInt()) // от lowestValue до highestValue
        let x: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width))) // от 0 до upperBound
        return CGPoint(x: x, y: y)
    }
}

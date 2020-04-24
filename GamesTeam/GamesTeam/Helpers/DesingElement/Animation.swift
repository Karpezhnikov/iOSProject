//
//  Animation.swift
//  GamesTeam
//
//  Created by kam_team on 11.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class AnimateUI{
    
    static let defoultDuration:Double = 1.0 // дефолтное значение для времени анимации (в секундах)
    // общая анимация (появление или исчезновение элемента) для всех подклассов класса UIView
    static func animateAlpha<Element: UIView>(element: Element, toAlpha: CGFloat, animateRunTime: Double = 0.0){
        let time = (animateRunTime == 0.0) ? defoultDuration : animateRunTime
        UIView.animate(withDuration: time, animations: {
            element.alpha = toAlpha
        })
    }
    
    static func animateShadow<Element: UIView>(element: Element, toShadowOpacity: Float, animateRunTime: Double = 0.0){
        let time = (animateRunTime == 0.0) ? defoultDuration : animateRunTime
        let oldShadowOpacity = element.layer.shadowOpacity
        // сначала увеличиваем shadowOpacity
        UIView.animate(withDuration: time, animations: {
            element.layer.shadowOpacity = toShadowOpacity
        })
        // потом востанавливаем
        UIView.animate(withDuration: time, animations: {
            element.layer.shadowOpacity = oldShadowOpacity
        })
    }
}

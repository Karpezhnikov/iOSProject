//
//  AnimateUI.swift
//  Flamingo
//
//  Created by mac on 20/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation
import UIKit

class AnimateUI{
    
    let defoultDuration:Double = 1.0 // дефолтное значение для времени анимации (в секундах)

    // общая анимация (появление или исчезновение элемента) для всех подклассов класса UIView
    func animateAlpha<Element: UIView>(element: Element, toAlpha: CGFloat, animateRunTime: Double = 0.0){
        let time = (animateRunTime == 0.0) ? defoultDuration : animateRunTime
        UIView.animate(withDuration: time, animations: {
            element.alpha = toAlpha
        })
    }
    
    // для перехода между экранами
    func nextViewController(viewController: UIViewController){
        let transition = CATransition()

        transition.duration = 2.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        viewController.navigationController?.view.layer.add(transition, forKey: nil)
        viewController.navigationController?.pushViewController(ViewController(), animated: false)
    }
}

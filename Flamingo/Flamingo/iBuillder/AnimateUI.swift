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
    
    let defoultDuration:Double = 3.0 // дефолтное значение для времени анимации (в секундах)
    // для воспроизведения анимации кнопки
    func buttonAnimateAlfa(button: UIButton, toAlfa: CGFloat, time: Double = 0.0){
        let time = (time == 0.0) ? defoultDuration : time
        UIView.animate(withDuration: time, animations: {
            button.alpha = toAlfa
        })
    }
    
    // для воспроизведения анимации label
    func labelAnimateAlfa(button: UILabel, toAlfa: CGFloat, time: Double = 0.0){
        let time = (time == 0.0) ? defoultDuration : time
        UIView.animate(withDuration: time, animations: {
            button.alpha = toAlfa
        })
    }
    
    // для воспроизведения анимации UIImageView
    func imageAnimateAlfa(button: UIImageView, toAlfa: CGFloat, time: Double = 0.0){
        let time = (time == 0.0) ? defoultDuration : time
        UIView.animate(withDuration: time, animations: {
            button.alpha = toAlfa
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

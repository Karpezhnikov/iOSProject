//
//  TabBarVC.swift
//  Flamingo
//
//  Created by Алексей Карпежников on 08/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.shadowImage = UIImage()
        
    }

    // анимация для значков тап бара ()
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // find index if the selected tab bar item, then find the corresponding view and get its image, the view position is offset by 1 because the first item is the background (at least in this case)
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.first as? UIImageView else {
            return
        }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }

}

//
//  SetupTabBarVC.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class SHCircleBarController: UITabBarController {

//    var tabBarHeight = CGFloat()
//    @IBOutlet weak var tabBarCustom: UITabBar!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tabBarCustom.backgroundColor = UIColor.clear
//        self.tabBarCustom.barTintColor = UIColor.clear
//        self.tabBarCustom.backgroundImage = UIImage()
//        //self.tabBarCustom.itemPositioning = .fill
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        //self.tabBarHeight = 60
//    }
//
//    // анимация для значков тап бара ()
//    private var bounceAnimation: CAKeyframeAnimation = {
//        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
//        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
//        bounceAnimation.duration = TimeInterval(0.3)
//        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
//        return bounceAnimation
//    }()
//
////    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
////        // find index if the selected tab bar item, then find the corresponding view and get its image, the view position is offset by 1 because the first item is the background (at least in this case)
////        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.first as? UIImageView else {
////            return
////        }
////        imageView.layer.add(bounceAnimation, forKey: nil)
////    }

}

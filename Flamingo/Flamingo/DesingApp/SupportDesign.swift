//
//  SupportDesign.swift
//  Flamingo
//
//  Created by mac on 21/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

//MARK: UIImageView
extension UIImageView{
    func imageCornerRadiusPlusBorder(){
        self.layoutIfNeeded()
        let widthUIScreen = UIScreen.main.bounds.size.width
        let widthUIImageView = self.frame.size.width
        let koef = widthUIImageView/widthUIScreen
        self.clipsToBounds = true
        self.layer.cornerRadius = (koef*widthUIScreen)/2
        self.layer.borderWidth = BorderWidth.borderWidth
        self.layer.borderColor = ColorApp.white.cgColor
        
        

//        imageLayer = CAShapeLayer()
//        imageLayer.frame = self.bounds
//        imageLayer.mask = mask
//        imageLayer.contentsGravity = kCAGravityResizeAspectFill
//        layer.addSublayer(imageLayer)
    }
    
}

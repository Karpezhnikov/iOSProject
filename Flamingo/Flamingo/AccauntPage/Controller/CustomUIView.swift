//
//  CustomUIView.swift
//  
//
//  Created by mac on 23/01/2020.
//

import UIKit

class CustomUIView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
        self.layer.borderColor = ColorApp.white.cgColor
        self.backgroundColor = ColorApp.white.withAlphaComponent(0.1)
        
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
//        self.layer.shadowRadius = 5
//        self.layer.shadowOpacity = 1
//        self.layer.masksToBounds = false
        
    }
}

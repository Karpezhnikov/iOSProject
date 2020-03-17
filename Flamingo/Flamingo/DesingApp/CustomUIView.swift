//
//  CustomUIView.swift
//  Flamingo
//
//  Created by kam_team on 17.03.2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomUIView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorApp.white.withAlphaComponent(0.1)
        self.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.01
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

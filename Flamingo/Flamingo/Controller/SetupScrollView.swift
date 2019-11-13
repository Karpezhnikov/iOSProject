//
//  ScrollView.swift
//  Flamingo
//
//  Created by mac on 13/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupScrollView: UIScrollView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // настраиваем размер contentView
        self.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}

//
//  File.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupScrollView: UIScrollView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // настраиваем размер contentView
        self.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}

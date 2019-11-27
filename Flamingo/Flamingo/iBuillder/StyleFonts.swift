//
//  StyleFonts.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import Foundation
import UIKit

enum ColorApp {
    static let indigo = UIColor.init(red: 69/255, green: 38/255, blue: 71/255, alpha: 1)
    static let black = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let white = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let lagthGreyColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    static let greenComplete = UIColor.init(red: 69/255, green: 128/255, blue: 66/255, alpha: 1)
    static let clear = UIColor.clear
}

enum BorderWidth{
    static let borderWidth = CGFloat(1)
}

enum Font{
    private static let nameFont = "Baskerville"
    static let fontTitle = UIFont(name: nameFont + "-Bold", size: CGFloat(25))
    static let fontSubTitle = UIFont(name: nameFont + "-Bold", size: CGFloat(20))
    static let fontRegular = UIFont(name: nameFont, size: CGFloat(15))
    static let fontSmall = UIFont(name: nameFont, size: CGFloat(10))
}


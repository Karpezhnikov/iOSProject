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
    static let indigo = UIColor.init(red: 52/255, green: 0/255, blue: 0/255, alpha: 1)
    static let black = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let white = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
}

enum BorderWidth{
    static let borderWidth = CGFloat(2)
}

/*
Разделим UILabel на теги
tag 1 - Title (Bold, 25)
tag 2 - Title (Bold, 25) + border
tag 3 - SubTitle (Bold, 20)
tag 4 - SubTitle (Bold, 20) + border
tag 5 - Regular (Regular, 15)
tag 6 - Regular (Regular, 15) + border
tag 7 - Small (Regular, 10)
tag 8 - Small (Regular, 10) + border
**/

enum Font{
    static let nameFont = "Baskerville"
    static let fontTitle = UIFont(name: nameFont + "-Bold", size: CGFloat(25))
    static let fontSubTitle = UIFont(name: nameFont + "-Bold", size: CGFloat(20))
    static let fontRegular = UIFont(name: nameFont, size: CGFloat(15))
    static let fontSmall = UIFont(name: nameFont, size: CGFloat(10))
}


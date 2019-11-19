//
//  SetupTextField.swift
//  Flamingo
//
//  Created by mac on 19/11/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = BorderWidth.borderWidth
        self.layer.borderColor = ColorApp.indigo.cgColor
        self.font = Font.fontRegular
        //self.
        
        self.layer.cornerRadius = 10
    }

}




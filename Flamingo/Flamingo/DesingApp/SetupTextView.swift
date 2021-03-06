//
//  SetupTextView.swift
//  Flamingo
//
//  Created by mac on 09/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class SetupTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }

    private func setupTextView(){
        self.layer.cornerRadius = self.frame.size.width * 0.01
        self.layer.borderWidth = BorderWidth.borderWidth
        self.layer.borderColor = ColorApp.white.cgColor
        self.backgroundColor = ColorApp.black
        self.textColor = ColorApp.white
        self.font = Font.fontRegular
        self.inputAccessoryView = addDoneButtonOnKeyboard()//добавление кнопки "Готово"
        
    }
    
    func addDoneButtonOnKeyboard() -> UIToolbar{
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.endEditing(true)
    }
}

//
//  Extensions.swift
//  GamesTeam
//
//  Created by kam_team on 02.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//
import UIKit

//MARK: - UIColor
extension UIColor{
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

//MARK: - UIButton
extension UIButton{
    public func setupButtonOval(){
        self.layer.cornerRadius = self.frame.size.height/2
        self.titleLabel?.font = UIFont(name: FontApp.appleSDBold, size: 15)
        self.setTitleColor(ColorApp.whiteApp, for: .normal)
    }
    
    public func setupBuyActive(){
        self.setupButtonOval()
        self.backgroundColor = ColorApp.whiteApp
        self.layer.borderWidth = SettingsApp.borderWidth
        self.layer.borderColor = ColorApp.greenApp?.cgColor
        self.setTitleColor(ColorApp.blackApp, for: .normal)
    }
    
    public func changeButton(_ hidden: Bool){
        if hidden{
            self.alpha = 1
            self.isUserInteractionEnabled = true
        }else{
            self.alpha = 0.7
            self.isUserInteractionEnabled = false
        }
    }
    
    //устанавливает кнопку покупки
    public func setupButtonBuy(_ sale: String, _ isBuy: Bool){
        self.setupButtonOval()
        self.backgroundColor = ColorApp.ligthGrey
        if !sale.isEmpty{ //если есть цена
            if isBuy{ // если игра куплена
                self.setTitle("Есть", for: .normal)
                self.changeButton(false)
            }else{ //если не куплена
                self.setTitle("Купить: " + sale + " p", for: .normal)
                self.setupBuyActive()
            }
        }else{ //если нет цены
            self.setTitle("Бесплатно", for: .normal)
            self.changeButton(false)
        }
    }
    
    //устанавливает кнопку игры
    public func setupButtonPlay(_ sale: String, _ isBuy: Bool){
        self.setupButtonOval()
        self.backgroundColor = ColorApp.greenApp
        if !sale.isEmpty{ //если есть цена
            if isBuy{ // если игра куплена
                self.changeButton(true)
            }else{ //если не куплена
                self.changeButton(false)
            }
        }else{ //если нет цены
            self.changeButton(true)
        }
    }
}

//MARK: - UIView
extension UIView{
    public func setupOvalView(){
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    public func shadowIsOnView(_ shadowColor: UIColor?, shadowOpacity: Float){
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOpacity = shadowOpacity
    }
}

//MARK: - UILabel
extension UILabel{
    public func setupCountPlayers(minPlayers: Int, maxPlayers: Int?){
        if maxPlayers == nil || maxPlayers == 0{
            self.text = "\(minPlayers) - ..."
        }else{
            self.text = "\(minPlayers) - \(maxPlayers!)"
        }
    }
    
}

//MARK: - Table View
extension UITableView {

    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.filter {
                if $0.firstAttribute == .height, $0.relation == .equal {
                    return true
                }
                return false
                }.first
        }
        set{ setNeedsLayout() }
    }

    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.filter {
                if $0.firstAttribute == .width, $0.relation == .equal {
                    return true
                }
                return false
                }.first
        }
        set{ setNeedsLayout() }
    }
}

//MARK: - UITextField
extension UITextField{
    
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

//MARK: - Array
extension Array {
    // перемешивает массив
    mutating func shuffled() {
        for _ in self {
            // generate random indexes that will be swapped
            var (a, b) = (Int(arc4random_uniform(UInt32(self.count - 1))), Int(arc4random_uniform(UInt32(self.count - 1))))
            if a == b { // if the same indexes are generated swap the first and last
                a = 0
                b = self.count - 1
            }
            self.swapAt(a, b)
        }
    }
}

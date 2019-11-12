//
//  RatingControl.swift
//  TableViewApp
//
//  Created by Алексей Карпежников on 16/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

//@IBDesignable - это позволит отобразить контент в интерфейс билдере
// и все изменения в реальном времени буду отображаться в интерфейсе билдере
@IBDesignable class RatingControl: UIStackView {

    // MARK: Properties
    var rating = 0{
        didSet{
            updateButtonSelectionState()
        }
    }
    private var ratingButtons = [UIButton]()
    
    //@IBInspectable - для того чтобы интерфейс билдер видел изменения
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{ // для отслежавания отзмения значения в реальном времени
            setupButtons()
        }
    } // отвечает за размер звезд
    @IBInspectable var starCount: Int = 5{
        didSet{ // для отслежавания отзмения значения в реальном времени
            setupButtons()
        }
    } // отвечает за количество звезд

    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // обязательная инициальзация
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Action
    @objc func ratingButtonTrapped(button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else {
            return
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        if selectedRating == rating{
            rating = 0
        }else{
            rating = selectedRating
        }
        
    }
    
    // MARK: Private Methods
    private func setupButtons(){
        
        // delete all buttons
        for button in ratingButtons{
            removeArrangedSubview(button) // удаляем все звезды для создания новых
            button.removeFromSuperview()
            
        }
        
        ratingButtons.removeAll() // очищаем массив
        
        // Load button Image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let higthLithedStar = UIImage(named: "highlightedStar",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        
        
        // creat the button
        for _ in 0..<starCount{
            let button = UIButton()
            
            // Set the button image
            button.setImage(emptyStar, for: .normal) // прозрачная если не нажата
            button.setImage(filledStar, for: .selected) // черная при нажатии
            button.setImage(higthLithedStar, for: .highlighted) // синяя после нажатия
            button.setImage(higthLithedStar, for: [.highlighted, .selected]) // синяя при удерживании
            
            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false // отключает автоматические констреинты
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true // для создания констреинтов высоты
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true // для создания констреинтов ширины
            
            // setup the button action
            button.addTarget(self, action: #selector(ratingButtonTrapped(button:)), for: .touchUpInside)
            
            // add the button to the stack view
            addArrangedSubview(button) // добавляем кнопку в stack view
            
            // add the new button on the rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
        }
    }
}

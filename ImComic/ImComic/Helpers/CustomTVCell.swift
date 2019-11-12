//
//  CustomTVCell.swift
//  ImComic
//
//  Created by Алексей Карпежников on 23/10/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class CustomTVCell: UITableViewCell {
    
    var like = false // true - like on, false - like off
    
    @IBOutlet weak var nicNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var textJoke: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // setup TextView
        textJoke.layer.cornerRadius = CGFloat(5)
        textJoke.layer.borderWidth = CGFloat(1)
        //textJoke.isUserInteractionEnabled = true
        textJoke.isEditable = false
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if like{
            likeButton.setImage(UIImage(named: "LikeOff"), for: .normal)
            like = !like
        }else{
            likeButton.setImage(UIImage(named: "LikeON"), for: .normal)
            like = !like
        }
    }
    
    @IBAction func favoritesAction(_ sender: Any) {
    }
    
    @IBAction func forwardAction(_ sender: Any) {
    }
    
}

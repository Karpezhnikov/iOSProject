//
//  TableViewCell.swift
//  GamesTeam
//
//  Created by kam_team on 13.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class CellGameProcess: UITableViewCell {

    @IBOutlet weak var gameProcess: UILabel!
    @IBOutlet weak var viewGameProcess: UIView!
    @IBOutlet weak var imageLessGo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewGameProcess.layer.cornerRadius = SettingsApp.cornerRadius
        self.selectionStyle = .none
    }

    func setBackgroundColor(_ qoa: QOA){
        switch qoa {
        case .action:
            self.viewGameProcess.backgroundColor = ColorApp.purple?.withAlphaComponent(0.5)
        case .question:
            self.viewGameProcess.backgroundColor = ColorApp.orange?.withAlphaComponent(0.5)
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class GameProcessTrueAndAction{
    var bodyGameProcess: String = ""
    var process: QuestionsAndActions? = nil
    
    init(bodyGameProcess: String, process: QuestionsAndActions) {
        switch process.qoa {
        case .action:
            self.bodyGameProcess = "\(bodyGameProcess), выбирает Действие"
        case .question:
            self.bodyGameProcess = "\(bodyGameProcess), выбирает Правду"
        default:
            self.bodyGameProcess = "\(bodyGameProcess), выбирает Что-то"
        }
        self.process = process
    }
}

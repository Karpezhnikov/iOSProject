//
//  PresentRulesVC.swift
//  GamesTeam
//
//  Created by kam_team on 21.04.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class PresentRulesVC: UIViewController {
    
    var arrayRules = Array<String>()
    
    @IBOutlet weak var tableViewRules: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewRules.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func closeCV(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Table View
extension PresentRulesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellRule", for: indexPath) as? RuleTVC else{
            return UITableViewCell()
        }
        cell.ruleInfo.text = arrayRules[indexPath.row]
        return cell
    }
    
    
}

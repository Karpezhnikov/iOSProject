//
//  PresentCommentsVC.swift
//  Flamingo
//
//  Created by mac on 04.02.2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class PresentCommentsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


}

extension PresentCommentsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
}

//
//  HomeTVC.swift
//  Flamingo
//
//  Created by mac on 17/12/2019.
//  Copyright © 2019 Алексей Карпежников. All rights reserved.
//

import UIKit

class HomeTVC: UITableViewController {

    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func segmentControllAction(_ sender: Any) {
        switch segmentControll.selectedSegmentIndex{
        case 0:
            self.tableView.scrollToRow(at: IndexPath(row: 2, section: 1), at: UITableView.ScrollPosition.bottom, animated: true)
        default:
            self.tableView.scrollToRow(at: IndexPath(row: 1, section: 1), at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 4
        }
        //return 0
    }
    
    // ставим размеры секции в зависимости от размера tableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return tableView.frame.size.height * 0.3
        }else{
            return tableView.frame.size.height * 0.7
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath[1] == 0 && arrayMaster.count > 1{ //при нажатии на выбор мастра, скролим до 1-й, чтобы показать действие
//            tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
//        }
        
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

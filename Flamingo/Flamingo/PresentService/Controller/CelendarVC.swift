//
//  CelendarVC.swift
//  Flamingo
//
//  Created by mac on 28/01/2020.
//  Copyright © 2020 Алексей Карпежников. All rights reserved.
//

import UIKit

class CelendarVC: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarColView: UICollectionView!
    @IBOutlet weak var tableViewTime: UITableView!
    
    let arrayMonth = ["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"]
    let daysOfMonth = ["Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье"]
    let daysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    var firstWeeakDayMonth = Int()
    var service = Service()
    var master = Master()
    var dateDate = Date()
    var arrayDateSetviceEntry = Array<Date>()
    //var indexPathDate = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        currentMonth = arrayMonth[month]
        monthLabel.text = "\(currentMonth), \(year)"
        firstDayMonth(month: month, year: year)
        arrayDateSetviceEntry = FirebaseManager.createDataEntry(timeService: service.timeService)
        self.title = "Выбирете дату и время"
    }
    

    //функция возвращает день недели первого дня месяца
    private func firstDayMonth(month: Int, year: Int){
        let datedate = dateFromString(dateStr: "\(year)-\(month + 1)-01 00:00:00")
        firstWeeakDayMonth = calendar.component(.weekday, from: datedate!) // получили день недели первого числа месяца
        
        switch firstWeeakDayMonth {
        case 1:
            firstWeeakDayMonth = 7
        default:
            firstWeeakDayMonth = firstWeeakDayMonth - 1
        }
    }
    
    //MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifire = segue.identifier
//        else {return}
//        if identifire == "selectDateAndTime"{
//            guard let makeAppr = segue.destination as? MakeAppointmentVC else {return}
//            makeAppr.service = service
//            makeAppr.arrayMaster = masters
//        }
//        if identifire == "presentMaster"{
//            if let indexPath = collectionViewMasters.indexPathsForSelectedItems?.first{
//                guard let destinationVC = segue.destination as? AddNewMasterVC else {return}
//                destinationVC.master = masters[indexPath.row]
//                destinationVC.viewFlg = true
//            }
//        }
//    }
    
    //MARK: Date Formater
    // переводит из теста в дату
    private func dateFromString(dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    // переводит в стринг из даты (в нужную структура даты)
    private func dateFromConvert(_ date: Date, mask: String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = mask
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    @IBAction func actionNextMonth(_ sender: Any) {
        switch currentMonth {
        case "Декабрь":
            month = 0
            year += 1
            firstDayMonth(month: month, year: year)
            currentMonth = arrayMonth[month]
            monthLabel.text = "\(currentMonth), \(year)"
            calendarColView.reloadData()
        default:
            month += 1
            firstDayMonth(month: month, year: year)
            currentMonth = arrayMonth[month]
            monthLabel.text = "\(currentMonth), \(year)"
            calendarColView.reloadData()
        }
    }
    
    @IBAction func actionBackMonth(_ sender: Any) {
        switch currentMonth {
        case "Январь":
            month = 11
            year -= 1
            firstDayMonth(month: month, year: year)
            currentMonth = arrayMonth[month]
            monthLabel.text = "\(currentMonth), \(year)"
            calendarColView.reloadData()
        default:
            month -= 1
            firstDayMonth(month: month, year: year)
            currentMonth = arrayMonth[month]
            monthLabel.text = "\(currentMonth), \(year)"
            calendarColView.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Collection View
extension CelendarVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonths[month] + firstWeeakDayMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarColView.dequeueReusableCell(withReuseIdentifier: "cellCalendar", for: indexPath) as! DateCalendar
        let dayForCell = indexPath.row + 2 - firstWeeakDayMonth //день который нужно записать в ячейку
        if !cell.isUserInteractionEnabled{ //предустановка (иногда, после прокрутки месяца, элементы не активируются)
            cell.isUserInteractionEnabled = true
        }
        if cell.isHidden{ //предустановка (иногда, после прокрутки месяца, элементы не активируются)
            cell.isHidden = false
        }
        cell.backgroundColor = ColorApp.clear
        if (firstWeeakDayMonth-1) > indexPath.row{
            cell.backgroundColor = UIColor.clear
            cell.date.text = ""
            cell.isHidden = true
            cell.date.textColor = ColorApp.white
        }else{
            //получаем дату из collection View
            guard let cellDate = dateFromString(dateStr: "\(year)-\(month + 1)-\(dayForCell) 00:00:00") else {
                cell.backgroundColor = UIColor.clear
                cell.date.text = "\(dayForCell)"
                cell.date.textColor = ColorApp.white
                return cell
            }
            if cellDate < Date(){ // отбрасываем меньшие даты
                cell.date.text = "\(dayForCell)"
                cell.date.textColor = ColorApp.white.withAlphaComponent(0.5)
                cell.isUserInteractionEnabled = false
                return cell
            }else{
                cell.backgroundColor = UIColor.clear
                cell.date.text = "\(dayForCell)"
                cell.date.textColor = ColorApp.white
                return cell
            }
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let widthItem = collectionView.frame.size.width*0.4
        let widthCell = collectionView.frame.size.width/7
    
        let heightItem = collectionView.frame.size.height/5
        return CGSize(width: widthCell, height: heightItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = calendarColView.cellForItem(at: indexPath)
        cell?.backgroundColor = ColorApp.white.withAlphaComponent(0.1)
        let dayForCell = indexPath.row + 2 - firstWeeakDayMonth
        guard let dateDateF = dateFromString(dateStr: "\(year)-\(month + 1)-\(dayForCell) 00:00:00") else {return}
        dateDate = dateDateF
        tableViewTime.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = calendarColView.cellForItem(at: indexPath)
        cell?.backgroundColor = ColorApp.clear
    }
    
    private func setupCollectionView(){
        let spacing = CGFloat(0)
        calendarColView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        self.calendarColView?.collectionViewLayout = layout
    }
    
}

//MARK: Table View
extension CelendarVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDateSetviceEntry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTime", for: indexPath)
        let dateTime = arrayDateSetviceEntry[indexPath.row]
        let time = dateFromConvert(dateTime, mask: "HH:mm")
//        if calendar.component(.hour, from: dateTime) < calendar.component(.hour, from: Date())+3{ // убираем прошедшее время
//            print(dateTime)
//            cell.isHidden = true
//        }
        //"yyyy-MM-dd HH:mm:ss"
        let cellDateTime = dateFromConvert(dateTime, mask: "HH:mm:ss")
        let cellDateDate = dateFromConvert(dateDate, mask: "yyyy-MM-dd")
        let cellDateDateTime = dateFromString(dateStr: "\(cellDateDate) \(cellDateTime)")
        //print(cellDateDateTime)
        if cellDateDateTime! < Date(){ //проверяем дату и убираем прошедшее время
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = "Нет записи"
            cell.detailTextLabel?.text = ""
            cell.textLabel?.textColor = ColorApp.white.withAlphaComponent(0.5)
        }else{
            cell.textLabel?.text = time
            cell.detailTextLabel?.text = dateFromConvert(dateDate, mask: "EEEE, MMMM d")
            cell.textLabel?.textColor = ColorApp.white
            cell.detailTextLabel?.textColor = ColorApp.white
        }
        
        
        return cell
    }
    
    private func timeSelection(){
        
    }
}

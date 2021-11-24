//
//  CalendarPickerVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 10.11.2021.
//

import UIKit

protocol CalendarPickerVCDelegate {
    func didSelectCell(data: CalendarModel)
}

class CalendarPickerVC: UIViewController {
    
    @IBOutlet weak var caledarUV: UICollectionView!
    @IBOutlet weak var monthYearLB: UILabel!
    @IBOutlet weak var previouUB: UIView!
    @IBOutlet weak var nextUB: UIView!
    @IBOutlet weak var conatinerUV: UIView!
    
    let formatter = DateFormatter()
    
    var selectedDate = Date()
    var totalSquares = [CalendarModel]()

    var delegate: CalendarPickerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNextUB)))
        previouUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPreviousUB)))
        
        setCellsView()
        setMonthView()
        
        caledarUV.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        caledarUV.dataSource = self
        caledarUV.delegate = self
    }
    
    func setCellsView() {
        let width = (caledarUV.frame.size.width) / 7
        let flowLayout = caledarUV.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: width)
    }
    
    func setMonthView() {
        totalSquares.removeAll()
        let daysInMonth = CalendarUtil().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarUtil().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarUtil().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        while count <= 42 {
            var item: CalendarModel!
            if count <= startingSpaces  {
                let previousMonth = CalendarUtil().minusMonth(date: selectedDate)
                let yearStr = CalendarUtil().yearString(date: previousMonth)
                let monthStr = CalendarUtil().monthString(date: previousMonth)
                let daysInPreviouseMonth = CalendarUtil().daysInMonth(date: previousMonth)
                let index = daysInPreviouseMonth - (startingSpaces - count)
                let date = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MMMM-dd", date: "\(yearStr)-\(monthStr)-\(index)")
                item = CalendarModel(date: date, title: "\(index)", isInCurrentMonth: false, isSelected: false)
            } else if count - startingSpaces > daysInMonth {
                let index = count - startingSpaces - daysInMonth
                let previousMonth = CalendarUtil().plusMonth(date: selectedDate)
                let yearStr = CalendarUtil().yearString(date: previousMonth)
                let monthStr = CalendarUtil().monthString(date: previousMonth)
                let date = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MMMM-dd", date: "\(yearStr)-\(monthStr)-\(index)")
                item = CalendarModel(date: date, title: "\(index)", isInCurrentMonth: false, isSelected: false)
            } else {
                let index = count - startingSpaces
                let currentDay = CalendarUtil().dayOfMonth(date: Date())
                let yearStr = CalendarUtil().yearString(date: selectedDate)
                let monthStr = CalendarUtil().monthString(date: selectedDate)
                let date = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MMMM-dd", date: "\(yearStr)-\(monthStr)-\(index)")
                item = CalendarModel(date: date, title: "\(index)", isInCurrentMonth: true, isSelected: index == currentDay)
            }
            count += 1
            totalSquares.append(item)
        }
        monthYearLB.text = CalendarUtil().monthString(date: selectedDate) + " " + CalendarUtil().yearString(date: selectedDate)
        caledarUV.reloadData()
    }
    
    @objc func didTapNextUB() {
        selectedDate = CalendarUtil().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    @objc func didTapPreviousUB() {
        selectedDate = CalendarUtil().minusMonth(date: selectedDate)
        setMonthView()
    }

}

//MARK:- Calendar Data Source and Delegate
extension CalendarPickerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.item = totalSquares[indexPath.row]
        return cell
    }
}

extension CalendarPickerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [self] in
            delegate?.didSelectCell(data: totalSquares[indexPath.row])
        }
    }
}

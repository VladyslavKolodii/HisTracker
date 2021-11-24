//
//  CalendarVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 11.11.2021.
//

import UIKit
import CRNotifications
import FirebaseAuth
import DropDown

class CalendarVC: UIViewController {

    @IBOutlet weak var calendarMonthYearLB: UILabel!
    @IBOutlet weak var previousUB: UIView!
    @IBOutlet weak var nextUB: UIView!
    @IBOutlet weak var calendarCV: UICollectionView!
    @IBOutlet weak var sliderUV: UISlider!
    @IBOutlet weak var selectedDayLB: UILabel!
    @IBOutlet weak var selectedMonthYearLB: UILabel!
    @IBOutlet weak var todayLB: UILabel!
    @IBOutlet weak var statusUV: UIView!
    @IBOutlet weak var statusLB: UILabel!
    
    let formatter = DateFormatter()
    var selectedDate = Date()
    var totalSquares = [CalendarModel]()
    var totalMoodDates = [MoodCalendarModel]()
    
    let statusDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dismissMode = .onTap
        dropDown.dataSource = FIRECONFIGSTATUS
        dropDown.direction = .any
        return dropDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        statusLB.text = FIRECONFIGSTATUS.first
        
        nextUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNextUB)))
        previousUB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPreviousUB)))
        
        todayLB.text = CalendarUtil().convertDateToString(dateFormat: "dd MMMM, yyyy", date: Date())
        selectedDayLB.text = CalendarUtil().convertDateToString(dateFormat: "dd", date: Date()) + CalendarUtil().getDaySuffix(date: Date())
        selectedMonthYearLB.text = CalendarUtil().convertDateToString(dateFormat: "MMMM yyyy", date: Date())
        
        calendarCV.register(UINib(nibName: "CalendarMoodCell", bundle: nil), forCellWithReuseIdentifier: "CalendarMoodCell")
        calendarCV.dataSource = self
        calendarCV.delegate = self
        
        statusLB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStatusLB)))
        
        setUpSlider()
        setUpStatusDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didTapPredictionUB(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    func initData() {
        AppUtil.onShowProgressView(self.tabBarController!)
        FireUtil.instance.getUserInfo() { [self] (user, succes) in
            if succes {
                AppUtil.onHideProgressView(self.tabBarController!)
                APPUSER = user
                setMonthView()
            } else {
                AppUtil.onHideProgressView(self.tabBarController!)
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong")
            }
        }
    }
    
    func setMonthView() {
        totalSquares.removeAll()
        totalMoodDates.removeAll()
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
        let moodStartDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd", date: APPUSER.mood)
        totalSquares.forEach { (item) in
            let currentDate = CalendarUtil().convertStringToDate(dateFormat: "EEEE, dd MMMM, yyyy", date: item.date)
            let moodType = AppUtil.getMoodType(moodStartDate: moodStartDate, currentDate: currentDate)
            let isStartEnd = moodType.getMoodStartEnd(arr: totalMoodDates, type: moodType)
            totalMoodDates.append(MoodCalendarModel(moodType: moodType, startEnd: isStartEnd, calendarModel: item))
        }
        calendarMonthYearLB.text = CalendarUtil().monthString(date: selectedDate) + " " + CalendarUtil().yearString(date: selectedDate)
        DispatchQueue.main.async { [self] in
            calendarCV.reloadData()
        }
    }
    
    func setUpSlider() {
        sliderUV.setThumbImage(UIImage(named: "ic_emoji_thumb"), for: .normal)
    }
    
    func setUpStatusDropDown() {
        statusDropDown.width = statusLB.frame.width
        statusDropDown.anchorView = statusLB
        statusDropDown.topOffset = CGPoint(x: 0, y: -(statusDropDown.anchorView?.plainView.bounds.height)!)
    }
    
    @objc func didTapNextUB() {
        selectedDate = CalendarUtil().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    @objc func didTapPreviousUB() {
        selectedDate = CalendarUtil().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @objc func didTapStatusLB() {
        statusDropDown.show()
        statusDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            statusLB.text = item
        }
    }
    
    @IBAction func didTapSubmitUB(_ sender: Any) {
        AppUtil.onShowProgressView(self.tabBarController!)
        let data: [String: String] = [
            "userId": (Auth.auth().currentUser?.uid)!,
            "name": (statusDropDown.selectedItem)!,
            "date": CalendarUtil().convertDateToString(dateFormat: "yyyy-MM-dd", date: Date())
        ]
        
        FireUtil.instance.saveUserStatus(value: data) { (success) in
            AppUtil.onHideProgressView(self.tabBarController!)
            if success {
                AppUtil.showBanner(type: CRNotifications.success, title: .Success, content: "Successful upload your wife status")
            } else {
                AppUtil.showBanner(type: CRNotifications.error, title: .Failed, content: "Something went wrong.")
            }
        }
    }
}

//MARK:- Calendar Data Source and Delegate
extension CalendarVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalMoodDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarMoodCell", for: indexPath) as! CalendarMoodCell
        cell.model = totalMoodDates[indexPath.row]
        cell.indexNum = indexPath.row
        cell.configureCell(model: totalMoodDates[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension CalendarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        totalSquares.forEach { (item) in
            item.isSelected = false
        }
        totalMoodDates[indexPath.row].calendarModel.isSelected = true
        collectionView.reloadData()
        let selectedDate = CalendarUtil().convertStringToDate(dateFormat: "EEEE, dd MMMM, yyyy", date: totalSquares[indexPath.row].date)
        selectedDayLB.text = "\(CalendarUtil().dayOfMonth(date: selectedDate))th"
        selectedMonthYearLB.text = "\(CalendarUtil().monthString(date: selectedDate)) \(CalendarUtil().yearString(date: selectedDate))"
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (calendarCV.frame.size.width) / 7, height: (calendarCV.frame.size.width) / 7)
    }
}


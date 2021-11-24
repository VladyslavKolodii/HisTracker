//
//  PredictionVC.swift
//  HisTrackerGuideiOS
//
//  Created by Aira on 12.11.2021.
//

import UIKit

class PredictionVC: UIViewController {

    @IBOutlet weak var predictionTV: UITableView!
    
    var dayDiff: Int = 0
    let calendar = Calendar.current
    
    var predictMapArry: [PredictionModel] = [PredictionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        predictionTV.register(UINib(nibName: "PredictionCell", bundle: nil), forCellReuseIdentifier: "PredictionCell")
        predictionTV.dataSource = self
        predictionTV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPredictData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getPredictData() {        
        let startDate = CalendarUtil().convertStringToDate(dateFormat: "yyyy-MM-dd", date: APPUSER.mood)
        var preMoodStatus: MoodType = AppUtil.getMoodType(moodStartDate: startDate, currentDate: CalendarUtil().firstOfMonth(date: Date()))
        var moodDates: [Date] = [Date]()
        predictMapArry.removeAll()
        CalendarUtil().getAllDaysInMonth().forEach { date in
            let currentMoodStatus = AppUtil.getMoodType(moodStartDate: startDate, currentDate: date)
            if preMoodStatus == currentMoodStatus {
                moodDates.append(date)
            } else {
                predictMapArry.append(PredictionModel(moodType: preMoodStatus, dates: moodDates))
                moodDates.removeAll()
                moodDates.append(date)
                preMoodStatus = currentMoodStatus
            }
        }
        predictMapArry.append(PredictionModel(moodType: preMoodStatus, dates: moodDates))
        DispatchQueue.main.async { [self] in
            predictionTV.reloadData()
        }
        
    }

}

//MARK: - TableView DataSource
extension PredictionVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictMapArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = predictionTV.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath) as! PredictionCell
        cell.configurCell(model: predictMapArry[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * CGFloat(predictMapArry[indexPath.row].dates.count)
    }
    
}

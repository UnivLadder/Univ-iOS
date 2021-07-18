//
//  ScheduleVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/18.
//

import UIKit

class ScheduleVC: UIViewController {
    static func instance() -> ScheduleVC {
        let vc = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(identifier: "ScheduleVC") as! ScheduleVC
        return vc
    }

    @IBOutlet weak var scheduleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.allowsSelection = false
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

extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
            cell.setSchedule()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleAlarmCell") as! ScheduleCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsCell") as! ScheduleCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! ScheduleCell
            cell.setFile()
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! ScheduleCell
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as! ScheduleCell
            return cell
        default:
            return UITableViewCell()
        }
        
        

    }
    
    
}

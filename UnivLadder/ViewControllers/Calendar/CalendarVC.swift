//
//  CalendarVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/06/13.
//

import UIKit

class CalendarVC: UIViewController {
    // calendar
//    @IBOutlet weak var calendarTitleLabel: UILabel!
//    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet weak var weekDayStack: UIStackView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var plusButton: UIImageView!
    @IBOutlet weak var scheduleTableView: UITableView!

    // MARK: TodoTask Data Values
    var subjectData = ["수학 과제", "영어 과제", "수학 4-1"]
    
    // MARK: Calendar Data Values
    private lazy var selectedDate: Date = baseDate
    private var baseDate: Date = Date()
    private lazy var days = generateDaysInMonth(for: baseDate)
    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    private let calendar = Calendar(identifier: .gregorian)
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    private lazy var titleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("y MMMM")
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // calendar setting
        self.title = titleDateFormatter.string(from: baseDate)
        
        setDayOfWeekStack()
        
        calendarCollectionView.register(
            CalendarCell.self,
            forCellWithReuseIdentifier: CalendarCell.reuseIdentifier
        )
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate  = self
        
        // swipe gesture
        let prevSwipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(prevHandleSwipe(_:)))
        let nextSwipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(nextHandleSwipe(_:)))

        // 다른 달로 이동
        prevSwipeGestureRecogniser.direction = .right
        nextSwipeGestureRecogniser.direction = .left

        calendarCollectionView.addGestureRecognizer(prevSwipeGestureRecogniser)
        calendarCollectionView.addGestureRecognizer(nextSwipeGestureRecogniser)
        
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        setUI()
    }
    
    
    
    private func setUI() {
        let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        
        let tableViewHeaderLabel = UILabel(frame: tableViewHeader.bounds)
        tableViewHeaderLabel.text = "Today"
        tableViewHeaderLabel.textAlignment = .natural
        tableViewHeader.addSubview(tableViewHeaderLabel)
        scheduleTableView.tableHeaderView = tableViewHeader
        scheduleTableView.separatorStyle = .none
        
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        plusButton.layer.cornerRadius = plusButton.frame.width * 0.5        
    }
    
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        calendarCollectionView.reloadData()
    }
    
    
    // 이전 달로 이동
    @objc func prevHandleSwipe(_ sender:UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            self.baseDate = self.calendar.date(byAdding: .month, value: -1, to: self.baseDate) ?? self.baseDate
            self.title = titleDateFormatter.string(from: baseDate)
            days = generateDaysInMonth(for: baseDate)
            calendarCollectionView.reloadData()
        }
    }
    // 다음 달로 이동
    @objc func nextHandleSwipe(_ sender:UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            self.baseDate = self.calendar.date(byAdding: .month, value: 1, to: self.baseDate) ?? self.baseDate
            self.title = titleDateFormatter.string(from: baseDate)
            days = generateDaysInMonth(for: baseDate)
            calendarCollectionView.reloadData()
        }
    }
    
    // week day
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return ""
        }
    }
    
    private func setDayOfWeekStack() {
        for dayNumber in 1...7 {
            let dayLabel = weekDayStack.viewWithTag(dayNumber) as! UILabel
            dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)
            dayLabel.isAccessibilityElement = false
//            weekDayStack.addArrangedSubview(dayLabel)
        }
    }
    
}



// MARK: - Day Generation
private extension CalendarVC {
    // Date를 받아서 MonthMetadata로 반환
    func monthMetadata(for baseDate: Date) throws -> MonthMetaData {
        // baseDate : 해당 월의 1일 반환
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            // nil이라면 error
            throw CalendarDataError.metadataGeneration
        }
        
        // 첫번째 날의 요일
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 생성된 MonthMetaData 인스턴스 return
        return MonthMetaData(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    // Date를 받아서 Day 배열 반환
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        // 메타데이터 가져오고 안된다면 error 발생
        guard let metadata = try? monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        // 공백이 생기는 주(ex: 금요일 시작)의 요일을 채움
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                // 현재 달에 포함된 일인지 계산
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                // 지난 달의 일이면 음수값
                let dayOffset =
                    isWithinDisplayedMonth ?
                    day - offsetInInitialRow :
                    -(offsetInInitialRow - day)
                
                // 결과 반환
                return generateDay(
                    offsetBy: dayOffset,
                    for: firstDayOfMonth,
                    isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    // Day 인스턴스 생성
    func generateDay(
        offsetBy dayOffset: Int,
        for baseDate: Date,
        isWithinDisplayedMonth: Bool
    ) -> Day {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate)
            ?? baseDate
        
        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    // 다음달의 시작 날짜 배열 생성하는 함수
    func generateStartOfNextMonth(
        using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
        // 표시되고 있는 달의 마지막 날짜 계산
        guard
            let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth)
        else {
            return []
        }
        
        // 달력의 마지막 주를 채우는데 필요한 일 수 계산
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        
        //
        let days: [Day] = (1...additionalDays)
            .map {
                generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
            }
        
        return days
    }
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
}





// MARK: - UICollectionViewDataSource
extension CalendarVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        
        cell.day = day
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = days[indexPath.row]

        selectedDate = day.date

        // 다른달이면 calendar 변경
        if !day.isWithinDisplayedMonth {
            baseDate = selectedDate
            self.title = titleDateFormatter.string(from: baseDate)
        }
        days = generateDaysInMonth(for: baseDate)
        calendarCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate

        return CGSize(width: width, height: height)
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTaskCell") as! TodayTaskCell
        cell.selectionStyle = .none
        
        var isFirst: Bool = false
        var isLast: Bool = false
        if indexPath.row == 0 {
            isFirst = true
        } else if indexPath.row == 2 {
            isLast = true
        }
        cell.configure(isFirst: isFirst, isLast: isLast, subject: subjectData[indexPath.row], detail: "10:20 - 11:20")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScheduleVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = ChatRoomVC.instance()
//        vc.navigationItem.title = chatRooms[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//
    }
}

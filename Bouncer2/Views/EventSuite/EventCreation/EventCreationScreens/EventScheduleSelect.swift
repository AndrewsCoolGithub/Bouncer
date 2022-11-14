//
//  EventScheduleSelect.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/2/22.
//

import Foundation
import UIKit


class EventScheduleSelect: UIViewController, UICollectionViewDelegate{
    lazy var today: Date = self.dataSource[0]
    lazy var selectedDate: Date = self.dataSource[0]
    
    lazy var dataSource: [Date] = {
        var week = [Date]()
        let today = Date()
        for i in 0...15{
            if i == 0{ week += [Calendar.current.startOfDay(for: today)] }
            
            if i != 0{
                guard let modifiedDate = Calendar.current.date(byAdding: .day, value: i, to: today) else {return []}
                let startOfDay = Calendar.current.startOfDay(for: modifiedDate)
                week += [startOfDay]
            }
        }
        return week
    }()
   
    
    private let daysCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: .makeWidth(85), height: .makeWidth(85))
        layout.sectionInset = UIEdgeInsets(top: 0, left: .makeWidth(15), bottom: 0, right: .makeWidth(15))
        layout.minimumInteritemSpacing = .makeWidth(15)
        layout.minimumLineSpacing = .makeWidth(15)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: .makeHeight(50), width: .makeWidth(414), height: .makeWidth(120)), collectionViewLayout: layout)
        collectionView.register(ScheduleDayCell.self, forCellWithReuseIdentifier: ScheduleDayCell.id)
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .greyColor()
        return collectionView
    }()
    
    private let startTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.setDimensions(height: .makeWidth(100), width: .makeWidth(180))
        timePicker.minimumDate = Date().rounded(minutes: 15, rounding: .ceil)
        timePicker.tintColor = .white
        timePicker.contentHorizontalAlignment = .fill
        timePicker.contentVerticalAlignment = .fill
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.roundsToMinuteInterval = true
        timePicker.minuteInterval = 15
      
        return timePicker
        
    }()
    
    
    private let endTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .countDownTimer
        timePicker.setDimensions(height: .makeWidth(100), width: .makeWidth(210))
        timePicker.tintColor = .white
        timePicker.contentHorizontalAlignment = .fill
        timePicker.contentVerticalAlignment = .fill
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.minuteInterval = 15
        return timePicker
        
    }()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "Start time"
        label.font = .poppinsMedium(size: .makeWidth(17))
        label.textColor = .white
        return label
    }()
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "Duration"
        label.font = .poppinsMedium(size: .makeWidth(17))
        label.textColor = .white
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let selectedIndex = dataSource.firstIndex(of: self.selectedDate), let cell = daysCV.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? ScheduleDayCell else {return}
        cell.content?.gradientColors = (EventCreationVC.shared.viewModel.colors, true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
       
        view.addSubview(daysCV)
        daysCV.dataSource = self
        daysCV.delegate = self
        
        view.addSubview(startTimePicker)
        view.addSubview(endTimePicker)
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        
        startTimePicker.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeHeight(220))
        startLabel.centerYright(inView: startTimePicker, rightAnchor: endTimePicker.leftAnchor, paddingRight: .makeWidth(5))
        startTimePicker.addTarget(self, action: #selector(updatedStartTime(sender:)), for: .valueChanged)
        
        endTimePicker.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: .makeHeight(400))
        endLabel.centerYright(inView: endTimePicker, rightAnchor: endTimePicker.leftAnchor, paddingRight: .makeWidth(7.5))
        endTimePicker.addTarget(self, action: #selector(updatedEndTime(sender:)), for: .allEvents)
        endTimePicker.countDownDuration = EventCreationVC.shared.viewModel.duration ?? 3600
        
        
        if let startDate = EventCreationVC.shared.viewModel.startDate{
           
            guard let indexToSelect = self.dataSource.firstIndex(where: {$0 == Calendar.current.startOfDay(for: startDate) }) else {return} 
            
            startTimePicker.minimumDate = nil
            selectedDate = dataSource[indexToSelect]
            let hour = Calendar.current.component(.hour, from: startDate)
            let minute = Calendar.current.component(.minute, from: startDate)
            if selectedDate == today{
                startTimePicker.date = startDate
            }else{
                startTimePicker.date = .timeAt(hour: hour, minute: minute)
            }
            
            self.daysCV.selectItem(at: IndexPath(row: indexToSelect, section: 0), animated: true, scrollPosition: .top)
            setTimeValue()
        }else{
            selectedDate = dataSource[0]
            self.daysCV.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            setTimeValue()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        endTimePicker.countDownDuration = EventCreationVC.shared.viewModel.duration ?? 3600
        
        if EventCreationValidator.checkProp(.eventSchedule){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
    
   
    
    @objc func updatedEndTime(sender: UIDatePicker){
        self.setTimeValue()
    }
    
    @objc func updatedStartTime(sender: UIDatePicker){
        self.setTimeValue()
    }
    
    func setTimeValue(){
        if selectedDate == today{
            self.startTimePicker.minimumDate = .now.rounded(minutes: 15, rounding: .ceil)
        }else{
            self.startTimePicker.minimumDate = nil
        }
        
        let hour = Calendar.current.component(.hour, from: startTimePicker.date)
        let minute = Calendar.current.component(.minute, from: startTimePicker.date)
        let selectedDate = self.selectedDate
        EventCreationVC.shared.viewModel.startDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: selectedDate)
        EventCreationVC.shared.viewModel.duration = endTimePicker.countDownDuration
        
        if EventCreationValidator.checkProp(.eventSchedule){
            EventCreationVC.shared.navigator.activateButton()
        }else{
            EventCreationVC.shared.navigator.deactivateButton()
        }
    }
}

var didSelectTodayCell: Bool = false
extension EventScheduleSelect: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleDayCell.id, for: indexPath) as! ScheduleDayCell
        
        cell.setupCell(self.dataSource[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dataSource[indexPath.row]
        setTimeValue()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ScheduleDayCell else {return}
        cell.deselect()
    }
}

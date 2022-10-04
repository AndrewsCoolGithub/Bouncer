//
//  EventListHeaderCell.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/19/22.
//

import Foundation
import UIKit
import Combine

class AllEventListHeaderCell: UICollectionReusableView{
    
    static let id = "event-list-header-cell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(22.5))
        label.textColor = .white
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: .makeWidth(17))
        label.textColor = .white
        return label
    }()
    
    private lazy var numberView: PastelButton = {
        
       
        let view = PastelButton(frame: CGRect(x: 0, y: .makeWidth(35) - .makeWidth(17.5), width: .makeWidth(35), height: .makeWidth(35)), cornerRadius: .makeWidth(17.5), upperView: self)

        view.background.backgroundColor = .greyColor()
        
        //view.layer.masksToBounds = true
        return view
    }()
    
    var cancellable = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable.forEach({$0.cancel()})
    }
    
    public func setup(sectionAll: AllEventsViewController.Section? = nil, sectionMy: MyEventsViewController.Section? = nil, vm: AllEventListVM){
        
       
        numberView.titleLabel?.font = .poppinsMedium(size: .makeWidth(17.5))
        if let section = sectionAll{
            label.text = section.rawValue
            switch section {
            case .Live:
               vm.$liveCount.sink { [weak self] liveCount  in
                   guard let self = self else {return}
                   UIView.transition(with: self.numberView, duration: 0.3, options: .transitionCrossDissolve) {
                       self.numberView.setTitle("\(liveCount)", for: .normal)
                   }
                  
               }.store(in: &cancellable)
                numberView.frame.origin.x = .makeWidth(75)
            case .Today:
                vm.$todayCount.sink { [weak self] todayCount in
                    guard let self = self else {return}
                    UIView.transition(with: self.numberView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.numberView.setTitle("\(todayCount)", for: .normal)
                    }
                }.store(in: &cancellable)
                numberView.frame.origin.x = .makeWidth(105)
            case .Upcoming:
                vm.$upcomingCount.sink { [weak self] upcomingCount in
                    guard let self = self else {return}
                    UIView.transition(with: self.numberView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.numberView.setTitle("\(upcomingCount)", for: .normal)
                    }
                 }.store(in: &cancellable)
                numberView.frame.origin.x = .makeWidth(150)
            }
        }else if let section = sectionMy{
            label.text = section.rawValue
            switch section{
            case .Rsvp:
                vm.$rsvpCount.sink { [weak self] rsvpCount in
                    guard let self = self else {return}
                    UIView.transition(with: self.numberView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.numberView.setTitle("\(rsvpCount)", for: .normal)
                    }
                }.store(in: &cancellable)
                numberView.frame.origin.x = .makeWidth(85)
            case .Waitlist:
                vm.$waitlistCount.sink { [weak self] waitlistCount in
                    guard let self = self else {return}
                    UIView.transition(with: self.numberView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.numberView.setTitle("\(waitlistCount)", for: .normal)
                    }
                }.store(in: &cancellable)
                numberView.frame.origin.x = .makeWidth(115)
            case .Invites:
                vm.$invitedCount.sink { [weak self] invitedCount in
                    guard let self = self else {return}
                    UIView.transition(with: self.numberView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.numberView.setTitle("\(invitedCount)", for: .normal)
                    }
                }.store(in: &cancellable)
                numberView.frame.origin.x = .makeWidth(110)
            }
        }
       
        
        vm.$startAnimation.sink { [weak self] _ in
            self?.numberView.pastelView.startAnimation()
        }.store(in: &cancellable)
        addSubview(numberView)
        
        backgroundColor = .clear
        addSubview(label)
        label.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: .makeWidth(20))
       
    }
}

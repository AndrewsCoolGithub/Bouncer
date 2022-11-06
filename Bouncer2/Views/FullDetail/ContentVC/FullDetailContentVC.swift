//
//  TestScroll.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/3/22.
//

import Foundation
import UIKit

class FullDetailContentVC: UIViewController{
    var shouldAnimateButton: Bool = false
    var vm: FullDetailVM!
    var lastButtonCount: Int = 0
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    enum Section{ case people}
    var dataSource: UICollectionViewDiffableDataSource<Section, Profile>?
        
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var components: FullDetailViewComponents!
    
    init(components: FullDetailViewComponents, event: Event, vm: FullDetailVM){
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.components = components
        view.frame = view.frame.offsetBy(dx: 0, dy: .makeWidth(414) * 85/414)
        setupScrollView()
        setupViews(components: components)
        setupListeners(components: components)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animate(newImage: UIImage, button: UIButton){
        if shouldAnimateButton{
            shouldAnimateButton = false
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = button.transform.scaledBy(x: 0.8, y: 0.8)
                button.setImage(newImage, for: .normal)
            }, completion: { _ in
              // Step 2
              UIView.animate(withDuration: 0.1, animations: {
                  button.transform = CGAffineTransform.identity
              })
            })
        }else{
            button.setImage(newImage, for: .normal)
        }
    }

    @objc func buttonTapped(sender: UIButton){
        print("Button tapped")
        shouldAnimateButton = true
        vm?.perform()
    }
    
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.alwaysBounceVertical = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        scrollView.delaysContentTouches = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: .makeWidth(414) * 85/414).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.isUserInteractionEnabled = true

        
        
    }
    
    func setupListeners(components: FullDetailViewComponents){
        setupDescription(components.descriptionLabel, vm: vm)
        setupButtonTitle(components.actionButton, vm: vm)
        setupButtonSymbol(components.actionButton, vm: vm)
        setupUpcomingTimeLabel(components.timeLabel, vm: vm)
        setupTimeRemainingLabel(components.timeLabel, vm: vm)
        listenForCVUpdates(components, vm: vm)
    }
    
    func setupViews(components: FullDetailViewComponents){
        let descriptionLabel = components.descriptionLabel
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = vm.description
        descriptionLabel.centerX(inView: contentView, topAnchor: contentView.topAnchor, paddingTop: .makeHeight(25))

        let actionButton = components.actionButton
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        actionButton.centerX(inView: contentView, topAnchor: descriptionLabel.bottomAnchor, paddingTop: .makeWidth(414) * 35/414)
        
        let timeLabel = components.timeLabel
        contentView.addSubview(timeLabel)
        timeLabel.centerX(inView: contentView, topAnchor: actionButton.bottomAnchor, paddingTop: .makeWidth(414) * 20/414)
        components.peopleCV.delegate = self
        if !vm.rsvps.isEmpty{
            addCV(components.peopleCountLabel, components.peopleCV, timeLabel)
        }
        
//        contentView.addSubview(subtitleLabel)
//        subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        subtitleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 25).isActive = true
//        subtitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
//        subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(contentView.intrinsicContentSize)
    }
    
    func setupDataSource(_ collectionView: UICollectionView){
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, profile in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullDetailPeopleCVCell.id, for: indexPath) as! FullDetailPeopleCVCell
            cell.setup(with: profile)
            return cell
        })
    }
    
    
    fileprivate func addCV(_ peopleCountLabel: UILabel, _ peopleCV: UICollectionView,  _ timeLabel: UILabel) {
       
        setupDataSource(peopleCV)
        DispatchQueue.main.async { [weak self] in
            self?.contentView.addSubview(peopleCountLabel)
            peopleCountLabel.anchor(top: timeLabel.bottomAnchor, left: self?.view.leftAnchor, paddingTop: .makeWidth(414) * 50/414, paddingLeft: .makeWidth(15))
            
            
            if let rsvps = self?.vm.rsvps{
                peopleCountLabel.text =  rsvps.count > 1 ? "\(rsvps.count) People Going" : "\(rsvps.count) Person Going"
            }
           
            
            peopleCV.setDimensions(height: .makeWidth(414) * 65/414, width: .makeWidth(414))
            
            self?.contentView.addSubview(peopleCV)
            peopleCV.centerX(inView: self?.contentView ?? UIView(), topAnchor: peopleCountLabel.bottomAnchor, paddingTop: .makeWidth(414) * 15/414)
            peopleCV.bottomAnchor.constraint(equalTo: self?.contentView.bottomAnchor ?? UIView().bottomAnchor).isActive = true
        }
    }
    
    
    
   
    
    func updateDatasource(_ profiles: [Profile]){
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        
        if !profiles.isEmpty{
            DispatchQueue.main.async {
                snapshot.appendSections([.people])
                snapshot.appendItems(profiles, toSection: .people)
            }
        }else{
            DispatchQueue.main.async { [weak self] in
                self?.components.peopleCV.removeFromSuperview()
                self?.components.peopleCountLabel.removeFromSuperview()
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    //MARK: - Listeners
    
    fileprivate func listenForCVUpdates(_ components: FullDetailViewComponents, vm: FullDetailVM) {
      
//        DispatchQueue.main.async {
            vm.$rsvps.receive(on: DispatchQueue.main).sink { [weak self] profiles in
               
                self?.addCV(components.peopleCountLabel, components.peopleCV, components.timeLabel)
            
                
                self?.updateDatasource(profiles)
            }.store(in: &vm.cancellable)
//        }
    }
    
    fileprivate func setupDescription(_ component: UILabel, vm: FullDetailVM) {
        let descriptionLabel = component
        vm.$description.sink { newDescription in
            guard let newDescription = newDescription else {return}
            UIView.transition(with: descriptionLabel, duration: 0.3, options: .transitionCrossDissolve) {
                descriptionLabel.text = newDescription
            }
        }.store(in: &vm.cancellable)
    }
    
    fileprivate func setupButtonTitle(_ component: UIButton, vm: FullDetailVM){
        let actionButton = component
        vm.$buttonCount.sink { [weak self] newButtonText in
            guard let newButtonText = newButtonText, let self = self else {return}
            if let number = Int(newButtonText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                // Do something with this number
                //Increase
                if self.lastButtonCount < number {

                    UIView.transition(with: actionButton.titleLabel!, duration: 0.5, options: [.transitionFlipFromTop, .curveEaseInOut] ) { [weak self] in
                        actionButton.setTitle(newButtonText, for: .normal)
                        self?.lastButtonCount = number
                    }
                //Decrease
                }else if self.lastButtonCount > number{

                    UIView.transition(with: actionButton.titleLabel!, duration: 0.5, options: [.transitionFlipFromBottom, .curveEaseInOut ] ) { [weak self] in
                        actionButton.setTitle(newButtonText, for: .normal)
                        self?.lastButtonCount = number
                    }
                }else{
                    actionButton.setTitle(newButtonText, for: .normal)
                }
            }else{
                actionButton.setTitle(newButtonText, for: .normal)
            }
        }.store(in: &vm.cancellable)
    }
    
    fileprivate func setupButtonSymbol(_ component: UIButton, vm: FullDetailVM){
        let actionButton = component
        
        vm.$action.sink { [weak self] action in
            guard let action = action else {return}
            let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(26.5))
            switch action{
            case .joinWaitlist:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "scroll", withConfiguration: config)!, button: actionButton)
                }
            case .leaveWaitlist:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "scroll.fill", withConfiguration: config)!, button: actionButton)
                }
            case .RSVP:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "bell.and.waveform", withConfiguration: config)!, button: actionButton)
                }
            case .unRSVP:
                DispatchQueue.main.async {
                    self?.animate(newImage: UIImage(systemName: "bell.and.waveform.fill", withConfiguration: config)!, button: actionButton)
                }
            case .nav:
                actionButton.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
            case .invited:
                actionButton.setImage(UIImage(systemName: "clock.badge.checkmark.fill", withConfiguration: config), for: .normal)
                
            case .unavailable:
                actionButton.setImage(nil, for: .normal)
            }
        
        }.store(in: &vm.cancellable)
    }
    
    fileprivate func setupUpcomingTimeLabel(_ component: UILabel, vm: FullDetailVM){
        guard vm.startDate != nil && vm.startDate! > .now else {return}
        vm.$startDate.sink { startDate in
            if let startDate = startDate, startDate > .now {
                var fullString: String!
                var coloredString: String! {
                    didSet{
                        guard let coloredString = coloredString else {return}
                        fullString = "Scheduled for \(coloredString)"
                    }
                }
                
                if Calendar.current.isDateInToday(startDate){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mmaa"
                    let timeString = dateFormatter.string(from: startDate).lowercased()
                    coloredString = "Today, \(timeString)"
                }else{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM, d, h:mmaa"
                    let dateString = dateFormatter.string(from: startDate)
                    let month = dateString.components(separatedBy: ", ")[0]
                    let day = dateString.components(separatedBy: ", ")[1]
                    let hour = dateString.components(separatedBy: ", ")[2].lowercased()
                    
                    switch day{
                    case "1":
                        coloredString = "\(month) \(day)st, \(hour)"
                    case "2":
                        coloredString = "\(month) \(day)nd, \(hour)"
                    case "3":
                        coloredString = "\(month) \(day)rd, \(hour)"
                    default:
                        coloredString = "\(month) \(day)th, \(hour)"
                    }
                }
                
                let rangeOfColoredString = (fullString as NSString).range(of: coloredString)
                let attributedString = NSMutableAttributedString(string: fullString)
                attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                               range: rangeOfColoredString)
                component.attributedText = attributedString
            }
        }.store(in: &vm.cancellable)
    }
    
    var timerForRemaining: Timer?
    fileprivate func setupTimeRemainingLabel(_ component: UILabel, vm: FullDetailVM){
        vm.$endDate.sink { [weak self] endDate in
            guard let self = self else {return}
            if let endDate = endDate, endDate > .now && vm.startDate ?? .now < .now {
//                let timeRemaining = endDate.timeIntervalSinceNow
                self.timerForRemaining?.invalidate()
                self.timerForRemaining = nil
                self.timerForRemaining = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateLabelForTimeRemaining), userInfo: component, repeats: true)
            }else if vm.startDate ?? .now < .now && endDate == nil{
                component.text = nil
                self.timerForRemaining?.invalidate()
                self.timerForRemaining = nil
            }
        }.store(in: &vm.cancellable)
    }
    
    @objc func updateLabelForTimeRemaining(_ sender: Timer){
        guard let label = sender.userInfo as? UILabel,  let timeRemaining = vm?.endDate?.timeIntervalSinceNow, timeRemaining > 0 else {
            sender.invalidate()
            timerForRemaining = nil
            return
        }
        let hours = Int(timeRemaining / 3600)
        let minutes = (Int(timeRemaining) - (hours * 3600))/60
        
        var coloredString: String!
        if hours > 0 {
            coloredString = "\(hours)h \(minutes)m"
        }else{
            coloredString = "\(minutes)m"
        }
        
        let fullString = coloredString != nil ? "Event ends in \(coloredString!)" : ""
        
        let rangeOfColoredString = (fullString as NSString).range(of: coloredString)
        let attributedString = NSMutableAttributedString(string: fullString)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       range: rangeOfColoredString)
        label.attributedText = attributedString
        
        
    }
   
    deinit{
        vm = nil
    }
    
}


extension FullDetailContentVC: UICollectionViewDelegateFlowLayout{

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: .makeWidth(65), height: .makeWidth(414) * 65/414)
//    }
}

extension FullDetailContentVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let profile = dataSource?.itemIdentifier(for: indexPath){
            let controller = ProfileViewController(profile: profile)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .makeWidth(414) * 65/414, height: .makeWidth(414) * 65/414)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: .makeWidth(15), bottom: 0, right: .makeWidth(15))
    }
    
}

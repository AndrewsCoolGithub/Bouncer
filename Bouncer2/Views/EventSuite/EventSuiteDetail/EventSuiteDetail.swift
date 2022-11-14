//
//  EventSuiteDetail.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import UIKit

class EventSuiteDetail: UIViewController{
    
   
    var components = EventSuiteDetailViewComponents()

    var vm: EventSuiteDetailVM!
    var hiddenSections = Set<[Profile]>()
    let dummyProfile = Profile(image_url: "", display_name: "", user_name: "", latitude: 90, longitude: 90, backdrop_url: nil, bio: nil, followers: nil, following: nil, blocked: nil, blockedBy: nil, colors: nil, number: nil, email: nil, emojis: nil, recentEmojis: nil)
    
    var dataSource: UITableViewDiffableDataSource<Section, Profile>?
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: .wProportioned(170), width: .makeWidth(414), height: .makeHeight(896) - .wProportioned(170)))
    
        tv.register(SuiteDetailRSVPCell.self, forCellReuseIdentifier: SuiteDetailRSVPCell.id)
        tv.register(SuggestedCollectionView.self, forCellReuseIdentifier: SuggestedCollectionView.id)
        return tv
    }()
    
    enum Section: Int, CaseIterable {
        case one
        case two
        case three
    }
    
    init(_ event: Event, _ image: UIImage?){
        super.init(nibName: nil, bundle: nil)
        vm = EventSuiteDetailVM(event)
        setupDetailHeader(event, image)
        view.addSubview(tableView)
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, profile in
            
            guard let section = self?.dataSource?.sectionIdentifier(for: indexPath.section) else {return nil}
            switch section{
                
               
            case .three:
                let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedCollectionView.id) as! SuggestedCollectionView
                cell.setup(self?.vm)
               return cell
            case .one:  //Should be .one
                let cell = tableView.dequeueReusableCell(withIdentifier: SuiteDetailRSVPCell.id, for: indexPath) as! SuiteDetailRSVPCell
                cell.setup(profile)
                return cell
            case .two: //TODO: Make this the right cell
//                let cell = tableView.dequeueReusableCell(withIdentifier: SuiteDetailRSVPCell.id, for: indexPath) as! SuiteDetailRSVPCell
//                cell.setup(profile)
                return nil
            }
        })
        
        
        
        vm.$prospects.receive(on: DispatchQueue.main).sink { [weak self] profiles in
            
                self?.makeSnapshot(profiles)
            
        }.store(in: &vm.cancellable)
    }
    
    deinit{
        vm.cancellable.forEach({$0.cancel()})
        vm = nil
        dataSource = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        
    }
    
    func makeSnapshot(_ prospects: [Profile]){
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
//        if !prospects.isEmpty{
//            snapshot.appendSections([.one])
//            snapshot.appendItems(prospects, toSection: .one)
//        }
//
//        snapshot.appendSections([.three])
//        snapshot.appendItems([dummyProfile], toSection: .three)
//        dataSource?.apply(snapshot, animatingDifferences: true)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        
        
        for section in Section.allCases{
            
            
            let hidden = vm.data[section]!.isHidden
            let profiles = section != .three ? vm.data[section]!.profiles : [dummyProfile]
           
            if !hidden && !profiles.isEmpty{
                snapshot.appendSections([section])
                snapshot.appendItems(profiles, toSection: section)
            }else if hidden && !profiles.isEmpty{
                snapshot.appendSections([section])
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupDetailHeader(_ event: Event, _ image: UIImage?){

        let iv = components.imageView
        let skeleton = components.skeletonGradient
        view.addSubview(iv)
        if let image = image{
            iv.image = image
        }else{
            iv.layer.addSublayer(skeleton)
            iv.sd_setImage(with: URL(string: event.imageURL)) { I, E, C, U in
                if E == nil{
                    skeleton.removeFromSuperlayer()
                }
            }
        }
        
        let overlay = components.dimmingOverlay
        view.addSubview(overlay)
        
        let backButton = components.backButton
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(15))
        backButton.anchor(left: view.leftAnchor, paddingLeft: .makeWidth(20))
        
        let editButton = components.editButton
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.addSubview(editButton)
        editButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(16))
        editButton.anchor(right: view.rightAnchor, paddingRight: .makeWidth(20))
        
        let shareButton = components.shareButton
        view.addSubview(shareButton)
        shareButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(15))
        shareButton.anchor(right: editButton.leftAnchor, paddingRight: .makeWidth(20))
        
        
        let eventTitleLabel = components.eventTitleLabel
        eventTitleLabel.text = event.title
        view.addSubview(eventTitleLabel)
        eventTitleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: .wProportioned(50))
        
        let ttlLabel = components.timeTillLiveLabel
        ttlLabel.text = vm.ttlLabelText()
        view.addSubview(ttlLabel)
        ttlLabel.centerX(inView: view, topAnchor: eventTitleLabel.bottomAnchor, paddingTop: .wProportioned(5))
        
        Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink { [weak self] _ in
            UIView.transition(with: ttlLabel, duration: 0.25, options: .transitionCrossDissolve) { [weak self] in
                if let timeText = self?.vm.ttlLabelText(){
                    ttlLabel.text = timeText
                }else{
                    ttlLabel.removeFromSuperview()
                }
            }
        }.store(in: &vm.cancellable)
        
    }
    
    @objc func edit(){
        if let image = components.imageView.image{
            EventCreationVC.setup(image: image, colors: vm.event.uiImageColors(), with: nil, with: vm.event)
            navigationController?.pushViewController(EventCreationVC.shared, animated: true)
        }
    }
    
    @objc func popVC(){
        navigationController?.popViewController(animated: true)
    }
       
    
}

extension EventSuiteDetail: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.dataSource?.sectionIdentifier(for: indexPath.section) != .three{
            return .wProportioned(95)
        }else{
            return .wProportioned(250)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .wProportioned(40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = dataSource?.sectionIdentifier(for: section) else {return nil}
        let sectionButton = SuiteHeaderButton()
        sectionButton.setup(section, vm)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSection))
        sectionButton.addGestureRecognizer(tapGesture)
        return sectionButton
    }
        
    
    @objc private func hideSection(_ sender: UITapGestureRecognizer) {
       
        guard let view = sender.view as? SuiteHeaderButton, let selectedSection = view.section, var lastSnap = dataSource?.snapshot() else {return}
        
        var items: (profiles: [Profile], isHidden: Bool) {
            return vm.data[selectedSection]!
        }
        
        vm.data[selectedSection]! = (items.profiles, !items.isHidden)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        
        
        for section in Section.allCases{
            
            
            let hidden = vm.data[section]!.isHidden
            let profiles = section != .three ? vm.data[section]!.profiles : [dummyProfile]
           
            if !hidden && !profiles.isEmpty{
                snapshot.appendSections([section])
                snapshot.appendItems(profiles, toSection: section)
            }else if hidden && !profiles.isEmpty{
                snapshot.appendSections([section])
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        if hiddenSections.contains(items){ //Show Section
//            
//            
//            
//            lastSnap.appendItems(items, toSection: section)
//            hiddenSections.remove(items)
//            dataSource?.apply(lastSnap, animatingDifferences: true)
//            view.state.toggle()
//        }else{
//           
//           
//            hiddenSections.update(with: items)
//            snapshot.appendSections(lastSnap.sectionIdentifiers)
//            for sec in lastSnap.sectionIdentifiers{
//                if sec != section{
//                    switch sec{
//                    case .one:
//                        guard !hiddenSections.contains(vm.prospects) else {continue}
//                        snapshot.appendItems(vm.prospects, toSection: sec)
//                    case .two:
//                        continue
//                    case .three:
//                        guard !hiddenSections.contains([User.shared.profile]) else {continue}
//                        snapshot.appendItems([User.shared.profile], toSection: sec)
//                    }
//                }
//            }
//           
//            dataSource?.apply(snapshot, animatingDifferences: true)
//            view.state.toggle()
//        }
    }
}

extension EventSuiteDetail: SuiteCellDelegate{
    func openProfile(_ profile: Profile) {
        var controller: ProfileViewController!
        guard profile.id != User.shared.id else {controller = ProfileViewController(); return}
        controller = ProfileViewController(profile: profile)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func inviteUser(_ id: String) {
        Task{
            do{
                try await EventManager.shared.addTo(collection: .invited, with: vm.event.id!, userID: id)
            }catch{
                print("‼️ Failed to add to invited")
                return
            }
        }
    }
    
    func removeUser(_ id: String) {
        guard vm.event.type == .exclusive else {return}
        Task{
            do{
                try await EventManager.shared.remove(from: .prospects, for: vm.event.id!, userID: id)
            }catch{
                print("‼️ Failed to remove from requested")
                return
            }
        }
    }
    
    func cancelInvite(_ id: String) {
        guard vm.event.type == .exclusive else {return}
        Task{
            do{
                try await EventManager.shared.remove(from: .invited, for: vm.event.id!, userID: id)
            }catch{
                print("‼️ Failed to remove from invited")
                return
            }
        }
    }
}

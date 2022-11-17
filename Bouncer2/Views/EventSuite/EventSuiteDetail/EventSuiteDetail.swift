//
//  EventSuiteDetail.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/11/22.
//

import UIKit

class EventSuiteDetail: UIViewController{
    
    fileprivate var components = EventSuiteDetailViewComponents()
    fileprivate var vm: EventSuiteDetailVM!

    fileprivate let dummyProfile = Profile(image_url: "", display_name: "", user_name: "", latitude: 90, longitude: 90, backdrop_url: nil, bio: nil, followers: nil, following: nil, blocked: nil, blockedBy: nil, colors: nil, number: nil, email: nil, emojis: nil, recentEmojis: nil)
    
    fileprivate var dataSource: UITableViewDiffableDataSource<Section, Profile>?
    
    fileprivate let tableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: .wProportioned(170), width: .makeWidth(414), height: .makeHeight(896) - .wProportioned(170)))
        tv.backgroundColor = .greyColor()
        tv.separatorStyle = .none
        tv.sectionHeaderTopPadding = 0
        tv.register(SuiteDetailCell.self, forCellReuseIdentifier: SuiteDetailCell.id)
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
        view.backgroundColor = .greyColor()
        
        
        //TODO: Change dataSource when Detail Type changes
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, profile in
            
            guard let section = self?.dataSource?.sectionIdentifier(for: indexPath.section) else {fatalError("Event Suite Detail's UITableViewDiffableDataSource must return a cell.")}
            switch section{
            case .three:
                let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedCollectionView.id) as! SuggestedCollectionView
                cell.setup(self?.vm, delegate: self)
               return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: SuiteDetailCell.id, for: indexPath) as! SuiteDetailCell
                cell.setup(profile, section, self?.vm.detailType, delegate: self)
                return cell
            }
        })
        
        vm.$data.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.makeSnapshot()
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
    
    fileprivate func makeSnapshot(){
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
        
        dataSource?.apply(snapshot, animatingDifferences: !vm.data[.one]!.isHidden)
    }
    
    fileprivate func setupDetailHeader(_ event: Event, _ image: UIImage?){
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
    
    @objc fileprivate func edit(){
        if let image = components.imageView.image{
            EventCreationVC.setup(image: image, colors: vm.event.uiImageColors(), with: nil, with: vm.event)
            navigationController?.pushViewController(EventCreationVC.shared, animated: true)
        }
    }
    
    @objc fileprivate func popVC(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func hideSection(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? SuiteHeaderButton, let selectedSection = view.section else {return}
        var items: (profiles: [Profile], isHidden: Bool) { return vm.data[selectedSection]!}
        vm.data[selectedSection] = (items.profiles, !items.isHidden)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = dataSource?.sectionIdentifier(for: indexPath.section), section != .three else {return}
        guard let profile = dataSource?.itemIdentifier(for: indexPath) else {return}
        openProfile(profile)
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
                removeUser(id)
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

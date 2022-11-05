//
//  EventSuite.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 5/16/22.
//

import Foundation
import UIKit
import UIImageColors
import Combine

///Known issues:
///1. When Event collection is deleted in database, Draft section appears randomly

class EventSuite: UIViewController{
    
    var draft: EventDraft?
    var previous: [Event]? = []
    var upcoming: [Event]? = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, EventSuiteCellViewModel>?
    private var cancellable = Set<AnyCancellable>()
    private let cameraVC = CameraVC()
    
    
    let components = EventSuiteViewComponents()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setupUI()
        DraftManager.shared.$draftPublisher.sink { [weak self] draft in
            self?.draft = draft
            self?.updateSnapshot()
        }.store(in: &cancellable)
        
        EventManager.shared.$previouslyHosted.sink { [weak self] previous in
            self?.previous = previous
            self?.updateSnapshot()
        }.store(in: &cancellable)
        
        EventManager.shared.$upcoming.sink { [weak self] upcoming in
            self?.upcoming = upcoming
            self?.updateSnapshot()
        }.store(in: &cancellable)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        components.buttonPastelView.startAnimation()
        components.pastelView.startAnimation()
    }
   
    @objc func willEnterForeground(){
        components.buttonPastelView.startAnimation()
        components.pastelView.startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    
    
  
    @objc func openEventCreator(){
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    fileprivate func setupUI() {
        components.collectionView.delegate = self
        view.addSubview(components.collectionView)
        view.addSubview(components.pastelView)
        components.buttonPastelView.frame = components.createButton.frame.insetBy(dx: -1, dy: -1)
        components.buttonPastelView.layer.cornerRadius = components.createButton.layer.cornerRadius
        components.buttonPastelView.layer.masksToBounds = true
        view.addSubview(components.buttonPastelView)
        view.addSubview(components.createButton)
        view.bringSubviewToFront(components.createButton)
        components.createButton.addTarget(self, action: #selector(openEventCreator), for: .touchUpInside)
        dataSource = UICollectionViewDiffableDataSource(collectionView: components.collectionView, cellProvider: { collectionView, indexPath, event in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventSuiteCell.id, for: indexPath) as! EventSuiteCell
            cell.create(with: event)
            return cell
        }) //Datasource
        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = self.components.collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: EventHeaderCell.id, for: indexPath) as! EventHeaderCell
            
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else {return header}
            switch section {
            case .draft:
                header.setup(title: "Draft")
            case .previous:
                header.setup(title: "History")
            case .upcoming:
                header.setup(title: "Upcoming")
            }
            return header
        } //Header Datasource
        User.shared.$colors.sink { [weak self] colorModel in
            guard let colorModel = colorModel else {return}
            self?.components.buttonPastelView.setColors(colorModel.uiColors())
            self?.components.pastelView.setColors(colorModel.uiColors())
        }.store(in: &cancellable) //Color Updater
    }
    
    fileprivate func updateSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, EventSuiteCellViewModel>()
        
        
        if let draft = draft{
            snapshot.appendSections([.draft])
            snapshot.appendItems([EventSuiteCellViewModel(draft: draft)], toSection: .draft)
        }
        
        if let upcoming = upcoming, !upcoming.isEmpty{
            print("Upcoming: \(upcoming)")
            snapshot.appendSections([.upcoming])
            let events = upcoming.map({EventSuiteCellViewModel(event: $0)})
            snapshot.appendItems(events, toSection: .upcoming)
        }
        
        if let previous = previous, !previous.isEmpty{
            snapshot.appendSections([.previous])
            let events = previous.map({EventSuiteCellViewModel(event: $0) })
            snapshot.appendItems(events, toSection: .previous)
        }
        
        
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        
    }
    
//    fileprivate func makePrevious(){
//        var snapshot = NSDiffableDataSourceSnapshot<Section, EventSuiteCellViewModel>()
//
//        if let previous = previous{
//            snapshot.appendSections([.previous])
//            let events = previous.map({EventSuiteCellViewModel(event: $0) })
//            snapshot.appendItems(events, toSection: .previous)
//            print("Got previous: \(previous)")
//        }
//        dataSource?.apply(snapshot, animatingDifferences: true)
//    }
//
//    fileprivate func makeDraft(){
//        var snapshot = dataSource?.snapshot() != nil ? dataSource!.snapshot() : NSDiffableDataSourceSnapshot<Section, EventSuiteCellViewModel>()
//
//        if let draft = draft {
//            snapshot.appendSections([.first])
//            snapshot.appendItems([EventSuiteCellViewModel(draft: draft)], toSection: .first)
//        }
//        dataSource?.apply(snapshot, animatingDifferences: true)
//    }

    enum Section{
        case draft
        case previous
        case upcoming
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventSuite: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .aspectGetSize(height: 160, width: 375)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .makeHeight(10), left: 0, bottom: .makeWidth(20), right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: .makeWidth(140), height: .makeHeight(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .makeHeight(50)
    }
}



extension EventSuite: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = (collectionView.cellForItem(at: indexPath) as? EventSuiteCell), let vm = cell.viewModel{
            switch vm.dataType{
            case .draft(event: let event):
                //Dispose of an instance of EventCreateVC
                //Setup EventCreateVC
                
                EventCreationVC.setup(image: cell.imageView.image!, colors: event.uiImageColors(), with: event)
                self.navigationController?.pushViewController(EventCreationVC.shared, animated: true)
            case .event(event: let event):
                print("Make this view")
            }
        }
    }
    

   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        guard offset > 0 else {
            components.pastelView.transform = .init(translationX: 0, y: 0)
            components.createButton.transform = .init(translationX: 0, y: 0)
            components.buttonPastelView.transform = .init(translationX: 0, y: 0)
            components.collectionView.frame.origin = CGPoint(x: 0, y: components.pastelView.frame.maxY)
            return
        }

        components.pastelView.transform = .init(translationX: 0, y: min(0, -offset))

        if components.pastelView.frame.maxY >= 0{
            components.collectionView.frame.origin = CGPoint(x: 0, y: components.pastelView.frame.maxY)
        }else{
            components.collectionView.frame.origin = CGPoint(x: 0, y: 0)
        }

        components.createButton.transform = .init(translationX: 0, y: -min(0, -offset))
        components.buttonPastelView.transform = .init(translationX: 0, y: -min(0, -offset))
    }
}


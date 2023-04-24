//
//  EventOverviewContent.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import UIKit
import Combine
class EventOverviewContent: UIView{

    var viewModel: EventOverviewViewModel!
    var components = EventOverviewContentComponents()
    var dataSource: UICollectionViewDiffableDataSource<Section, Profile>?
    enum Section: String, CaseIterable{
        case PeopleYouKnow = "People you follow"
        case Guests = "Guests"
        case Host = "Hosted by"
    }
    
    init(viewModel: EventOverviewViewModel){
        super.init(frame: .zero)
        self.viewModel = viewModel
    }
    
    func setupView(){
        let view = self
        view.isUserInteractionEnabled = true
        view.backgroundColor = .greyColor()
        let guestsCV = components.guestsCV
        view.addSubview(guestsCV)
     
        guestsCV.centerX(inView: view, topAnchor: view.topAnchor)
       
        let innerShadow = InnerShadowLayer(forView: view, edge: .Top, shadowRadius: .wProportioned(90), toColor: .clear, fromColor: .nearlyBlack().withAlphaComponent(0.2))
        view.layer.addSublayer(innerShadow)
        dataSource = makeDataSource()
        dataSource?.supplementaryViewProvider = makeSupplementaryViewProvider()
        listenForSnapshotUpdates()
    }
    
   fileprivate func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Profile> {
        return UICollectionViewDiffableDataSource(collectionView: components.guestsCV) { collectionView, indexPath, itemIdentifier in
            guard let section = self.dataSource?.sectionIdentifier(for: indexPath.section) else {return UICollectionViewCell()}
            if section == .Host{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventOverviewHostCell.id, for: indexPath) as! EventOverviewHostCell
                cell.setup(itemIdentifier)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventOverviewGuestCell.id, for: indexPath) as! EventOverviewGuestCell
                cell.setup(itemIdentifier)
                return cell
            }
        }
    }
    
    fileprivate func makeSupplementaryViewProvider() -> (UICollectionView, String, IndexPath) -> UICollectionReusableView? {
        return { [weak self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: EventOverviewSectionHeader.id, for: indexPath) as! EventOverviewSectionHeader
            guard let section = self?.dataSource?.sectionIdentifier(for: indexPath.section) else {return header}
            header.setup(section)
            return header
        }
    }
    
    fileprivate func listenForSnapshotUpdates(){
        Publishers.CombineLatest3(viewModel.$peopleYouKnow, viewModel.$guests, viewModel.$host).receive(on: DispatchQueue.main).sink { [weak self] _ in
            guard let viewModel = self?.viewModel else {return}
            var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
            Section.allCases.forEach { section in
                switch section{
                case .PeopleYouKnow:
                    if !(viewModel.peopleYouKnow.isEmpty){
                        snapshot.appendSections([.PeopleYouKnow])
                        snapshot.appendItems(viewModel.peopleYouKnow, toSection: .PeopleYouKnow)
                    }
                case .Guests:
                    if !(viewModel.guests.isEmpty){
                        snapshot.appendSections([.Guests])
                        snapshot.appendItems(viewModel.guests, toSection: .Guests)
                    }
                case .Host:
                    if viewModel.host != nil{
                        snapshot.appendSections([.Host])
                        snapshot.appendItems([viewModel.host], toSection: .Host)
                    }
                }
            }
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }.store(in: &viewModel.cancellable)
    }
    
    fileprivate func update(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct EventOverviewContentComponents{
    
    let guestsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .greyColor()
        cv.contentInset = UIEdgeInsets(top: .wProportioned(65), left: 0, bottom: .wProportioned(15), right: 0)
        cv.register(EventOverviewGuestCell.self, forCellWithReuseIdentifier: EventOverviewGuestCell.id)
        cv.register(EventOverviewHostCell.self, forCellWithReuseIdentifier: EventOverviewHostCell.id)
        cv.register(EventOverviewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventOverviewSectionHeader.id)
        return cv
    }()
}

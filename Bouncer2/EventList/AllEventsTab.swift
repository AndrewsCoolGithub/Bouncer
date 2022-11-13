//
//  AllEventsViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/12/22.
//

import Foundation
import Combine
import UIKit

class AllEventsViewController: UIViewController{
    private var cancellable = Set<AnyCancellable>()
    let viewModel = AllEventListVM()
    
    enum Section: String{
        case Live
        case Today
        case Upcoming
    }
    var snapshot: NSDiffableDataSourceSnapshot<Section, Event>?
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .greyColor()
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
        collectionView.alwaysBounceVertical = true
        collectionView.register(AllEventListHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AllEventListHeaderCell.id)
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Event>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        view.clipsToBounds = true
        view.addSubview(collectionView)
        collectionView.clipsToBounds = true
        collectionView.frame = view.bounds
        collectionView.delegate = self
        
        //MARK: Cell Dequeue
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, event in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as! ListCell
            cell.setupCell(viewModel: ListCellVM(event: event), from: .All)
            return cell
        })
        
        //MARK: Header Dequeue
        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: AllEventListHeaderCell.id, for: indexPath) as! AllEventListHeaderCell
            guard let section = snapshot?.sectionIdentifiers[indexPath.section] else {return nil}
            header.setup(sectionAll: section, vm: self.viewModel)
            return header
        }
        
        viewModel.$events.sink { subscompletion_never in
            print(subscompletion_never)
        } receiveValue: { [weak self] _events in
            self?.makeSnapshot(with: _events)
        }.store(in: &cancellable)
        
        viewModel.$modified.sink { subscompletion_never in
            print(subscompletion_never)
        } receiveValue: { [weak self] _modified in
            if let modified = _modified {
               self?.modifySnapshot(with: modified)
            }
        }.store(in: &cancellable)
    }
    
    @objc func dismissScreen(){
        navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startAnimation.toggle()
    }
   
    
    @objc func willEnterForeground(){
        viewModel.startAnimation.toggle()
    }

    
    func makeSnapshot(with events: [Event]){
        self.snapshot = NSDiffableDataSourceSnapshot<Section, Event>()
        
        let live = events.filter({$0.startsAt < .now})
        if live.count > 0{
            snapshot?.appendSections([.Live])
            snapshot?.appendItems(live, toSection: .Live)
        }
        
        let today = events.filter({Calendar.current.isDateInToday($0.startsAt) && !live.contains($0)})
        
        if today.count > 0{
            snapshot?.appendSections([.Today])
            snapshot?.appendItems(today, toSection: .Today)
        }
        
        let upcoming = events.filter({$0.startsAt > .now && !today.contains($0)})
        if upcoming.count > 0{
            snapshot?.appendSections([.Upcoming])
            snapshot?.appendItems(upcoming, toSection: .Upcoming)
        }
        
        
        guard let snapshot = snapshot else {return}
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func modifySnapshot(with events: [Event]){
        snapshot?.reconfigureItems(events)
        
        guard let snapshot = snapshot else {return}
        dataSource?.apply(snapshot)
    }
}

extension AllEventsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize.aspectGetSize(height: 160, width: 375)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .makeHeight(40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .makeHeight(40)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if (section + 1) == dataSource?.numberOfSections(in: collectionView){
//            return UIEdgeInsets(top: 0, left: 0, bottom: .makeHeight(110), right: 0)
//        }else{
//            return .zero
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: .makeWidth(170), height: .makeWidth(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let event = dataSource?.itemIdentifier(for: indexPath) {
            let eventImage: UIImage? = (collectionView.cellForItem(at: indexPath) as? ListCell)?.eventImageView.image
            let hostImage: UIImage? = (collectionView.cellForItem(at: indexPath) as? ListCell)?.profileImageView.image
            let fullDetail = FullDetailViewController(event: event, image: eventImage, hostImage: hostImage)
            navigationController?.pushViewController(fullDetail, animated: true)
        }
    }
}

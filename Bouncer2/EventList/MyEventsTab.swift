//
//  MyEventsViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/12/22.
//

import Foundation
import UIKit
import Combine

class MyEventsViewController: UIViewController{
    private var cancellable = Set<AnyCancellable>()
    let viewModel = AllEventListVM()
    
    enum Section: String{
        case Rsvp
        case Waitlist
        case Invites
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
    
    func getCount(for sectionIdentifier: Section) -> Int{
        snapshot?.numberOfItems(inSection: sectionIdentifier) ?? 0
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Event>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
       
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        collectionView.delegate = self
        
        //MARK: Cell Dequeue
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, event in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as! ListCell
            cell.setupCell(viewModel: ListCellVM(event: event), from: .My)
            return cell
        })
        
        //MARK: Header Dequeue
        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: AllEventListHeaderCell.id, for: indexPath) as! AllEventListHeaderCell
            guard let section = snapshot?.sectionIdentifiers[indexPath.section] else {return nil}
            header.setup(sectionMy: section, vm: self.viewModel)
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
        
        var invited = events.filter({$0.invitedIds?.contains(User.shared.id!) ?? false})
            invited.append(contentsOf: events.filter({($0.rsvpIds?.contains(User.shared.id!) ?? false) && $0.startsAt < .now}))
        if invited.count > 0{
            snapshot?.appendSections([.Invites])
            snapshot?.appendItems(invited, toSection: .Invites)
        }
        
        let rsvp = events.filter({($0.rsvpIds?.contains(User.shared.id!) ?? false) && $0.startsAt > .now && !($0.invitedIds?.contains(User.shared.id!) ?? false)})
        if rsvp.count > 0{
            snapshot?.appendSections([.Rsvp])
            snapshot?.appendItems(rsvp, toSection: .Rsvp)
        }
        
        let waitlist = events.filter({($0.waitlistIds?.contains(User.shared.id!) ?? false) && !($0.invitedIds?.contains(User.shared.id!) ?? false)})
        if waitlist.count > 0{
            snapshot?.appendSections([.Waitlist])
            snapshot?.appendItems(waitlist, toSection: .Waitlist)
        }
        
        
        guard let snapshot = snapshot else {return}
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func modifySnapshot(with events: [Event]){
        guard let snapshotIds = snapshot?.itemIdentifiers.map({$0.id}), events.allSatisfy({ snapshotIds.contains($0.id)}) else {return}
       
        self.snapshot?.reconfigureItems(events)
        
        guard let snapshot = snapshot else {return}
        dataSource?.apply(snapshot)
    }
}
extension MyEventsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize.aspectGetSize(height: 160, width: 375)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .makeHeight(40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .makeHeight(40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (section + 1) == dataSource?.numberOfSections(in: collectionView){
            return UIEdgeInsets(top: 0, left: 0, bottom: .makeHeight(110), right: 0)
        }else{
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: .makeWidth(170), height: .makeWidth(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let event = dataSource?.itemIdentifier(for: indexPath) {
            
            guard let image = (collectionView.cellForItem(at: indexPath) as? ListCell)?.eventImageView.image else {
                let fullDetail = FullDetailViewController(event: event)
                navigationController?.pushViewController(fullDetail, animated: true)
                return
            }
            
            let fullDetail = FullDetailViewController(event: event, image: image)
            navigationController?.pushViewController(fullDetail, animated: true)
        }
    }
}

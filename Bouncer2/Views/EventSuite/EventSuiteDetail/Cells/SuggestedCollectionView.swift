//
//  SuggestedCollectionView.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/12/22.
//

import UIKit


class SuggestedCollectionView: UITableViewCell{
    
    static let id = "SuggestedCollectionView"
    
    let suggestedCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: .makeWidth(414), height: .wProportioned(250))), collectionViewLayout: layout)
        cv.alwaysBounceHorizontal = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(SuggestedCard.self, forCellWithReuseIdentifier: SuggestedCard.id)
        cv.backgroundColor = .greyColor()
        return cv
    }()
    
    fileprivate enum Section{ case suggested}
    
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, Profile>?
    
    
   
    
    func setup(_ viewModel: EventSuiteDetailVM?){
        guard let viewModel = viewModel else {return}
        contentView.addSubview(suggestedCV)
        suggestedCV.delegate = self
        dataSource = setupDatasource()
        
        viewModel.$suggested.receive(on: DispatchQueue.main).sink { profiles in
            self.updateSnapshot(profiles)
        }.store(in: &viewModel.cancellable)
    }
    
    func updateSnapshot(_ profiles: [Profile]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        if profiles.isEmpty{
            let dummyProfile = Profile(image_url: " ", display_name: "", user_name: "", latitude: 90, longitude: 90, backdrop_url: nil, bio: nil, followers: nil, following: nil, blocked: nil, blockedBy: nil, colors: nil, number: nil, email: nil, emojis: nil, recentEmojis: nil)
            let dummyProfile2 = Profile(image_url: " ", display_name: "", user_name: "", latitude: 90, longitude: 90, backdrop_url: nil, bio: nil, followers: nil, following: nil, blocked: nil, blockedBy: nil, colors: nil, number: nil, email: nil, emojis: nil, recentEmojis: nil)
            let dummyProfile3 = Profile(image_url: " ", display_name: "", user_name: "", latitude: 90, longitude: 90, backdrop_url: nil, bio: nil, followers: nil, following: nil, blocked: nil, blockedBy: nil, colors: nil, number: nil, email: nil, emojis: nil, recentEmojis: nil)
        
            snapshot.appendSections([.suggested])
            snapshot.appendItems([dummyProfile, dummyProfile2, dummyProfile3], toSection: .suggested)
            dataSource?.apply(snapshot, animatingDifferences: true)
        }else{
            snapshot.appendSections([.suggested])
            snapshot.appendItems(profiles, toSection: .suggested)
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
        
       
       
    }
    
    fileprivate func setupDatasource() -> UICollectionViewDiffableDataSource<Section, Profile> {
        return UICollectionViewDiffableDataSource(collectionView: suggestedCV, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedCard.id, for: indexPath) as! SuggestedCard
            
            if itemIdentifier.image_url == " "{
                cell.skeleton()
            }else{
                cell.setup(itemIdentifier)
            }
            
            return cell
        })
    }
}




extension SuggestedCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .makeWidth(135), height: .wProportioned(210))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .makeWidth(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .wProportioned(15), left: .makeWidth(25), bottom: .wProportioned(15), right: .makeWidth(25))
    }
}

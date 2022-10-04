//
//  DetailArray.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/23/22.
//

import Foundation
import Combine
import UIKit
class CollectionViewController: UICollectionViewController {

    var cancellable = Set<AnyCancellable>()
    var events = [Event]()
    
    let dismissButton: UIButton = {
        let button = UIButton(frame: .layoutRect(width: 50, height: 50, rectCenter: .centerX, padding: Padding(anchor: .top, padding: 0), keepAspect: true))
        button.layer.applySketchShadow(color: .nearlyBlack().withAlphaComponent(0.3), alpha: 1, x: 0, y: .makeHeight(3), blur: .makeWidth(2), spread: .makeWidth(1.5), withRounding: .makeWidth(25))
        button.backgroundColor = .greyColor()
        button.layer.cornerRadius = .makeWidth(25)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    unowned var viewModel: MapViewModel?
    
    init(viewModel: MapViewModel){
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        
        view.frame = .layoutRect(width: 414, height: 200, rectCenter: .centerX, padding: Padding(anchor: .top, padding: .makeHeight(580)), keepAspect: true)
        view.backgroundColor = .clear
        view.addSubview(dismissButton)
        
        collectionView.frame = CGRect(x: 0, y: .makeHeight(80), width: .makeWidth(414), height: .makeHeight(140))
        collectionView.backgroundColor = .clear
        
        viewModel.$publicEvents.sink { [weak self] events in
            guard let events = events else { return }
            self?.events = events
            self?.collectionView.reloadData()
        }.store(in: &cancellable)
        
        guard let collectionView = collectionView else { fatalError() }
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(MapAnnotationDetailCell.self, forCellWithReuseIdentifier: MapAnnotationDetailCell.id)
        collectionView.delegate = self
        collectionView.panGestureRecognizer.maximumNumberOfTouches = 1
        collectionView.dataSource = self
        
        $lastIndex.sink { [weak self] indexPath in
            guard let indexPath = indexPath, let event = self?.events[indexPath.row] else {return}
            viewModel.centerOnEvent = event
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }.store(in: &cancellable)
    }
    
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollToNearestVisibleCollectionViewCell()
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    @Published var lastIndex: IndexPath?
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if (actualPosition.x > 0){
            print("dragging backwards")
            
            let visibleCell = collectionView.indexPathsForVisibleItems.reversed()[0]
            
            guard let lastIndex = lastIndex, lastIndex.row != 0 else {
               // collectionView.scrollToItem(at: visibleCell, at: .centeredHorizontally, animated: true)
                self.lastIndex = visibleCell
                return
            }
            self.lastIndex = IndexPath(row: lastIndex.row - 1, section: 0)
           // collectionView.scrollToItem(at: self.lastIndex!, at: .centeredHorizontally, animated: true)
            
            
        }else{
            print("dragging forward")
            
            let visibleCell = collectionView.indexPathsForVisibleItems[0]
            
            guard let lastIndex = lastIndex, lastIndex.row + 1 < events.count else {
                //collectionView.scrollToItem(at: visibleCell, at: .centeredHorizontally, animated: true)
                self.lastIndex = visibleCell
                return
            }
            self.lastIndex = IndexPath(row: lastIndex.row + 1, section: 0)
            //collectionView.scrollToItem(at: self.lastIndex!, at: .centeredHorizontally, animated: true)

        }
    }
    
    
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float( self.collectionView.contentOffset.x + ( self.collectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.collectionView.visibleCells.count {
            let cell =  self.collectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex =  self.collectionView.indexPath(for: cell)!.row
            }
        }
        
        if closestCellIndex != -1 {
            let indexPath = IndexPath(row: closestCellIndex, section: 0)
            self.lastIndex = indexPath
            
            //self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapAnnotationDetailCell.id, for: indexPath) as! MapAnnotationDetailCell
        cell.delegate = viewModel?.delegate
        cell.setup(self.events[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .aspectGetSize(height: 100, width: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .makeWidth(20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: .makeWidth(37), bottom: 0, right: .makeWidth(37))
    }
}

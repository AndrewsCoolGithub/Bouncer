//
//  NewMessageViewController+FlowLayout.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/6/22.
//

import UIKit

extension NewMessageViewController: UICollectionViewDelegateFlowLayout{
    
    //MARK: - Default Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1{
            return 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1{
            return 10
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            ///Handles selection of bubbles
            handleSelectionOfBubble(indexPath)
        }else{
            ///Handles tap events on user search cells
            handleTapOnTable(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1{
            return UIEdgeInsets(top: 0, left: .makeWidth(20), bottom: 0, right: .makeWidth(20))
        }else{
            return .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == components.usersCV else {return}
        if !scrollView.isDecelerating{
            textField.resignFirstResponder()
            resetToDefault()
            updateSelected()
        }
    }
    
    //MARK: - Custom Methods
    ///Check for exisitng red cells and convert back to default, must call updateSelected() to enforce changes
    internal func resetToDefault() {
        
        let currentRedCellsIndexs = viewModel.selectedUsers.indices.filter({
            viewModel.selectedUsers[$0].isRed == true
        })
        
        currentRedCellsIndexs.forEach { index in
            viewModel.selectedUsers[index].isRed = false
        }
    }
    
    fileprivate func handleSelectionOfBubble(_ indexPath: IndexPath){
        guard let item = dataSourceSelected?.itemIdentifier(for: indexPath),
              item != ProfileBool(Profile.dummy) else {return} //Ignore textfield tap events
        guard let index = viewModel.selectedUsers.firstIndex(where: {$0 == item}) else {return}
        guard item.isRed else {
            resetToDefault()
            
            viewModel.selectedUsers[index].isRed = true
            updateSelected()
            return
        }
        
        ///Remove from dataSource
        viewModel.selectedUsers.remove(at: index)
        
        ///Set cell to left of selected to red, if none exists set cell to the right
        if index == 0 && viewModel.selectedUsers.count == 1{ ///Make cell to the right red
            viewModel.selectedUsers[0].isRed = true
        }else if index != 0{ ///Make cell to the left red
            viewModel.selectedUsers[index - 1].isRed = true
        }
            
        updateSelected()
    }
    
    fileprivate func handleTapOnTable(_ indexPath: IndexPath){
        guard let item = dataSourceSearch?.itemIdentifier(for: indexPath), item != User.shared.profile else {return}

        ///Toggle bubbleCell
        if let index = viewModel.selectedUsers.firstIndex(of: ProfileBool(item, false)){
            viewModel.selectedUsers.remove(at: index)
        }else if let index = viewModel.selectedUsers.firstIndex(of: ProfileBool(item, true)){
            viewModel.selectedUsers.remove(at: index)
        }else{
            viewModel.selectedUsers.append(ProfileBool(item, false))
        }
        
        updateSelected()
    }
}

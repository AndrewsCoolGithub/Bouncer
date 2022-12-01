//
//  NewMessageViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 11/25/22.
//

import UIKit

final class NewMessageViewController: UIViewController{
    
    let components = NewMessageComponents()
    
    var viewModel: NewMessageViewModel!
    
    private enum Section{
        case one
    }
    
    private enum Section2{
        case one
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Profile>?
    private var dataSource2: UICollectionViewDiffableDataSource<Section2, ProfileBool>?
    private var bubbleDelegate: NMSelectedUserDelegate!
    init(_ viewModel: NewMessageViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    var lastText: String = ""
    private let textField: TextField = {
        let textField = TextField()
        textField.addPadding(.both(10))
        textField.setDimensions(height: .wProportioned(50), width: .makeWidth(207))
        return textField
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bubbleDelegate = NMSelectedUserDelegate()
        view.backgroundColor = .greyColor()
        
        view.addSubview(components.backButton)
        components.backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .makeWidth(10), paddingLeft: .makeWidth(20))
        components.backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        view.addSubview(components.titleHeader)
        components.titleHeader.centerX(inView: view, topAnchor: components.backButton.topAnchor, paddingTop: .makeWidth(5))
        
        view.addSubview(components.doneButton)
        components.doneButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .makeWidth(10), paddingRight: .makeWidth(20))
        components.doneButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
        
        view.addSubview(components.toLabel)
        components.toLabel.anchor(top: components.backButton.bottomAnchor, paddingTop: .wProportioned(25))
        components.toLabel.anchor(left: components.backButton.leftAnchor)
        
        view.addSubview(components.usersCV)
        components.usersCV.delegate = self
        dataSource = makeDatasource()
        updateSnapshot(nil)
        
        view.addSubview(components.bubbleCV)
        components.bubbleCV.delegate = bubbleDelegate
        dataSource2 = makeDatasource2()
        updateSnapshot2()
        
        viewModel.$text.sink { [weak self] text in
            self?.textField.text = text
        }.store(in: &viewModel.cancellable)
        textField.delegate = self
        textField.customDelegate = self
    
    }
    
    private func makeDatasource() -> UICollectionViewDiffableDataSource<Section, Profile>{
        return UICollectionViewDiffableDataSource(collectionView: components.usersCV) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMessageUserCell.id, for: indexPath) as! NewMessageUserCell
            cell.setup(itemIdentifier)
            return cell
        }
    }
    
    private func makeDatasource2() -> UICollectionViewDiffableDataSource<Section2, ProfileBool>{
        return UICollectionViewDiffableDataSource(collectionView: components.bubbleCV) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NMSelectedUserCell.id, for: indexPath) as! NMSelectedUserCell
            if itemIdentifier == ProfileBool(Profile.dummy){
                cell.makeTextField(self?.textField)
            }else{
                cell.setup(itemIdentifier.profile, itemIdentifier.isRed)
            }
            
            return cell
        }
    }
    
    func updateSnapshot(_ users: [Profile]?){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        if let users = users{
            snapshot.appendSections([.one])
            snapshot.appendItems(users, toSection: .one)
        }else{
            snapshot.appendSections([.one])
            snapshot.appendItems(viewModel.suggestUsers, toSection: .one)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func updateSnapshot2(){
        var snapshot = NSDiffableDataSourceSnapshot<Section2, ProfileBool>()
        
        snapshot.appendSections([.one])
        snapshot.appendItems(viewModel.selectedUsers + [ProfileBool(Profile.dummy)], toSection: .one)
        
        
        dataSource2?.apply(snapshot, animatingDifferences: true)
    }
    
    deinit{
        bubbleDelegate = nil
    }
    
    @objc func popVC(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func finish(){
        
    }
    
    fileprivate class NMSelectedUserDelegate: NSObject, UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            return
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: .makeWidth(20), bottom: 0, right: .makeWidth(20))
        }
    }
}

extension NewMessageViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .makeWidth(414), height: .wProportioned(95))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
}

extension NewMessageViewController: UITextFieldDelegate{
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text!
        lastText = viewModel.text
        viewModel.text = searchText
        
        Task{
            if !searchText.isEmpty{
                let users = try await viewModel.searchUsers(searchText)
                updateSnapshot(users)
            }else{
                updateSnapshot(nil)
            }
        }
    }
}

extension  NewMessageViewController: CustomTextFieldDelegate{
    func textFieldDidDelete() {
        if lastText == ""{
            print("Turn next cell red")
            let count = viewModel.selectedUsers.count
            if count > 0 {
                viewModel.selectedUsers[count-1].isRed = true
                viewModel.redProfileIndex = count
            }
            updateSnapshot2()
        }
        lastText = viewModel.text
    }
}

protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

private class TextField: UITextField {
    weak var customDelegate: CustomTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        customDelegate?.textFieldDidDelete()
    }
}

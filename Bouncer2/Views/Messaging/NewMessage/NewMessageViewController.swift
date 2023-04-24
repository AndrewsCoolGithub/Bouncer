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
    
    internal enum Section{case one}
    internal var dataSourceSearch: UICollectionViewDiffableDataSource<Section, Profile>?
    
    internal enum Section2{case one}
    internal var dataSourceSelected: UICollectionViewDiffableDataSource<Section2, ProfileBool>?
    
    var lastText: String = ""
    internal let textField: NMTextField = {
        let textField = NMTextField()
        return textField
    }()

    //MARK: - Init
    init(_ viewModel: NewMessageViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .greyColor()
        setupViews()
        publishers()
    }
    
    fileprivate func setupViews() {
        view.addSubview(components.backButton)
        components.backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .makeWidth(10), paddingLeft: .makeWidth(20))
        components.backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        view.addSubview(components.titleHeader)
        components.titleHeader.centerX(inView: view, topAnchor: components.backButton.topAnchor, paddingTop: .makeWidth(5))
        
        view.addSubview(components.doneButton)
        components.doneButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .makeWidth(10), paddingRight: .makeWidth(20))
        components.doneButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(beginEditing))
        tapped.delegate = self
        components.bubbleCV.addGestureRecognizer(tapped)
        view.addSubview(components.bubbleCV)
        components.bubbleCV.anchor(top: components.titleHeader.bottomAnchor, paddingTop: .wProportioned(50))
        components.bubbleCV.delegate = self
        dataSourceSelected = selectedDatasource()
        updateSelected()
        
        view.addSubview(components.toLabel)
        components.toLabel.anchor(bottom: components.bubbleCV.topAnchor, paddingBottom: .wProportioned(10))
        components.toLabel.anchor(left: components.backButton.leftAnchor)
        
        view.addSubview(components.usersCV)
        components.usersCV.anchor(top: components.bubbleCV.bottomAnchor, bottom: view.bottomAnchor, paddingTop: .wProportioned(5))
        
        components.usersCV.delegate = self
        dataSourceSearch = searchDatasource()
        updateSearch(nil)
    }
    
    fileprivate func publishers() {
        viewModel.$text.sink { [weak self] text in
            self?.textField.text = text
        }.store(in: &viewModel.cancellable)
        textField.delegate = self
        textField.customDelegate = self
        
        viewModel.$selectedUsers.sink { [weak self] users in
            self?.textField.placeholder = users.isEmpty ? "Search" : nil
        }.store(in: &viewModel.cancellable)
    }
    
    //MARK: - Datasources
    private func searchDatasource() -> UICollectionViewDiffableDataSource<Section, Profile>{
        return UICollectionViewDiffableDataSource(collectionView: components.usersCV) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMessageUserCell.id, for: indexPath) as! NewMessageUserCell
            cell.setup(itemIdentifier)
            return cell
        }
    }
    
    private func selectedDatasource() -> UICollectionViewDiffableDataSource<Section2, ProfileBool>{
        return UICollectionViewDiffableDataSource(collectionView: components.bubbleCV) { [weak self] collectionView, indexPath, itemIdentifier in
            if itemIdentifier.isRed{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NMSelectedUserCell.id, for: indexPath) as! NMSelectedUserCell
                cell.setup(itemIdentifier.profile)
                return cell
            }else if itemIdentifier == ProfileBool(Profile.dummy){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NMTextFieldCell.id, for: indexPath) as! NMTextFieldCell
                cell.makeTextField(self?.textField)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NMDefaultUserCell.id, for: indexPath) as! NMDefaultUserCell
                cell.setup(itemIdentifier.profile)
                return cell
            }
        }
    }
    
    //MARK: - Snapshot Updaters
    func updateSearch(_ users: [Profile]?){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        if let users = users{
            snapshot.appendSections([.one])
            snapshot.appendItems(users, toSection: .one)
        }else{
            snapshot.appendSections([.one])
            snapshot.appendItems(viewModel.suggestUsers, toSection: .one)
        }
        
        dataSourceSearch?.apply(snapshot, animatingDifferences: true)
    }
    
    func updateSelected(){
        var snapshot = NSDiffableDataSourceSnapshot<Section2, ProfileBool>()
        
        snapshot.appendSections([.one])
        snapshot.appendItems(viewModel.selectedUsers + [ProfileBool(Profile.dummy)], toSection: .one)
        
        dataSourceSelected?.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
            guard let indexToScroll = self?.dataSourceSelected?.indexPath(for: ProfileBool(Profile.dummy)) else {return}
            self?.components.bubbleCV.scrollToItem(at: indexToScroll, at: .right, animated: true)
        })
    }
    
    //MARK: - Actions
    @objc func popVC(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func finish(){
        do{
            let messageDetail = try viewModel.createNewChat(viewModel.selectedUsers.map({$0.profile}))
            let profiles = viewModel.selectedUsers.map({$0.profile})
            let controller = ChatViewController()
            controller.loadMessages(for: messageDetail, profiles: profiles)
            navigationController?.popViewController(animated: false)
            navigationController?.pushViewController(controller, animated: true)

        }catch{
            showMessage(withTitle: "Failed to create chat", message: "\(error.localizedDescription)")
        }
    }
    
    @objc func beginEditing(){
        if viewModel.selectedUsers.count == 0 {
            textField.becomeFirstResponder()
        }
    }
}


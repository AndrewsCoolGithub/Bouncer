//
//  Messaging.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 8/22/22.
//

import Foundation
import UIKit
import Combine

class MessageSuite: UIViewController{
    
    let components = MessageSuiteViewComponents()
    let searchController = UISearchController(searchResultsController: MessageSuiteSearchResults())
    var cancellable = Set<AnyCancellable>()
    let viewModel = MessageSuiteViewModel()
    enum Section{ case section}
    var dataSource: UICollectionViewDiffableDataSource<Section, MessageDetail>?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setupCV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        view.addSubview(components.messagesCollectionView)
        components.messagesCollectionView.delegate = self
        components.messagesCollectionView.frame.size = CGSize(width: .makeWidth(414), height: (.makeHeight(896) - SafeArea.topSafeArea() - .makeWidth(60)))
        components.messagesCollectionView.frame.origin = CGPoint(x: 0, y: SafeArea.topSafeArea() + .makeWidth(60))
        components.messagesCollectionView.alwaysBounceVertical = true
        components.messagesCollectionView.delegate = self
        
        view.addSubview(components.backButton)
        components.backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .makeWidth(10), paddingLeft: .makeWidth(20))
        
        view.addSubview(components.titleHeader)
        components.titleHeader.centerX(inView: view, topAnchor: components.backButton.topAnchor, paddingTop: .makeWidth(5))
    }
    
    fileprivate func setupCV(){
        dataSource = UICollectionViewDiffableDataSource<Section, MessageDetail>(collectionView: components.messagesCollectionView, cellProvider: { collectionView, indexPath, messageDetail in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.id, for: indexPath) as! MessageCell
            cell.setup(messageDetail)
            return cell
        })
        
        viewModel.$messageDetails.sink { [weak self] messageDetails in
            guard messageDetails != nil else {return}
            self?.makeSnapshot(messageDetails!)
        }.store(in: &cancellable)
    }
    
    fileprivate func makeSnapshot(_ data: [MessageDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MessageDetail>()
        snapshot.appendSections([.section])
        snapshot.appendItems(data, toSection: .section)
        snapshot.reconfigureItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
//    fileprivate func setupNavBar(){
//        navigationItem.searchController = searchController
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.backgroundColor = .greyColor()
//        let backConfig = UIImage.SymbolConfiguration(pointSize: .makeWidth(25))
//        let yourBackImage = UIImage(systemName: "chevron.left", withConfiguration: backConfig)?.withInsets(UIEdgeInsets(top: 0, left: .makeWidth(12.5), bottom: 0, right: 0))
//        navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.showsLargeContentViewer = true
//        title = "Messages"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.poppinsMedium(size: .makeWidth(19))]
//    }
}

extension MessageSuite: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .aspectGetSize(height: 95, width: 414)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let messageDetail = dataSource?.itemIdentifier(for: indexPath), messageDetail.id != nil else {return}
        let controller = ChatViewController()
        controller.loadMessages(for: messageDetail, users: messageDetail.users)
        navigationController?.pushViewController(controller, animated: true)
    }
}

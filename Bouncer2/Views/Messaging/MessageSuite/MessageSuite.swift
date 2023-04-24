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
    var cancellable = Set<AnyCancellable>()
    var cancel: AnyCancellable?
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
        components.backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        view.addSubview(components.titleHeader)
        components.titleHeader.centerX(inView: view, topAnchor: components.backButton.topAnchor, paddingTop: .makeWidth(5))
        
        view.addSubview(components.newMessageButton)
        components.newMessageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .makeWidth(10), paddingRight: .makeWidth(20))
        
        components.newMessageButton.addTarget(self, action: #selector(newMessage(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupCV(){
        dataSource = UICollectionViewDiffableDataSource<Section, MessageDetail>(collectionView: components.messagesCollectionView, cellProvider: { collectionView, indexPath, messageDetail in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.id, for: indexPath) as! MessageCell
            cell.setup(MessageCellViewModel(messageDetail))
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
    
    @objc func newMessage(_ sender: UIButton){
        
        let isLoading = viewModel.isLoading
        cancel = viewModel.$suggestedUsers.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] suggested in
            let indicator = self?.components.indicator
            if suggested.isEmpty && isLoading{
                self?.view.addSubview(indicator ?? UIView())
                indicator?.startAnimating()
            }else{
                indicator?.stopAnimating()
                indicator?.removeFromSuperview()
                let controller = NewMessageViewController(NewMessageViewModel(self?.viewModel.messageDetails, suggested))
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        })
    }
    
    @objc func popVC(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
}

extension MessageSuite: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .aspectGetSize(height: 95, width: 414)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let messageDetail = dataSource?.itemIdentifier(for: indexPath), let index = dataSource?.indexPath(for: messageDetail), messageDetail.id != nil else {return}
        guard let cell = collectionView.cellForItem(at: index) as? MessageCell else {return}
        let profiles = cell.profiles
        let controller = ChatViewController()
        controller.loadMessages(for: messageDetail, profiles: profiles)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//
//  TabBarController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 6/19/22.
//

import Foundation
import UIKit
import Combine
import Firebase

class TabBarController: UITabBarController{
    
    let controllers = [MapViewController(), EventList(), EventSuite()]
   
    
    fileprivate var components = TabBarViewComponents()
    var cancellable = Set<AnyCancellable>()
    
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        title = ""
        setViewControllers(controllers, animated: true)
        tabBar.items?[0].image = UIImage(systemName: "map.fill")
        tabBar.items?[1].image = UIImage(systemName: "list.bullet")
        tabBar.items?[2].image = UIImage(systemName: "plus.square.dashed")
        tabBar.tintColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .clear
        view.backgroundColor = .clear
        
        listenForProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    fileprivate func setupUI(){
        let profileButton = components.profileButton
        view.addSubview(profileButton)
        profileButton.layer.cornerRadius = .makeWidth(25)
        profileButton.setDimensions(height: .makeWidth(50), width: .makeWidth(50))
        profileButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: .makeWidth(5))
        profileButton.anchor(left: view.leftAnchor, paddingLeft: .makeWidth(10))
        profileButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        
        let searchButton = components.searchButton
        view.addSubview(searchButton)
        searchButton.setDimensions(height: .makeWidth(40), width: .makeWidth(40))
        searchButton.centerY(inView: profileButton, leftAnchor: profileButton.rightAnchor, paddingLeft: .makeWidth(15))
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        
        let messageButton = components.messageButton
        view.addSubview(messageButton)
        messageButton.setDimensions(height: .makeWidth(40), width: .makeWidth(40))
        messageButton.centerYright(inView: profileButton, rightAnchor: view.rightAnchor, paddingRight: .makeWidth(15))
        messageButton.addTarget(self, action: #selector(openMessages), for: .touchUpInside)
    }
    
    fileprivate func listenForProfileImage() {
        User.shared.$imageURL.sink { [weak self] imageURL in
            guard let imageURL = imageURL, let self = self else {
                return}
            let skeletonGradient = self.components.profileSkeletonGradient
            let profileButton = self.components.profileButton
            profileButton.layer.addSublayer(skeletonGradient)
            profileButton.imageView?.sd_setImage(with: URL(string: imageURL), completed: { i, e, c, u in
                profileButton.setImage(i, for: .normal)
                skeletonGradient.removeFromSuperlayer()
            })
        }.store(in: &cancellable)
    }
    
    @objc func openProfile(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let searchController = SearchViewController()
    @objc func openSearch(){
        navigationController?.pushViewController(searchController, animated: true)
    }
    
   
    @objc func openMessages(){
        let messageController = MessageSuite()
        navigationController?.pushViewController(messageController, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private struct TabBarViewComponents: SkeletonLoadable{
     let profileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
     let searchButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(22), weight: .semibold)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .center
        button.tintColor = .white
        button.layer.cornerRadius = .makeWidth(20)
        button.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        return button
    }()
    
    let messageButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(20), weight: .regular)
        button.setImage(UIImage(systemName: "bubble.right.fill", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .center
        button.tintColor = .white
        button.layer.cornerRadius = .makeWidth(20)
        button.backgroundColor = .nearlyBlack().withAlphaComponent(0.2)
        return button
   }()
    
    lazy var profileSkeletonGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        gradient.add(animation, forKey: "backgroundColor")
        gradient.frame = profileButton.bounds
        return gradient
    }()
}

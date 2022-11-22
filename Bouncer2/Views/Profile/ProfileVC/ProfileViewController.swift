//
//  ProfileViewController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/9/22.
//

import Foundation
import UIKit
import Combine

//TODO: 1. Add Last Seen (City, State)


class ProfileViewController: UIViewController{
    
    var components = ProfileViewComponents()
    
    
    
    var viewModel: ProfileViewModel!
    var cancellable = Set<AnyCancellable>()
    var isCurrentUser: Bool = false
    
    //MARK: - viewDidDisappear
    ///removes listener, and cancels publishers when viewing other users profiles
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isCurrentUser{
            if let id  = viewModel.id {
                FirestoreSubscription.cancel(id: id)
            }
            
            viewModel.cancellable.forEach({$0.cancel()})
            cancellable.forEach({$0.cancel()})
        }
    }
    
    //MARK: INIT
    init(profile: Profile? = nil){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .greyColor()
        viewModel = ProfileViewModel(profile) ///Set viewModel based on incoming data or lack thereof (Current User)
        isCurrentUser = profile == nil 
        setupInitialData(profile)
        
        setupUI()
       
        listenForLabelChanges()
        listenForImageChanges()
        listenForColorChanges()
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        if isCurrentUser{
            components.actionButton.gradientColors = (User.shared.colors.uiImageColors(), false)
            components.actionButton.center = CGPoint(x: .makeWidth(87 + 120), y: components.bioLabel.frame.maxY + .makeWidth(103.5))
            components.actionButton.setTitle("Edit", for: .normal)
            components.actionButton.addTarget(self, action: #selector(setupEditFunctionality), for: .touchUpInside)
        }else{
            components.actionButton.gradientColors = (viewModel.colors?.uiImageColors() ?? User.defaultColors, false)
            components.actionButton.center = CGPoint(x: .makeWidth(50 + 120), y: components.bioLabel.frame.maxY + .makeWidth(103.5))
            components.actionButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
//            if User.shared.following.contains(viewModel.id!){
//                components.actionButton.setTitle("Unfollow", for: .normal)
//            }else{
//                components.actionButton.setTitle("Follow", for: .normal)
//            }
        }
    }
    
    //MARK: - Main Actions (i.e Follow, Unfollow, Share)
    @objc func follow(){
        viewModel.toggleFollow()
    }
    
    
    //MARK: - Navigation
    ///Edit profile popup
    @objc func setupEditFunctionality(){
        let editView = ProfileEditPanel(viewModel: self.viewModel)
        editView.addPanel(toParent: self, animated: true)
    }
    
    ///Users settings
    @objc func openSettings(){
        let tempSignOut = UIMenu(children: [
            UIAction(title: "Sign Out", image: UIImage(systemName: "arrowshape.turn.up.forward")) { [weak self] _ in
                do{
                    try self?.viewModel.signOut()
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as! UIWindowScene
                    let window = windowScene.windows.first!
                    let navCont = UINavigationController(rootViewController: AccountSignUpEntry())
                    navCont.interactivePopGestureRecognizer?.isEnabled = false
                    navCont.navigationBar.isHidden = true
                    guard (window.rootViewController as? UInt32) != nil else {
                        fatalError("Just send to homescreen for now")
                    }
                }catch{
                    self?.showMessage(withTitle: "Oops", message: "Can't sign out, here's why: \(error.localizedDescription)")
                }
            }
        ])
            
        components.settingsButton.showsMenuAsPrimaryAction = true
        components.settingsButton.menu = tempSignOut
    }
    
    ///Block and Report screen
    func openBlockReport(){
        
    }
    
    //MARK: - Initial Data
    ///Profile Model isn't used when viewing Current Users profile
    fileprivate func setupInitialData(_ profile: Profile?) {
        let randInt = Int.random(in: 0...10)
        let bannerImageView = components.bannerImageView
        let bannerSkeleton = components.bannerSkeletonGradient
        let backDropData = profile != nil ? profile!.backdrop_url : User.shared.backdropImageURL
        let backdropURL = backDropData ?? User.defaultbackdrop(int: randInt)
        bannerImageView.layer.addSublayer(bannerSkeleton)
        
        bannerImageView.sd_setImage(with: URL(string: backdropURL)) {  i, e, c, u in
            bannerSkeleton.removeFromSuperlayer()
        }
        
        let profileImageView = components.profilePictureImageView
        profileImageView.gradientColors = (profile?.colors?.uiImageColors() ?? User.defaultColors, false)
        
        let profileSkeleton = components.profileSkeletonGradient
        let profileImageURL = profile != nil ? profile!.image_url : User.shared.imageURL
        profileImageView.layer.addSublayer(profileSkeleton)
        
        if let profileImageURL = profileImageURL {
            profileImageView.sd_setImage(with: URL(string: profileImageURL)) {  i, e, c, u in
                profileSkeleton.removeFromSuperlayer()
            }
        }else{
            profileImageView.image = UIImage(named: "DefaultProfileImage")
        }
        
        components.displayNameLabel.text = profile?.display_name ?? User.shared.displayName
        components.userNameLabel.text = profile?.user_name ?? User.shared.userName
        components.bioLabel.text = profile?.bio ?? User.shared.bio
        let followerCount = profile != nil ? profile!.followers?.count : User.shared.followers.count
        let followingCount = profile != nil ? profile!.following?.count : User.shared.following.count
        components.followRLabel.text = "\(followerCount ?? 0) Followers"
        components.followIngLabel.text = "\(followingCount ?? 0) Following"
    }
    
    //MARK: - Setup UI
    fileprivate func setupUI() {
        view.addSubview(components.bannerImageView)
        
        view.addSubview(components.profilePictureImageView)
        
        view.addSubview(components.backButton)
        
        components.backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: .makeHeight(15), paddingLeft: .makeWidth(20))
        components.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(components.settingsButton)
        components.settingsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: .makeHeight(15), paddingRight: .makeWidth(20))
        components.settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        view.addSubview(components.displayNameLabel)
        components.displayNameLabel.anchor(top: components.bannerImageView.bottomAnchor, left: components.profilePictureImageView.rightAnchor, paddingTop: .makeHeight(10), paddingLeft: .makeWidth(20))
        
        view.addSubview(components.userNameLabel)
        components.userNameLabel.anchor(top: components.displayNameLabel.bottomAnchor, left: components.displayNameLabel.leftAnchor)
        
        view.addSubview(components.bioLabel)
        components.bioLabel.centerX(inView: view, topAnchor: components.profilePictureImageView.bottomAnchor, paddingTop: .makeHeight(20))
        
        view.addSubview(components.followRLabel)
        components.followRLabel.anchor(top: components.bioLabel.bottomAnchor, left: components.bioLabel.leftAnchor, paddingTop: .makeHeight(20))
        
        view.addSubview(components.followIngLabel)
        components.followIngLabel.anchor(top: components.bioLabel.bottomAnchor, left: components.followRLabel.rightAnchor, paddingTop: .makeHeight(20), paddingLeft: .makeWidth(30))
        
        view.addSubview(components.actionButton)
    }
    
    
    //MARK: - Publishers for Profile Updates
    ///Text Changes
    func listenForLabelChanges(){
        viewModel.$userName.sink { [weak self] userName in
            guard let self = self else {return}
            let userNameLabel = self.components.userNameLabel
            if userNameLabel.text != userName {
                UIView.transition(with: userNameLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    userNameLabel.text = userName
                }
            }
        }.store(in: &cancellable)
        
        viewModel.$displayName.sink { [weak self] displayName in
            guard let self = self else {return}
            let displayNameLabel = self.components.displayNameLabel
            if displayNameLabel.text != displayName {
                UIView.transition(with: displayNameLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    displayNameLabel.text = displayName
                }
            }
        }.store(in: &cancellable)
        
        let bioLabel = components.bioLabel
        viewModel.$bio.sink {  bio in
            if bioLabel.text != bio {
                UIView.transition(with: bioLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    bioLabel.text = bio
                }
            }
        }.store(in: &cancellable)
        
        let followRLabel = components.followRLabel
        viewModel.$followers.sink { [weak self] followers in
            DispatchQueue.main.async {
                if followRLabel.text != "\(followers.count) Followers" {
                    UIView.transition(with: followRLabel, duration: 0.3, options: .transitionCrossDissolve) {
                        followRLabel.text = "\(followers.count) Followers"
                    }
                }
                guard let id = User.shared.id, let vmID = self?.viewModel.id, let actionButton = self?.components.actionButton, id != vmID else {return}
                if followers.contains(id){
                    UIView.transition(with: actionButton, duration: 1, options: [.transitionCrossDissolve]) {
                        actionButton.setTitle("Unfollow", for: .normal)
                        actionButton.isUserInteractionEnabled = false
                    } completion: { bool in
                        actionButton.isUserInteractionEnabled = true
                    }
                }else{
                    UIView.transition(with: actionButton, duration: 1, options: [.transitionCrossDissolve]) {
                        actionButton.setTitle("Follow", for: .normal)
                        actionButton.isUserInteractionEnabled = false
                    } completion: { bool in
                        actionButton.isUserInteractionEnabled = true
                    }
                    

                }
            }
        }.store(in: &cancellable)
        
        let followIngLabel = components.followIngLabel
        viewModel.$following.sink { following in
            if followIngLabel.text != "\(following.count) Following"{
                UIView.transition(with: followIngLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    followIngLabel.text = "\(following.count) Following"
                }
            }
        }.store(in: &cancellable)
    }
    
    /// Image Changes
    func listenForImageChanges(){
        let bannerImageView = components.bannerImageView
        let profileImageView = components.profilePictureImageView
      
        viewModel.$actualProfileImage.sink {  image in
            guard let image = image else {return}
            UIView.transition(with: profileImageView, duration: 0.4, options: .transitionCrossDissolve) {
                profileImageView.image = image
            }
        }.store(in: &cancellable)
        
        viewModel.$actualBackDropImage.sink {  backdrop in
            guard let backdrop = backdrop else {return}
            UIView.transition(with: bannerImageView, duration: 0.4, options: .transitionCrossDissolve) {
                bannerImageView.image = backdrop
            }
        }.store(in: &cancellable)
    }
    
    /// Color Changes
    func listenForColorChanges(){
        let actionButton = components.actionButton
        let profileImageView = components.profilePictureImageView
        viewModel.$colors.sink {  colors in
            guard let colors = colors else {return}
            actionButton.gradientColors = (colors.uiImageColors(), true) //Update Action Button Gradient
            profileImageView.gradientColors = (colors.uiImageColors(), true) //Update Profile Picture Gradient
        }.store(in: &cancellable)
    }
    
    @objc func dismissView(){
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

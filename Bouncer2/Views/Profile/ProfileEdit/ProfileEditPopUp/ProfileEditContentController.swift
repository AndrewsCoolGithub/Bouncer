//
//  ProfileEditContentController.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 7/15/22.
//

import Foundation
import UIKit
import YPImagePicker
import FloatingPanel


class ProfileEditContentController: UIViewController{
    
    let config = UIImage.SymbolConfiguration(pointSize: .makeWidth(50))
    var tableView: UITableView?
    
    unowned var viewModel: ProfileViewModel!
    
    init(viewModel: ProfileViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = .makeHeight(85)
        tableView?.register(ProfileEditCell.self, forCellReuseIdentifier: ProfileEditCell.id)
        tableView?.showsVerticalScrollIndicator = false
        
        guard let tableView = tableView else{
            return
        }
        tableView.backgroundColor = .greyColor()
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
                              
         
    func selectAction(_ indexPathRow: Int){
        guard let tab = EditTabsOptions(rawValue: indexPathRow) else {return}
        switch tab {
        case .ProfileImage:
            openProfileCameraRoll()
        case .BackdropImage:
            openBackdropCameraRoll()
        case .Name:
            openTextEdit(tab)
        case .Username:
            openTextEdit(tab)
        case .Bio:
            openTextEdit(tab)
        case .Colors:
            openColorEdit()
        }
        
        /// Updates to the viewModel for a presented image picker require self
        if tab != .BackdropImage && tab != .ProfileImage{
            dismissPopUp()
        }
    }
    
    
    func openProfileCameraRoll(){
        var config = YPImagePickerConfiguration()
        config.showsCrop = .circle
        config.shouldSaveNewPicturesToAlbum = false
        config.showsPhotoFilters = false
        config.fonts.pickerTitleFont = .poppinsMedium(size: .makeWidth(20))
        config.fonts.navigationBarTitleFont = .poppinsMedium(size: .makeWidth(20))
        config.fonts.leftBarButtonFont = .poppinsRegular(size: .makeWidth(20))
        config.fonts.rightBarButtonFont = .poppinsRegular(size: .makeWidth(20))
        config.screens = [.library]
        let picker = YPImagePicker(configuration: config)
        
       
        picker.didFinishPicking { [unowned picker, weak self] items, _ in
            if let photo = items.singlePhoto, let modified = photo.modifiedImage {
                Task{
                    self?.viewModel.actualProfileImage = modified
                    try await AuthManager.shared.uploadProfilePicture(modified)
                }
            }
            self?.dismiss(animated: true)
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    deinit{
        print("DENIT PROFILE CONTENT VC")
        return
    }
    
    func openColorEdit(){
        let controller = ProfileColorEdit(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
//        dismissPopUp()
    }
    
    func openBackdropCameraRoll(){
        var config = YPImagePickerConfiguration()
        config.showsCrop = .rectangle(ratio: 2.0)
        config.shouldSaveNewPicturesToAlbum = false
        
        config.fonts.pickerTitleFont = .poppinsMedium(size: .makeWidth(20))
        config.fonts.navigationBarTitleFont = .poppinsMedium(size: .makeWidth(20))
        config.fonts.leftBarButtonFont = .poppinsRegular(size: .makeWidth(20))
        config.fonts.rightBarButtonFont = .poppinsRegular(size: .makeWidth(20))
        config.colors.tintColor = .white
        config.showsPhotoFilters = false
        config.screens = [.library]
        let picker = YPImagePicker(configuration: config)
        
       
        picker.didFinishPicking { [unowned picker, weak self] items, _ in
            if let photo = items.singlePhoto, let modified = photo.modifiedImage {
                Task{
                    
                    self?.viewModel.actualBackDropImage = modified
                    try await AuthManager.shared.uploadBackdropPicture(modified)
                }
            }
            self?.dismiss(animated: true)
            picker.dismiss(animated: true)
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    func openTextEdit(_ tab: EditTabsOptions){
        switch tab{
        case .Name:
            let textEdit = ProfileTextEdit(.name, viewModel: viewModel)
            navigationController?.pushViewController(textEdit, animated: true)
//            dismissPopUp()
        case .Bio:
            let textEdit = ProfileTextEdit(.bio, viewModel: viewModel)
            navigationController?.pushViewController(textEdit, animated: true)
//            dismissPopUp()
        case .Username:
            let textEdit = ProfileTextEdit(.username, viewModel: viewModel)
            navigationController?.pushViewController(textEdit, animated: true)
//            dismissPopUp()
        default:
            return
        }
    }
    
    func dismissPopUp(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: DispatchWorkItem(block: {
            self.dismiss(animated: true)
        }))
    }
    
    
    
    enum EditTabsOptions: Int, CaseIterable, CustomStringConvertible {
        case ProfileImage
        case BackdropImage
        case Name
        case Username
        case Bio
        case Colors
        
        var description: String {
            switch self{
                
            case .ProfileImage:
                return "Profile Photo"
            case .BackdropImage:
                return "Backdrop Photo"
            case .Name:
                return "Name"
            case .Username:
                return "Username"
            case .Bio:
                return "Bio"
            case .Colors:
                return "Colors"
            }
        }
    }
}

extension ProfileEditContentController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditTabsOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditCell.id, for: indexPath) as! ProfileEditCell
        guard let tab = EditTabsOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.setup(tab)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .greyColor()
        view.setDimensions(height: .makeHeight(50), width: .makeWidth(414))
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .greyColor()
        view.setDimensions(height: .makeHeight(50), width: .makeWidth(414))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .makeHeight(30)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .makeHeight(0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectAction(indexPath.row)
    }
}
